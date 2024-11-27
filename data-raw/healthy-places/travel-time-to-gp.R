library(tidyverse)
library(geographr)
library(osmdata)
library(jsonlite)
library(httr)
library(sf)
library(traveltimeR)
library(readxl)

Sys.setenv(TRAVELTIME_ID = "<INSERT YOUR ID HERE>")
Sys.setenv(TRAVELTIME_KEY = "<INSERT YOUR API KEY HERE>")

# ---- Fetch GPs in Northern Ireland ----
# Bounding box for Northern Ireland
ni_bb <-
  getbb("Northern Ireland")

# Search for GPs
GPs <- opq(ni_bb, timeout = 1000) %>%
  add_osm_feature("amenity", "doctors") %>%
  osmdata_sf()

# Get Local Authorities in Great Britain for the next step
ni_lad <-
  boundaries_ltla21 |>
  filter(str_detect(ltla21_code, "^N"))

# Some GPs are not in Northern Ireland - remove them from the dataset
ni_GPs <-
  GPs$osm_points[ni_lad, ] |>
  select(osm_id)

# - Test plot to check GP locations -
# ni_lad |>
#   ggplot() +
#   geom_sf(
#     fill = NA,
#     colour = "black"
#   ) +
#   geom_sf(
#     data = ni_GPs,
#     inherit.aes = FALSE
#   )

# Calculate neighbours for each Local Authority
neighbours <- st_touches(ni_lad)

# Look up the Local Authority each GP is in
ni_GPs_lad <-
  st_join(ni_GPs, ni_lad) |>
  filter(!is.na(ltla21_code)) |>
  mutate(
    # Round coords to 3 decimal points to save memory
    lat = st_coordinates(geometry)[,2] |> round(3),
    lng = st_coordinates(geometry)[,1] |> round(3)
  ) |>
  st_drop_geometry() |>
  as_tibble() |>
  select(
    ltla21_code,
    osm_id,
    lat,
    lng
  )

