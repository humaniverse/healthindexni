# ---- Load packages ----
library(tidyverse)

# ---- Get and clean data ----
# High Blood Pressure Data
# Source: https://data.nisra.gov.uk/

url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/DISPREVLGD/CSV/1.0/"
high_blood_pressure_raw <- read_csv(url)

lives_high_blood_pressure <- high_blood_pressure_raw |>
  filter(
    `Statistic Label` == "Raw disease prevalence per 1,000 patients",
    `Disease` == "Hypertension",
    `Financial Year` == "2023/24",
    `LGD2014` != "N92000002"
  ) |>
  rowwise() |>
  mutate(high_blood_pressure_percentage = VALUE / 10) |>
  select(
    ltla24_code = LGD2014,
    high_blood_pressure_percentage,
    year = `Financial Year`
  )

# ---- Save output to data/ folder ----
usethis::use_data(lives_high_blood_pressure, overwrite = TRUE)
