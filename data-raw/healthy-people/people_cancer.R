# ---- Load packages ----
library(tidyverse)

# ---- Get and clean data ----
# Cancer Data
# Source: https://data.nisra.gov.uk/

url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/DISPREVLGD/CSV/1.0/"
cancer_raw <- read_csv(url)

people_cancer <- cancer_raw |>
  filter(
    `Statistic Label` == "Raw disease prevalence per 1,000 patients",
    `Disease` == "Cancer",
    `Financial Year` == "2023/24",
    `LGD2014` != "N92000002"
  ) |>
  rowwise() |>
  mutate(cancer_percentage = VALUE / 10) |>
  select(
    ltla24_code = LGD2014,
    cancer_percentage,
    year = `Financial Year`
  )

people_cancer <- people_cancer |>
  mutate(domain = "people") |>
  mutate(subdomain = "physical health conditions") |>
  mutate(is_higher_better = FALSE)


# ---- Save output to data/ folder ----
usethis::use_data(people_cancer, overwrite = TRUE)
