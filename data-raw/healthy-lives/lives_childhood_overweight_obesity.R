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
  summarise(
    overweight_obesity_percentage = mean(VALUE, na.rm = TRUE),
    .by = c(`Academic Year`, "LGD2014")
  ) |>
  select(
    ltla24_code = LGD2014,
    overweight_obesity_percentage,
    year = `Academic Year`
  ) |>
  filter(ltla24_code != "N92000002")

lives_childhood_overweight_obesity <- lives_childhood_overweight_obesity |>
  mutate(domain = "lives") |>
  mutate(subdomain = "physiological risk factors") |>
  mutate(is_higher_better = FALSE)

# ---- Save output to data/ folder ----
usethis::use_data(lives_childhood_overweight_obesity, overwrite = TRUE)
