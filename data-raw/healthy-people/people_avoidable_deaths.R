# ---- Load packages ----
library(tidyverse)

# ---- Get and clean data ----
# Avoidable Deaths Data
# Source: https://data.nisra.gov.uk/
avoidable_deaths_raw <- read_csv("https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/SDROECDLGD/CSV/1.0/")

people_avoidable_deaths <- avoidable_deaths_raw |>
  filter(
    `Grouped Year` == "2018-22",
    `Sex Label` == "All Persons",
    `Statistic Label` == "Avoidable deaths per 100,000 population",
    LGD2014 != "N92000002"
  ) |>
  select(
    ltla24_code = LGD2014,
    avoidable_deaths_per_100k = VALUE,
    year = `Grouped Year`
  )

people_avoidable_deaths <- people_avoidable_deaths |>
  mutate(domain = "people") |>
  mutate(subdomain = "mortality") |>
  mutate(is_higher_better = FALSE)


# ---- Save output to data/ folder ----
usethis::use_data(people_avoidable_deaths, overwrite = TRUE)
