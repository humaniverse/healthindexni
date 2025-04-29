# ---- Load packages ----
library(tidyverse)

# ---- Get and clean data ----
# Household Overcrowding Data
# Source: https://data.nisra.gov.uk/

url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/NIMDM17T10/CSV/1.0/"
overcrowding_raw <- read_csv(url)

places_household_overcrowding <- overcrowding_raw |>
  filter(`Statistic Label` == "Rate of Household overcrowding") |>
  select(
    ltla24_code = LGD2014,
    household_overcrowding_percentage = VALUE,
    year = `Ad-hoc year`
  )

places_household_overcrowding <- places_household_overcrowding |>
  mutate(domain = "places") |>
  mutate(subdomain = "living conditions") |>
  mutate(is_higher_better = FALSE)


# ---- Save output to data/ folder ----
usethis::use_data(places_household_overcrowding, overwrite = TRUE)
