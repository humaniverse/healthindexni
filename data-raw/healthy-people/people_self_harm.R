# ---- Load packages ----
library(tidyverse)

# ---- Get data and clean ----
# Self-Harm Emergency Admissions
# Source: https://data.nisra.gov.uk/

url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/SARSELFHARMLGD/CSV/1.0/"
self_harm_raw <- read_csv(url)

people_self_harm <- self_harm_raw |>
  filter(
    SEX == "All",
    `Grouped Financial Year` == "2018/19-2022/23"
  ) |>
  select(
    ltla24_code = LGD2014,
    self_harm_per_100k = VALUE,
    year = `Grouped Financial Year`
  ) |>
  slice(-12)

people_self_harm <- people_self_harm |>
  mutate(domain = "people") |>
  mutate(subdomain = "mental health") |>
  mutate(is_higher_better = FALSE)


# ---- Save output to data/ folder ----
usethis::use_data(people_self_harm, overwrite = TRUE)
