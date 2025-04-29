# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Get and clean data ----
# Unemployment data
# Source: https://data.nisra.gov.uk/
url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/CCAALGD/CSV/1.0/"
unemployment_raw <- read_csv(url)

places_unemployment <- unemployment_raw |>
  filter(
    UNIT == "%",
    Year == "2023"
  ) |>
  select(
    ltla24_code = LGD2014,
    unemployment_percentage = VALUE,
    year = Year
  ) |>
  slice(-1)

places_unemployment <- places_unemployment |>
  mutate(domain = "places") |>
  mutate(subdomain = "economic and working conditions") |>
  mutate(is_higher_better = FALSE)


# ---- Save output to data/ folder ----
usethis::use_data(places_unemployment, overwrite = TRUE)
