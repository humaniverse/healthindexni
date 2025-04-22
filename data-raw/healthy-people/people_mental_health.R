# ---- Load packages ----
library(tidyverse)
library(httr)
library(readxl)

# ---- Get and clean data ----
# Mental health conditions
# Source: https://www.nisra.gov.uk/publications/census-2021-main-statistics-health-disability-and-unpaid-care-tables

tf <- tempfile(fileext = ".xlsx")
download.file("https://www.nisra.gov.uk/system/files/statistics/census-2021-ms-d12.xlsx", tf, mode = "wb")

mental_health_raw <- read_excel(tf, sheet = 2, skip = 8)

people_mental_health <- mental_health_raw |>
  slice(2:12) |>
  mutate(across(3:17, as.numeric)) |>
  rowwise() |>
  mutate(
    mental_health_total = sum(
      `Usual residents aged 15-39 years:\r\n Has an emotional, psychological or mental health condition`,
      `Usual residents aged 40-64 years:\r\n Has an emotional, psychological or mental health condition`,
      `Usual residents aged 65+ years:\r\n Has an emotional, psychological or mental health condition`
    ),
    population_total = sum(
      `Usual residents aged 15-39 years`,
      `Usual residents aged 40-64 years`,
      `Usual residents aged 65+ years`
    )
  ) |>
  ungroup() |>
  mutate(
    mental_health_percentage = (mental_health_total / population_total) * 100,
    year = "2021"
  ) |>
  select(
    ltla24_code = `Geography code`,
    mental_health_percentage,
    year
  )

people_mental_health <- people_mental_health |>
  mutate(domain = "people") |>
  mutate(subdomain = "mental health") |>
  mutate(is_higher_better = FALSE)


# ---- Save output to data/ folder ----
usethis::use_data(people_mental_health, overwrite = TRUE)
