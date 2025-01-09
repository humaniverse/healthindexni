# ---- Load packages ----
library(tidyverse)
library(httr)
library(readxl)
library(geographr)

# ---- Get and clean data ----
# Geographical Code Data: Health Board and Local Authority

hb_ltla_lookup <- lookup_ltla21_hsct18 |>
  distinct(ltla21_code, trust18_code)

hb_lookup <- boundaries_trusts_ni18 |>
  sf::st_drop_geometry()

# Alcohol Misuse Data:
# Source: https://www.health-ni.gov.uk/publications/census-drug-and-alcohol-treatment-services-northern-ireland-30th-april-2019

GET(
  "https://www.health-ni.gov.uk/sites/default/files/publications/health/data-census-drug-alcohol-treatment-services-2019.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

alcohol_misuse_raw <- read_excel(tf, sheet = 5, skip = 3)

alcohol_misuse_hb <- alcohol_misuse_raw |>
  slice(2:6) |>
  mutate(across(2:5, as.numeric)) |>
  select(
    trust18_name = `...1`,
    alcohol_admissions_numbers = `Alcohol Only`
  )

# Population data - HSCT Level
# Source: https://data.nisra.gov.uk/

population_raw <- read_csv("https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/C21001HSCT/CSV/1.0/")

population_hb <- population_raw |>
  select(
    trust18_name = `Health and Social Care Trust`,
    population_total = `VALUE`
  )

# Join datasets
# Population + Alcohol Misuse

alcohol_misuse_rate_hb <- alcohol_misuse_hb |>
  left_join(population_hb) |>
  mutate(alcohol_admissions_rate_per_100k = (alcohol_admissions_numbers / population_total) * 100000) |>
  select(
    trust18_name,
    alcohol_admissions_rate_per_100k
  )

# Alcohol misuse data + Trust name and code

alcohol_misuse_rate_hb <- alcohol_misuse_rate_hb |>
  left_join(hb_lookup) |>
  select(-trust18_name) |>
  relocate(trust18_code)

# Alcohol misuse data + LA code
lives_alcohol_misuse <- alcohol_misuse_rate_hb |>
  left_join(hb_ltla_lookup) |>
  mutate(year = "2019") |>
  select(
    ltla24_code = ltla21_code,
    alcohol_admissions_rate_per_100k,
    year
  ) |>
  arrange(ltla24_code)

# ---- Save output to data/ folder ----
usethis::use_data(lives_alcohol_misuse, overwrite = TRUE)

