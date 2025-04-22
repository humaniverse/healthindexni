# ---- Load packages ----
library(tidyverse)

# ---- Get data ----
# Internet access
# Source: https://data.nisra.gov.uk/

url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/HHIBALGD/CSV/1.0/"
internet_access_raw <- read_csv(url)

places_internet_access <- internet_access_raw |>
  filter(
    `Financial Year` == "2021/22",
    `Statistic Label` == "Households with Home Internet Access: No",
    `LGD2014` != "N92000002"
  ) |>
  select(
    ltla24_code = `LGD2014`,
    no_internet_access_percentage = VALUE,
    year = `Financial Year`
  )

places_internet_access <- places_internet_access |>
  mutate(domain = "places") |>
  mutate(subdomain = "access to services") |>
  mutate(is_higher_better = FALSE)


# ---- Save output to data/ folder ----
usethis::use_data(places_internet_access, overwrite = TRUE)
