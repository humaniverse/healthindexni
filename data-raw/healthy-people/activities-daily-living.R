# ---- Load packages ----
library(tidyverse)
library(readxl)

# ---- Get data and clean ----
# Disability Daily Activities
# Source: https://www.nisra.gov.uk/publications/census-2021-main-statistics-health-disability-and-unpaid-care-tables

url <- "https://www.nisra.gov.uk/system/files/statistics/census-2021-ms-d02.xlsx"

tf <- tempfile(fileext = ".xlsx")
download.file(url, tf, mode = "wb")

disability_daily_activities_raw <- read_excel(tf, sheet = 4, skip = 8)

people_disability_daily_activities <- disability_daily_activities_raw |>
  slice(1:11) |>
  mutate(across(3:22, as.numeric)) |>
  rowwise() |>
  mutate(
    disability_activities_limited_total = sum(
      `Usual residents aged 15-39 years: \r\nDay-to-day activities limited a lot`,
      `Usual residents aged 15-39 years: \r\nDay-to-day activities limited a little`,
      `Usual residents aged 40-64 years: \r\nDay-to-day activities limited a lot`,
      `Usual residents aged 40-64 years: \r\nDay-to-day activities limited a little`
    ),
    population_total = sum(`Usual residents aged 15-39 years`, `Usual residents aged 40-64 years`)
  ) |>
  ungroup() |>
  mutate(
    disability_activities_limited_percentage = (
      disability_activities_limited_total / population_total
    ) * 100,
    year = "2021"
  ) |>
  select(
    ltla24_code = `Geography code`,
    disability_activities_limited_percentage,
    year
  )

# ---- Save output to data/ folder ----
usethis::use_data(people_disability_daily_activities, overwrite = TRUE)
