# ---- Load packages ----
library(tidyverse)
library(rio)

# ---- Get and clean data ----
# Life worthwhileness
# Source: https://www.ons.gov.uk/datasets/wellbeing-local-authority/editions/time-series/versions/4

life_worthwhileness_raw <- import("https://download.ons.gov.uk/downloads/datasets/wellbeing-local-authority/editions/time-series/versions/4.csv")

people_life_worthwhileness <- life_worthwhileness_raw |>
  filter(
    str_starts(`administrative-geography`, "N"),
    MeasureOfWellbeing == "Worthwhile",
    `yyyy-yy` == "2022-23",
    `wellbeing-estimate` == "average-mean"
  ) |>
  slice(-11) |>
  select(
    ltla24_code = `administrative-geography`,
    worthwhile_score_out_of_10 = `v4_3`,
    year = `Time`
  )

# ---- Save output to data/ folder ----
usethis::use_data(people_life_worthwhileness, overwrite = TRUE)
