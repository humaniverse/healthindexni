# ---- Load packages ----
library(tidyverse)
library(readxl)
library(httr)
library(geographr)

# ---- Get and clean data ----
# Geographical Code Data: Health Board and Local Authority

hb_ltla_lookup <- lookup_ltla21_hsct18 |>
  distinct(ltla21_code, trust18_code)

hb_lookup <- boundaries_trusts_ni18 |>
  sf::st_drop_geometry()


# Healthy Eating Data
# Source: https://www.health-ni.gov.uk/publications/health-survey-northern-ireland-first-results-202223

GET(
  "https://www.health-ni.gov.uk/sites/default/files/publications/health/hsni-trend-tables-22-23.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

smoking_raw <- read_excel(tf, sheet = 19, skip = 166)

smoking_hb <- smoking_raw |>
  slice(2:6) |>
  select(
    trust18_name = `All`,
    smoking_percentage = `2022/23...14`
  )

# Join datasets
# Smoking data + Trust name and code

smoking_hb <- smoking_hb |>
  left_join(hb_lookup) |>
  select(-trust18_name) |>
  relocate(trust18_code)

# Smoking data + LA code
lives_smoking <- smoking_hb |>
  left_join(hb_ltla_lookup) |>
  mutate(year = "2022/23") |>
  select(
    ltla24_code = ltla21_code,
    smoking_percentage,
    year
  ) |>
  arrange(ltla24_code)

# ---- Save output to data/ folder ----
usethis::use_data(lives_smoking, overwrite = TRUE)
