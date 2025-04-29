# ---- Load packages ----
library(tidyverse)

# ---- Get and clean data ----
# Pupil absences
# Source: https://data.nisra.gov.uk/

url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/DEATTLGD/CSV/1.0/"
pupil_absence_raw <- read_csv(url)

lives_pupil_absence <- pupil_absence_raw |>
  filter(`Academic Year` == "2021/22",
         `Statistic Label` == "Percentage unauthorised absence") |>
  group_by(LGD2014) |>
  mutate(total_pupil_absence_percentage = mean(VALUE, na.rm = TRUE)) |>
  distinct(LGD2014, .keep_all = TRUE) |>
  select(ltla24_code = LGD2014,
         total_pupil_absence_percentage,
         year = `Academic Year`) |>
  slice(-12)

lives_pupil_absence <- lives_pupil_absence |>
  mutate(domain = "lives") |>
  mutate(subdomain = "children and young people") |>
  mutate(is_higher_better = FALSE)

# ---- Save output to data/ folder ----
usethis::use_data(lives_pupil_absence, overwrite = TRUE)
