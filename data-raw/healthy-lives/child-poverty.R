# ---- Load packages ----
library(tidyverse)

# ---- Get and clean data ----
# Child Poverty Data
# Source: https://data.nisra.gov.uk/

url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/NIMDM17T10/CSV/1.0/"
child_poverty_raw <- read_csv(url)

lives_child_poverty <- child_poverty_raw |>
  filter(`Statistic Label` ==
    "Proportion of the population aged 15 and under living in households whose equivalised income is below 60 per cent of the NI median") |>
  select(
    ltla24_code = LGD2014,
    child_poverty_percentage = VALUE,
    year = `Ad-hoc year`
  )

# ---- Save output to data/ folder ----
usethis::use_data(lives_child_poverty, overwrite = TRUE)
