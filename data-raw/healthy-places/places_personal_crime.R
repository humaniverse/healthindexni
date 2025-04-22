# ---- Load packages ----
library(tidyverse)

# ---- Get and clean data ----
# Personal Crime
# Source: https://data.nisra.gov.uk/

url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/NIMDM17T10/CSV/1.0/"
personal_crime_raw <- read_csv(url)

places_personal_crime <- personal_crime_raw |>
  filter(`Statistic Label` %in% c(
    "Rate of Violence (including sexual offences), robbery and public order (per 1,000 population)",
    "Rate of Burglary (per 1,000 population)",
    "Rate of Theft (per 1,000 population)",
    "Rate of Criminal Damage and Arson (per 1,000 population)"
  )) |>
  summarise(
    personal_crime_per_1k = sum(VALUE, na.rm = TRUE),
    .by = c(`Ad-hoc year`, "LGD2014")
  ) |>
  select(
    ltla24_code = LGD2014,
    personal_crime_per_1k,
    year = `Ad-hoc year`
  )

places_personal_crime <- places_personal_crime |>
  mutate(domain = "places") |>
  mutate(subdomain = "crime") |>
  mutate(is_higher_better = FALSE)


# ---- Save output to data/ folder ----
usethis::use_data(places_personal_crime, overwrite = TRUE)
