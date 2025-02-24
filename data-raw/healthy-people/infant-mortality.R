# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Get and clean data ----
# Geographical Code Data: Health Board and Local Authority

hb_ltla_lookup <- lookup_ltla21_hsct18 |>
  distinct(ltla21_code, trust18_code)

hb_lookup <- boundaries_trusts_ni18 |>
  sf::st_drop_geometry()


# Infant Mortality Data
# Source: https://data.nisra.gov.uk/

infant_mortality_raw <- read_csv("https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/INFANTMRHSCT/CSV/1.0/")

infant_mortality_hb <- infant_mortality_raw |>
  filter(
    `Grouped Year` == "2018-22",
    `Health and Social Care Trust` != "NI"
  ) |>
  select(
    trust18_name = `Health and Social Care Trust`,
    infant_mortality_per_1k = `VALUE`
  )


# Join datasets
# Infant mortality data + Trust name and code

infant_mortality_hb <- infant_mortality_hb |>
  left_join(hb_lookup) |>
  select(-trust18_name) |>
  relocate(trust18_code)


# Infant mortality data + LA code

people_infant_mortality <- infant_mortality_hb |>
  left_join(hb_ltla_lookup) |>
  mutate(year = "2018-22") |>
  select(
    ltla24_code = ltla21_code,
    infant_mortality_per_1k,
    year
  ) |>
  arrange(ltla24_code)


# ---- Save output to data/ folder ----
usethis::use_data(people_infant_mortality, overwrite = TRUE)
