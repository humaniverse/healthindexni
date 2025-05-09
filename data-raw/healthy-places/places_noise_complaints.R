# Raw data files were not available to download from online.
# Noise-complaints data was available from a published reported (sourced below).
# Data is available in the following file path:
# healthindexni > data-raw > healthy-places > noise_complaints_data.xlsx

# ---- Load packages ----
library(tidyverse)
library(httr)
library(readxl)
library(geographr)

# ---- Get and clean data ----
# Noise Complaints Data
# Source: https://www.daera-ni.gov.uk/sites/default/files/publications/daera/Noise%20Complaint%20Statistics%20for%20NI%202023-24.PDF

noise_complaints_raw <- read_excel("data-raw/healthy-places/noise_complaints_data.xlsx")

noise_complaints <- noise_complaints_raw |>
  select(
    ltla24_name = Council,
    noise_complaints_per_1k = "Complaints per 1000"
  ) |>
  mutate(
    ltla24_name = str_replace_all(ltla24_name, "\\s*&\\s*", " and "),
    ltla24_name = case_when(
      ltla24_name == "Ards and North Down" ~ "North Down and Ards",
      TRUE ~ ltla24_name
    )
  )

# LA ID
lookup <- lookup_sa11_soa11_lgd18 |>
  select(lgd18_name, lgd18_code) |>
  distinct(lgd18_name, lgd18_code) |>
  select(
    ltla24_name = lgd18_name,
    ltla24_code = lgd18_code
  )

# Join datasets
places_noise_complaints <- noise_complaints |>
  left_join(lookup) |>
  mutate(year = "2023-24") |>
  select(
    ltla24_code,
    noise_complaints_per_1k,
    year
  )

places_noise_complaints <- places_noise_complaints |>
  mutate(domain = "places") |>
  mutate(subdomain = "living conditions") |>
  mutate(is_higher_better = FALSE)


# ---- Save output to data/ folder ----
usethis::use_data(places_noise_complaints, overwrite = TRUE)
