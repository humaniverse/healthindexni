# ---- Load packages ----
library(tidyverse)

# ---- Get and clean data ----
# Dementia Data
# Source: https://data.nisra.gov.uk/

url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/DISPREVLGD/CSV/1.0/"
dementia_raw <- read_csv(url)

people_dementia <- dementia_raw |>
  filter(
    `Statistic Label` == "Raw disease prevalence per 1,000 patients",
    `Disease` == "Dementia",
    `Financial Year` == "2023/24",
    `LGD2014` != "N92000002"
  ) |>
  rowwise() |>
  mutate(dementia_percentage = VALUE / 10) |>
  select(
    ltla24_code = LGD2014,
    dementia_percentage,
    year = `Financial Year`
  )

people_dementia <- people_dementia |>
  mutate(domain = "people") |>
  mutate(subdomain = "physical health conditions") |>
  mutate(is_higher_better = FALSE)

# ---- Save output to data/ folder ----
usethis::use_data(people_dementia, overwrite = TRUE)
