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

# Child vaccination coverage data
# Source: https://www.publichealth.hscni.net/publications/director-public-health-core-tables-2022

GET(
  "https://www.publichealth.hscni.net/sites/default/files/2024-04/Core%20Tables%202022%20-%20Excel%20tables_1.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

vaccine_raw <- read_excel(tf, sheet = 31, skip = 4)

vaccine_coverage_hb <- vaccine_raw |>
  slice(1:9) |>
  mutate(Belfast = as.numeric(Belfast)) |>
  pivot_longer(cols = `Belfast`:`Northern Ireland`, names_to = "trust18_name", values_to = "vaccine_coverage_percentage") |>
  group_by(trust18_name) |>
  summarise(av_vaccine_coverage_percentage = mean(vaccine_coverage_percentage, na.rm = TRUE)) |>
  filter(trust18_name != "Northern Ireland")

# Join datasets
# Child vaccine coverage data + Trust name and code

vaccine_coverage_hb <- vaccine_coverage_hb |>
  left_join(hb_lookup) |>
  select(-trust18_name) |>
  relocate(trust18_code)

# Child vaccine data + LA code

lives_child_vaccine_coverage <- vaccine_coverage_hb |>
  left_join(hb_ltla_lookup) |>
  mutate(year = "2022-23") |>
  select(
    ltla24_code = ltla21_code,
    child_vaccine_coverage_percentage = av_vaccine_coverage_percentage,
    year
  ) |>
  arrange(ltla24_code)

lives_child_vaccine_coverage <- lives_child_vaccine_coverage |>
  mutate(domain = "lives") |>
  mutate(subdomain = "protective measures") |>
  mutate(is_higher_better = TRUE)

# ---- Save output to data/ folder ----
usethis::use_data(lives_child_vaccine_coverage, overwrite = TRUE)
