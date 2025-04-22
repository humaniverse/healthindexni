# ---- Load packages ----
library(tidyverse)
library(rio)
library(geographr)
library(readxl)
library(scales)

# ---- Get data and clean ----
# LTLA Code
ltla_lookup <- lookup_ltla_ltla |>
  filter(str_detect(ltla23_code, "N")) |>
  select(ltla23_code, ltla23_name)

# Low Birth Weight
# Source: https://www.publichealth.hscni.net/publications/statistical-profile-childrens-health-northern-ireland-202223
url <- "https://www.publichealth.hscni.net/sites/default/files/2024-05/RUAG%20Childrens%20Health%20in%20NI%20-%202022-23%20-%20DATA%20TABLES.xlsx"

temp_file <- tempfile(fileext = ".xlsx")
download.file(url, temp_file, mode = "wb")

low_birth_weight_raw <- read_excel(temp_file, sheet = 33, skip = 2)

low_birth_weight_raw$`% low birth weight infants (<2,500g)` <-
  as.numeric(low_birth_weight_raw$`% low birth weight infants (<2,500g)`)

low_birth_weight_raw$`% low birth weight infants (<2,500g)` <-
  percent(low_birth_weight_raw$`% low birth weight infants (<2,500g)`, accuracy = 0.1)


low_birth_weight <- low_birth_weight_raw |>
  slice(37:47) |>
  mutate(year = "2022/23") |>
  select(
    ltla23_name = `...3`,
    low_birth_weight_percentage = `% low birth weight infants (<2,500g)`,
    year
  ) |>
  mutate(low_birth_weight_percentage = as.numeric(str_remove(low_birth_weight_percentage, "%")))

# Join datasets
lives_low_birth_weight <- low_birth_weight |>
  left_join(ltla_lookup, by = c("ltla23_name" = "ltla23_name")) |>
  select(
    ltla24_code = ltla23_code,
    low_birth_weight_percentage,
    year
  )

lives_low_birth_weight <- lives_low_birth_weight |>
  mutate(domain = "lives") |>
  mutate(sundomain = "physiological risk factors") |>
  mutate(is_higher_better = FALSE)

# ---- Save output to data/ folder ----
usethis::use_data(lives_low_birth_weight, overwrite = TRUE)
