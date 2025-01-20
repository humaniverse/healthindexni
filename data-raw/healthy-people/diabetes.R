# ---- Load packages ----
library(tidyverse)

# ---- Get and clean data ----
# Diabetes Data
# Source: https://data.nisra.gov.uk/

diabetes_raw <- read_csv("https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/DISPREVLGD/CSV/1.0/")

people_diabetes <- diabetes_raw |>
  filter(
    `Financial Year` == "2023/24",
    `Disease` == "Diabetes Mellitus",
    `Statistic Label` == "Raw disease prevalence per 1,000 patients",
    LGD2014 != "N92000002"
  ) |>
  mutate(diabetes_percentage = (VALUE / 10)) |>
  select(
    ltla24_code = LGD2014,
    diabetes_percentage,
    year = `Financial Year`
  )

# ---- Save output to data/ folder ----
usethis::use_data(people_diabetes, overwrite = TRUE)
