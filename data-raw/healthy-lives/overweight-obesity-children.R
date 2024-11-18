# ---- Load packages ----
library(tidyverse)

# ---- Get and clean data ----
# Childhood Overweight Obesity
# Source: https://data.nisra.gov.uk/

url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/CHILDBMILGD/CSV/1.0/"
childhood_overweight_obesity_raw <- read_csv(url)

lives_childhood_overweight_obesity <- childhood_overweight_obesity_raw |>
  filter(
    SEX == "All",
    `Academic Year` == "2022/23",
    `Statistic Label` %in%
      c(
        "Proportion of P1 children who are overweight or obese",
        "Proportion of Y8 children who are overweight or obese"
      )
  ) |>
  group_by(LGD2014) |>
  mutate(overweight_obesity_percentage = mean(VALUE, na.rm = TRUE)) |>
  distinct(LGD2014, .keep_all = TRUE) |>
  ungroup() |>
  select(
    ltla24_code = LGD2014,
    overweight_obesity_percentage,
    year = `Academic Year`
  ) |>
  slice(-12)

# ---- Save output to data/ folder ----
usethis::use_data(lives_childhood_overweight_obesity, overwrite = TRUE)
