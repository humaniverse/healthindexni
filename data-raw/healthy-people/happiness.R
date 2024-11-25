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


# ---- Load ----
library(tidyverse)
library(httr)
library(readxl)
library(geographr)
library(sf)

source("R/utils.R")

# ---- Extract data ----
# Source: https://www.ons.gov.uk/datasets/wellbeing-local-authority/editions/time-series/versions/1
GET(
  "https://download.ons.gov.uk/downloads/datasets/wellbeing-local-authority/editions/time-series/versions/1.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

happiness_raw <-
  read_excel(tf, sheet = "Dataset", skip = 2)

# The 'Average (mean)' estimate provides the score out of 0-10. The other estimates are
# thresholds (percentages) described in the QMI: https://www.ons.gov.uk/peoplepopulationandcommunity/wellbeing/methodologies/personalwellbeingintheukqmi
happiness <-
  happiness_raw |>
  filter(Estimate == "Average (mean)") |>
  filter(MeasureOfWellbeing == "Happiness") |>
  select(
    lad_code = `Geography code`,
    happiness_score_out_of_10 = `2019-20`
  ) |>
  filter_codes(lad_code, "^N") |>
  filter(lad_code != "N92000002")

write_rds(happiness, "data/vulnerability/health-inequalities/northern-ireland/healthy-people/happiness.rds")
