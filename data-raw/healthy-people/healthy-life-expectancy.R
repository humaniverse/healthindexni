# ---- Load packages ----
library(tidyverse)
library(readxl)

# ---- Get and clean data ----
# Life Expectancy (2020-2022)
# Source: https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/healthandlifeexpectancies/datasets/lifeexpectancyforlocalareasinenglandnorthernirelandandwalesbetween2001to2003and2020to2022

url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/healthandsocialcare/healthandlifeexpectancies/datasets/lifeexpectancyforlocalareasinenglandnorthernirelandandwalesbetween2001to2003and2020to2022/between2001to2003and2020to2022/lifeexpectancylocalareas.xlsx"
temp_file <- tempfile(fileext = ".xlsx")
download.file(url, temp_file, mode = "wb")

le_raw <- read_excel(temp_file, sheet = 5, skip = 11)


# Life Expectancy (Male)

male_le <- le_raw |>
  filter(
    Sex == "Male",
    str_starts(`Area code`, "N"),
    `Age group` == "<1",
    `Area code` != "N92000002"
  ) |>
  select(
    ltla24_code = `Area code`,
    life_expectancy_male = `Life expectancy (years)...62`
  )

# Life Expectancy (Female)

female_le <- le_raw |>
  filter(
    Sex == "Female",
    str_starts(`Area code`, "N"),
    `Age group` == "<1",
    `Area code` != "N92000002"
  ) |>
  select(
    ltla24_code = `Area code`,
    life_expectancy_female = `Life expectancy (years)...62`
  )


# Join datasets
people_life_expectancy <- male_le |>
  left_join(female_le, by = "ltla24_code") |>
  rowwise() |>
  mutate(
    life_expectancy_combined = mean(c(life_expectancy_male, life_expectancy_female)),
    year = "2020-2022"
  ) |>
  select(
    ltla24_code,
    life_expectancy_combined,
    year
  )

# ---- Save output to data/ folder ----
usethis::use_data(people_life_expectancy, overwrite = TRUE)
