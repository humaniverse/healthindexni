# ---- Load packages ----
library(tidyverse)

# ---- Get data and clean
# Mortality from all causes
# Source: https://data.nisra.gov.uk/

url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/SDRAAACMLGD/CSV/1.0/"
all_mortality_raw <- read_csv("https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/SDRAAACMLGD/CSV/1.0/")

people_all_mortality <- all_mortality_raw |>
  filter(
    SEX == "All",
    `Grouped Year` == "2020-22"
  ) |>
  filter(LGD2014 != "N92000002") |>
  select(
    ltla24_code = LGD2014,
    death_rate_per_100k = VALUE,
    year = `Grouped Year`
  )

# ---- Save output to data/ folder ----
usethis::use_data(people_all_mortality, overwrite = TRUE)
