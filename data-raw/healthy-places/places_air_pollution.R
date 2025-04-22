# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Get data ----
# LA Codes

ltla_lookup <- lookup_ltla_ltla |>
  filter(str_detect(ltla23_code, "N")) |>
  select(ltla23_code, ltla23_name)

# Air Pollution
# Source: https://uk-air.defra.gov.uk/data/pcm-data
air_pollution_raw <-
  read_csv(
    "https://uk-air.defra.gov.uk/datastore/pcm/popwmpm252019byUKlocalauthority.csv",
    skip = 2
  )

# Use the anthropogenic component for health burden calculations
air_pollution <-
  air_pollution_raw |>
  select(
    ltla23_name = `Local Authority`,
    air_pollution_weighted = `PM2.5 2019 (anthropogenic)`
  )

# Join datasets
places_air_pollution <-
  ltla_lookup |>
  left_join(air_pollution, by = "ltla23_name") |>
  select(
    ltla24_code = ltla23_code,
    air_pollution_weighted,
    -ltla23_name
  ) |>
  mutate(year = "2019")

places_air_pollution <- places_air_pollution |>
  mutate(domain = "places") |>
  mutate(subdomain = "living conditions") |>
  mutate(is_higher_better = FALSE)


# ---- Save output to data/ folder ----
usethis::use_data(places_air_pollution, overwrite = TRUE)
