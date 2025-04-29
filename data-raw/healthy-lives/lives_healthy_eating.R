# ---- Load packages ----
library(tidyverse)
library(readxl)
library(httr)
library(geographr)

# ---- Get and clean data ----
# Healthy Eating Data
# Source: https://www.health-ni.gov.uk/publications/health-survey-northern-ireland-first-results-202223

GET(
  "https://www.health-ni.gov.uk/sites/default/files/publications/health/hsni-trend-tables-22-23.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

healthy_eating_raw <- read_excel(tf, sheet = 17, skip = 160)

healthy_eating_hb <- healthy_eating_raw |>
  slice(2:6) |>
  select(
    hb24_name = `All`,
    healthy_eating_percentage = `2022/23...14`
  )


# Geographical Code Data: Health Board and Local Authority

hb_ltla_lookup <- lookup_ltla21_hsct18 |>
  distinct(ltla21_code, trust18_code)

hb_lookup <- boundaries_trusts_ni18 |>
  sf::st_drop_geometry()


# Join datasets
# Healthy eating data + Trust name and code

healthy_eating_hb <- healthy_eating_hb |>
  select(
    trust18_name = hb24_name,
    healthy_eating_percentage
  ) |>
  left_join(hb_lookup, by = "trust18_name") |>
  select(-trust18_name) |>
  relocate(trust18_code)

# Healthy eating data + LA code

lives_healthy_eating <- healthy_eating_hb |>
  left_join(hb_ltla_lookup, by = "trust18_code") |>
  mutate(year = "2022/23") |>
  select(
    ltla24_code = ltla21_code,
    healthy_eating_percentage,
    year
  ) |>
  arrange(ltla24_code) |>
  mutate(healthy_eating_percentage = as.numeric(healthy_eating_percentage))

lives_healthy_eating <- lives_healthy_eating |>
  mutate(domain = "lives") |>
  mutate(subdomain = "behavioural risk factors") |>
  mutate(is_higher_better = TRUE)

# ---- Save output to data/ folder ----
usethis::use_data(lives_healthy_eating, overwrite = TRUE)
