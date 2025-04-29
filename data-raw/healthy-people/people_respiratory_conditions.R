# Respiratory conditions here pertains to asthma and COPD data. A mean average
# has been calculated between the 2 to get an average for respiratory conditions.
# This best matches how England's Health Index calculates their respiratory
# conditions indicator.

# ---- Load packages ----
library(tidyverse)

# ---- Get and clean data ----
# Respiratory Conditions
# Source: https://data.nisra.gov.uk/

url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/DISPREVLGD/CSV/1.0/"
respiratory_conditions_raw <- read_csv(url)

people_respiratory_conditions <- respiratory_conditions_raw |>
  filter(
    `Statistic Label` == "Raw disease prevalence per 1,000 patients",
    `Financial Year` == "2023/24",
    `Disease` %in% c("Asthma", "Chronic Obstructive Pulmonary Disease"),
    `LGD2014` != "N92000002"
  ) |>
  group_by(LGD2014) |>
  mutate(
    respiratory_conditions_prevalence = mean(VALUE, na.rm = TRUE),
    respiratory_conditions_percentage = (respiratory_conditions_prevalence / 10)
  ) |>
  ungroup() |>
  distinct(LGD2014, .keep_all = TRUE) |>
  select(
    ltla24_code = LGD2014,
    respiratory_conditions_percentage,
    year = `Financial Year`
  )

people_respiratory_conditions <- people_respiratory_conditions |>
  mutate(domain = "people") |>
  mutate(subdomain = "physical health conditions") |>
  mutate(is_higher_better = FALSE)


# ---- Save output to data/ folder ----
usethis::use_data(people_respiratory_conditions, overwrite = TRUE)
