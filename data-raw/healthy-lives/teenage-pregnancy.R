# ---- Load packages ----
library(tidyverse)
library(geographr)

# ---- Get and clean data ----
# Teenage pregnancies
# Source: https://data.nisra.gov.uk/
url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/TEENBRLGD/CSV/1.0/"
teenage_pregnancy_raw <- read_csv(url)

lives_teenage_pregnancy <- teenage_pregnancy_raw |>
  filter(
    `Grouped Year` == "2020-22",
    `Statistic Label` ==
      "Births registered to mothers aged under 20 per 1,000 population"
  ) |>
  select(
    ltla24_code = LGD2014,
    teenage_pregnancies_per_1k = VALUE,
    year = `Grouped Year`
  ) |>
  slice(-12)

# ---- Save output to data/ folder ----
usethis::use_data(lives_teenage_pregnancy, overwrite = TRUE)
