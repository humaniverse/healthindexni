# ---- Load packages ----
library(tidyverse)
library(readxl)
library(geographr)

# ---- Get and clean data ----
# Life Expectancy (2020-2022)
# Source: https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/healthandlifeexpectancies/datasets/lifeexpectancyforlocalareasinenglandnorthernirelandandwalesbetween2001to2003and2020to2022

url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/healthandsocialcare/healthandlifeexpectancies/datasets/lifeexpectancyforlocalareasinenglandnorthernirelandandwalesbetween2001to2003and2020to2022/between2001to2003and2020to2022/lifeexpectancylocalareas.xlsx"
temp_file <- tempfile(fileext = ".xlsx")
download.file(url, temp_file, mode = "wb")

le_raw <- read_excel(temp_file, sheet = 5, skip = 11)


# Life Expectancy (Male)

male_le <- le_raw |>
  filter(Sex == "Male",
         str_starts(`Area code`, "N"),
         `Age group` == "<1",
         `Area code` != "N92000002") |>
  select(ltla24_code = `Area code`,
         life_expectancy_male = `Life expectancy (years)...62`)

# Life Expectancy (Female)

female_le <- le_raw |>
  filter(Sex == "Female",
         str_starts(`Area code`, "N"),
         `Age group` == "<1",
         `Area code` != "N92000002") |>
  select(ltla24_code = `Area code`,
         life_expectancy_female = `Life expectancy (years)...62`)


# Join datasets
people_life_expectancy <- male_le |>
  left_join(female_le, by = "ltla24_code")



# TO DO: add in population data (from NISRA: 'Population totals, MYE01T06' OR
# 'Mid-year population estimates, MYE01T04 - probably this one).
#
# Then need to get population totals for males and females. Then combine male
# and female population to get total population for each council.
#
# Then need to calculate the weighted life expectancy -
# ((male-LE * male-pop) + (female-LE * female-pop)) / total-pop



# ---- Load libraries ----
library(tidyverse)
library(httr)
library(readxl)
library(geographr)
library(sf)

source("R/utils.R")

# ---- Retrieve data ----
GET(
  "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fhealthandsocialcare%2fhealthandlifeexpectancies%2fdatasets%2fhealthstatelifeexpectancyatbirthandatage65bylocalareasuk%2fcurrent/hsleatbirthandatage65byukla201618.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

raw_males <-
  read_excel(
    tf,
    sheet = "HE - Male at birth",
    range = "A4:I490"
  )

hle_males <-
  raw_males |>
  select(
    lad_code = `Area Codes`,
    healthy_life_expectancy_male = HLE
  ) |>
  filter_codes(lad_code, "^N")

raw_females <-
  read_excel(
    tf,
    sheet = "HE - Female at birth",
    range = "A4:I490"
  )

hle_females <-
  raw_females |>
  select(
    lad_code = `Area Codes`,
    healthy_life_expectancy_female = HLE
  ) |>
  filter_codes(lad_code, "^N")

hle_joined <-
  hle_males |>
  left_join(hle_females)

# ---- Calculate female/male weighted population estimates ----
GET(
  "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland/mid2019april2020localauthoritydistrictcodes/ukmidyearestimates20192020ladcodes.xls",
  write_disk(tf <- tempfile(fileext = ".xls"))
)

# Total pop
raw_pop_total <-
  read_excel(
    tf,
    sheet = "MYE2 - Persons",
    range = "A5:D431"
  )

pop_total <-
  raw_pop_total |>
  select(
    lad_code = Code, pop_total = `All ages`
  ) |>
  filter_codes(lad_code, "^N")

# Males
raw_pop_male <-
  read_excel(
    tf,
    sheet = "MYE2 - Males",
    range = "A5:D431"
  )

pop_male <-
  raw_pop_male |>
  select(
    lad_code = Code, pop_male = `All ages`
  ) |>
  filter_codes(lad_code, "^N")

# Females
raw_pop_female <-
  read_excel(
    tf,
    sheet = "MYE2 - Females",
    range = "A5:D431"
  )

pop_female <-
  raw_pop_female |>
  select(
    lad_code = Code, pop_female = `All ages`
  ) |>
  filter_codes(lad_code, "^N")

# Calculate proportions
pop_proportions <-
  pop_total |>
  left_join(pop_male) |>
  left_join(pop_female) |>
  rowwise() |>
  mutate(
    proportion_male = pop_male / pop_total,
    proportion_female = pop_female / pop_total
  ) |>
  ungroup() |>
  select(lad_code, starts_with("proportion"))

# Compute population weighted mean HLE
hle <-
  hle_joined |>
  left_join(pop_proportions) |>
  rowwise(lad_code) |>
  summarise(
    healthy_life_expectancy = (healthy_life_expectancy_male * proportion_male) + (healthy_life_expectancy_female * proportion_female),
    .groups = "drop"
  )

write_rds(hle, "data/vulnerability/health-inequalities/northern-ireland/healthy-people/healthy-life-expectancy.rds")
