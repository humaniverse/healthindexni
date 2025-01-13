# Raw data files were not available to download from online.
# Noise-complaints data was available from a published reported (sourced below).
# Data is available in the following file path:
# healthindexni > data-raw > healthy-people > noise_complaints_data.xlsx

# ---- Load packages ----
library(tidyverse)
library(httr)
library(readxl)
library(geographr)

# ---- Get and clean data ----
# Noise Complaints Data
# Source: https://www.daera-ni.gov.uk/sites/default/files/publications/daera/Noise%20Complaint%20Statistics%20for%20NI%202023-24.PDF

noise_complaints_raw <- read_excel("data-raw/healthy-people/noise_complaints_data.xlsx", skip = 4)

noise_complaints <- noise_complaints_raw |>
  select(ltla24_name = Council,
         noise_complaints_per_1k = "Complaints per 1000")



# need to rename:
# Armagh City, Banbridge and Craigavon - Armagh, Banbridge and Craigavon
# Derry City and Strabane - Derry and Strabane
# Ards and North Down - North Down and Ards

# THEN join datasets



# LA ID
lookup <- lookup_sa11_soa11_lgd18 |>
  select(lgd18_name, lgd18_code) |>
  distinct(lgd18_name, lgd18_code) |>
  select (ltla24_name = lgd18_name,
          ltla24_code = lgd18_code)

# Join datasets
places_noise_complaints <- noise_complaints |>
  left_join(lookup)

