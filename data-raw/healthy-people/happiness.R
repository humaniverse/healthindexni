# ---- Load packages ----
library(tidyverse)
library(rio)

# ---- Get and clean data ----
# Happiness
# Source: https://www.ons.gov.uk/datasets/wellbeing-local-authority/editions/time-series/versions/4

happiness_raw <- import("https://download.ons.gov.uk/downloads/datasets/wellbeing-local-authority/editions/time-series/versions/4.csv")

people_happiness <- happiness_raw |>
  filter(
    str_starts(`administrative-geography`, "N"),
    MeasureOfWellbeing == "Happiness",
    `yyyy-yy` == "2022-23",
    `wellbeing-estimate` == "average-mean"
  ) |>
  slice(-11) |>
  select(
    ltla24_code = `administrative-geography`,
    happiness_score_out_of_10 = `v4_3`,
    year = `Time`
  )

# ---- Save output to data/ folder ----
usethis::use_data(people_happiness, overwrite = TRUE)
