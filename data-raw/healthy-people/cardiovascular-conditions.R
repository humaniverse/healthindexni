# Cardiovascular conditions here pertains to CHD, Atrial Fibrillation, Heart
# Failure, and Stroke & TIA data. A mean average has been calculated between the
# 5 to get an average for cardiovascular conditions. This best matches how
# England's Health Index calculates their cardiovascular conditions indicator.

# ---- Load packages ----
library(tidyverse)

# ---- Get and clean data ----
# Cardiovascular Conditions Data (CHD, Atrial Fibrillation, Heart Failure, Stroke & TIA)
# Source: https://data.nisra.gov.uk/

url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/DISPREVLGD/CSV/1.0/"
cardiovascular_conditions_raw <- read_csv(url)

people_cardiovascular_conditions <- cardiovascular_conditions_raw |>
  filter(
    `Statistic Label` == "Raw disease prevalence per 1,000 patients",
    `Financial Year` == "2023/24",
    `Disease` %in% c("Atrial Fibrillation", "Coronary Heart Disease",
                     "Heart Failure 1", "Heart Failure 3", "Stroke & TIA"),
    `LGD2014` != "N92000002"
  ) |>
  group_by(LGD2014) |>
  mutate(
    cardiovascular_conditions_prevalence = mean(VALUE, na.rm = TRUE),
    cardiovascular_conditions_percentage = (cardiovascular_conditions_prevalence / 10)
  ) |>
  ungroup() |>
  distinct(LGD2014, .keep_all = TRUE) |>
  select(
    ltla24_code = LGD2014,
    cardiovascular_conditions_percentage,
    year = `Financial Year`
  )

# ---- Save output to data/ folder ----
usethis::use_data(people_cardiovascular_conditions, overwrite = TRUE)
