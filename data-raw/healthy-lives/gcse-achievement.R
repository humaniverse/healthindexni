# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Get and clean data ----
# Source: https://data.nisra.gov.uk/
url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/DESLSALGD/CSV/1.0/"
gsce_raw <- read_csv(url)


lives_gsce_attainment <- gsce_raw |>
  filter(
    `Academic Year` == "2022/23",
    `Free School Meal Entitlement` == "All Persons",
    `Statistic Label` ==
      "% of School Leavers achieving at least 5 GCSEs at grades A*-C (incl. equivalent qualifications) including GCSE English and maths"
  ) |>
  select(
    ltla24_code = LGD2014,
    gcse_qualifications_percent = VALUE,
    year = `Academic Year`
  ) |>
  slice(-12)

# ---- Save output to data/ folder ----
usethis::use_data(lives_gsce_attainment, overwrite = TRUE)
