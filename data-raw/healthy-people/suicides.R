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

# Suicide Data
# Source: https://www.nisra.gov.uk/publications/suicide-statistics-2022

GET(
  "https://www.nisra.gov.uk/system/files/statistics/Suicide%20Statistics%202022%20Tables.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

suicides_raw <- read_excel(tf, sheet = 16, skip = 5)

suicides_hb <- suicides_raw |>
  filter(`Number and Rate` == "Age-Standardised rate") |>
  slice(7:9) |>
  pivot_longer(cols = `Belfast`:`Western`, names_to = "trust18_name", values_to = "suicide_rate_per_100k") |>
  mutate(suicide_rate_per_100k = as.numeric(suicide_rate_per_100k)) |>
  group_by(trust18_name) |>
  mutate(aggregate_suicide_rate_per_100k = sum(suicide_rate_per_100k, na.rm = TRUE)) |>
  ungroup() |>
  select(
    trust18_name,
    aggregate_suicide_rate_per_100k
  ) |>
  distinct(aggregate_suicide_rate_per_100k, .keep_all = TRUE)

# Join datasets
# Suicide data + Trust name and code

suicides_hb <- suicides_hb |>
  left_join(hb_lookup) |>
  select(-trust18_name) |>
  relocate(trust18_code)

# Suicide data + LA code
people_suicide <- suicides_hb |>
  left_join(hb_ltla_lookup) |>
  mutate(year = "2019-2021") |>
  select(
    ltla24_code = ltla21_code,
    suicide_rate_per_100k = aggregate_suicide_rate_per_100k,
    year
  ) |>
  arrange(ltla24_code)

# ---- Save output to data/ folder ----
usethis::use_data(people_suicide, overwrite = TRUE)
