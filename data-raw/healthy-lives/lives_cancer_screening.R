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

# Cancer Screening data
# Source: https://www.publichealth.hscni.net/publications/director-public-health-core-tables-2022

GET(
  "https://www.publichealth.hscni.net/sites/default/files/2024-04/Core%20Tables%202022%20-%20Excel%20tables_1.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)


# Cervical Cancer
cervical_raw <- read_excel(tf, sheet = 34, skip = 3)

cervical_hb <- cervical_raw |>
  slice(1:5) |>
  select(
    trust18_name = HSCT,
    cervical_screening_percentage = `% Coverage`
  )


# Breast Cancer
breast_raw <- read_excel(tf, sheet = 35, skip = 3)

breast_hb <- breast_raw |>
  slice(1:5) |>
  select(
    trust18_name = `HSC Trust of residence`,
    breast_screening_percentage = `%`
  )


# Bowel Cancer
bowel_raw <- read_excel(tf, sheet = 37, skip = 3)

bowel_hb <- bowel_raw |>
  slice(1:5) |>
  select(
    trust18_name = `HSCT`,
    bowel_screening_percentage = `Uptake for bowel cancer screening \r\n(%)`
  )

# Join datasets
# Cancer Screening Percentages

cancer_screening_hb <- cervical_hb |>
  left_join(breast_hb) |>
  left_join(bowel_hb) |>
  rowwise() |>
  mutate(
    total_cancer_screening_percentage = mean(c_across(c(cervical_screening_percentage, breast_screening_percentage, bowel_screening_percentage)), na.rm = TRUE)
  ) |>
  ungroup()

# Cancer screening data + Trust name and code
cancer_screening_hb <- cancer_screening_hb |>
  left_join(hb_lookup) |>
  select(
    -trust18_name, -cervical_screening_percentage, -breast_screening_percentage, -bowel_screening_percentage
    ) |>
  relocate(trust18_code)

# Cancer screening data + LA code
lives_cancer_screening <- cancer_screening_hb |>
  left_join(hb_ltla_lookup) |>
  mutate(year = "2022-23") |>
  select(
    ltla24_code = ltla21_code,
    cancer_screening_uptake = total_cancer_screening_percentage,
    year
  ) |>
  arrange(ltla24_code)

lives_cancer_screening <- lives_cancer_screening |>
  mutate(domain = "lives") |>
  mutate(subdomain = "protective measures") |>
  mutate(is_higher_better = TRUE)

# ---- Save output to data/ folder ----
usethis::use_data(lives_cancer_screening, overwrite = TRUE)