# ---- Population-weighted centroids for Super Data Zones ----
# Source: https://www.nisra.gov.uk/publications/census-2021-population-weighted-centroids-data-zones-and-super-data-zones
GET(
  "https://www.nisra.gov.uk/system/files/statistics/geography-census-2021-population-weighted-centroids-for-data-zones-and-super-data-zones.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

sdz21_centroids_raw <- read_excel(tf, sheet = "SDZ2021")

sdz21_centroids <-
  sdz21_centroids_raw |>
  st_as_sf(coords = c("X", "Y"), crs = 29902) |>  # The coordinates are in Irish Grid
  st_transform(crs = 4326) |>
  mutate(
    # Round coords to 3 decimal points to save memory
    lat = st_coordinates(geometry)[,2] |> round(3),
    lng = st_coordinates(geometry)[,1] |> round(3)
  ) |>
  st_drop_geometry() |>
  select(
    sdz21_code = SDZ2021_code,
    lat,
    lng
  )

# ---- Calculate travel time between data zones and GPs ----
# Taking each Local Authority in Northern Ireland one at a time,
# calculate the travel distance/time from the Super Data Zones within that LAD
# to each GP in the LAD as well as in neighbouring LADs

# Set up tibbles to store results
GP_travel_time <- tibble()

# Uncomment this code (and change the filename) if you need to restart from any previous point
# GP_travel_time <- read_csv("data-raw/healthy-places/GP_travel_time-6.csv") |>
#   mutate(osm_id = as.character(osm_id))

for (i in 1:nrow(ni_lad)) {
  current_ltla_code <- ni_lad[i,]$ltla21_code

  current_sdz_codes <-
    lookup_dz21_sdz21_dea14_lgd14 |>
    filter(lgd14_code == current_ltla_code) |>
    distinct(sdz21_code) |>
    pull(sdz21_code)

  current_sdz_centroids <-
    sdz21_centroids |>
    filter(sdz21_code %in% current_sdz_codes)

  # Get GPs in the current LAD and its neighbouring LADs
  current_neighbours <-
    ni_lad[neighbours[[i]],] |>
    pull(ltla21_code)

  current_GPs <-
    ni_GPs_lad |>
    filter(ltla21_code %in% c(current_ltla_code, current_neighbours)) |>
    # We'll combine the GPs with Super Data Zones - use the same column name for IDs
    rename(id = osm_id)

  # Loop through each Super Data Zone in the current Local Authority,
  # calculating travel time to the current set of GPs
  for (sdz in 1:nrow(current_sdz_centroids)) {
    current_sdz_centroid <-
      current_sdz_centroids |>
      slice(sdz) |>
      rename(id = sdz21_code)

    # Need to make a list of locations with the `traveltimeR::make_locations()` function
    # First we must collate the current set of locations into a single dataframe
    current_locations_df <- bind_rows(current_sdz_centroid, current_GPs)

    # Then use the approach shown in Travel Time's R package readme: https://docs.traveltime.com/api/sdks/r
    current_locations <- apply(current_locations_df, 1, function(x)
      make_location(id = x['id'], coords = list(lat = as.numeric(x["lat"]),
                                                lng = as.numeric(x["lng"]))))
    current_locations <- unlist(current_locations, recursive = FALSE)

    current_search <-
      make_search(
        id = str_glue("search {current_sdz_centroid$id}"), # Make up an ID for the search so each search is unique
        departure_location_id = current_sdz_centroid$id,
        arrival_location_ids = as.list(current_GPs$id),
        travel_time = 10800,  # 3 hours (in seconds)
        properties = list("travel_time"),
        arrival_time_period = "weekday_morning",
        transportation = list(type = "public_transport")
      )

    current_result <- time_filter_fast(locations = current_locations, arrival_one_to_many = current_search)

    # Convert JSON result to a data frame
    current_result_df <- fromJSON(current_result$contentJSON, flatten = TRUE)

    # Some Super Data Zones can't reach any GPs - ignore them
    if (length(current_result_df$results$locations[[1]]) > 0) {
      current_travel_time <-
        current_result_df$results$locations[[1]] |>
        as_tibble() |>
        mutate(
          # `travel_time` column is in seconds; convert to minutes
          travel_time_mins = properties.travel_time / 60,
          sdz21_code = current_sdz_centroid$id
        ) |>
        select(sdz21_code, osm_id = id, travel_time_mins)

      GP_travel_time <- bind_rows(GP_travel_time, current_travel_time)
    }

    print(str_glue("Finished SDZ {sdz} of {nrow(current_sdz_centroids)}"))
    Sys.sleep(2)
  }

  # Save progress to disc after each LAD
  # NOTE: Please manually delete these files once the loop completes
  write_csv(GP_travel_time, str_glue("data-raw/healthy-places/GP_travel_time-{i}.csv"))

  print(str_glue("Finished Local Authority {i} of {nrow(ni_lad)}"))
}

GP_travel_time <- distinct(GP_travel_time)

# Save the complete dataset for travel time from Intermediate Zones to GPs
# This won't be available in the R package itself but want to keep it in the GitHub repo
# since it takes quite a while to calculate
write_csv(GP_travel_time, "data-raw/healthy-places/GP_travel_time.csv")

GP_travel_time <- read_csv("data-raw/healthy-places/GP_travel_time.csv")

# Look up Local Authorities for each Intermediate Zone and GP
lookup_sdz_lad <-
  lookup_dz21_sdz21_dea14_lgd14 |>
  distinct(sdz21_code, ltla21_code = lgd14_code, ltla_name = lgd14_name)

GP_travel_time <-
  GP_travel_time |>
  left_join(lookup_sdz_lad)

# What are the fastest travel times within each Intermediate Zone?
GP_travel_time_fastest <-
  GP_travel_time |>
  select(-osm_id) |>  # We don't need to know the GP ID for this
  group_by(sdz21_code) |>
  filter(travel_time_mins == min(travel_time_mins)) |>
  ungroup() |>
  distinct()

# Plot the distribution of fastest travel times within each Local Authority
GP_travel_time_fastest |>
  ggplot(aes(x = travel_time_mins)) +
  geom_histogram(binwidth = 5) +
  facet_wrap(~ltla_name, scales = "free")

# Calculate average travel time for each Local Authority
# Several of the distributions of travel times within Local Authorities are skewed
# so we'll take the median travel time
places_gp_travel_time <-
  GP_travel_time_fastest |>
  group_by(ltla21_code) |>
  summarise(median_travel_time = median(travel_time_mins, na.rm = TRUE)) |>
  ungroup() |>
  mutate(year = year(now())) |>
  rename(lgd14_code = ltla21_code,
         gp_median_travel_time = median_travel_time)

# ---- Save output to data/ folder ----
usethis::use_data(places_gp_travel_time, overwrite = TRUE)
