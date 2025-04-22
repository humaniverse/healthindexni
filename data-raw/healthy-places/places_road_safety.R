# ---- Load packages ----
library(tidyverse)
library(geographr)
library(readxl)

# ---- Get data and clean ----
# LA Codes
ltla_lookup <- lookup_ltla_ltla |>
  filter(str_detect(ltla23_code, "N")) |>
  select(ltla23_code, ltla23_name)

# Road Safety Data
# Source: https://www.psni.police.uk/about-us/our-publications-and-reports/official-statistics/road-traffic-collision-statistics

url <- "https://www.psni.police.uk/sites/default/files/2024-03/2023%20Key%20Statistics%20tables.xlsx"
temp_file <- tempfile(fileext = ".xlsx")
download.file(url, temp_file, mode = "wb")

road_safety_raw <- read_excel(temp_file, sheet = 6, skip = 5)

road_safety <- road_safety_raw |>
  select(
    ltla23_name = `Area`,
    accident_count = `Total...11`
  ) |>
  slice(1:11) |>
  mutate(
    ltla23_name = ltla23_name |>
      str_replace_all("&", "and") |>
      str_replace_all("Belfast City", "Belfast") |>
      str_replace_all("Lisburn & Castlereagh City", "Lisburn and Castlereagh")
  )

# Join datasets
places_road_safety <- ltla_lookup |>
  left_join(road_safety, by = "ltla23_name") |>
  mutate(
    accident_count = case_when(
      is.na(accident_count) & ltla23_code == "N09000007" ~ 615,
      TRUE ~ accident_count
    ),
    year = "2023"
  ) |>
  select(
    ltla24_code = ltla23_code,
    road_accident_count = accident_count,
    year
  )

places_road_safety <- places_road_safety |>
  mutate(domain = "places") |>
  mutate(subdomain = "living conditions") |>
  mutate(is_higher_better = FALSE)


# ---- Save output to data/ folder ----
usethis::use_data(places_road_safety, overwrite = TRUE)
