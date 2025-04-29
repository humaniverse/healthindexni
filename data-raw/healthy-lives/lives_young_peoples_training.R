# ---- Load packages ----
library(tidyverse)

# ---- Get and clean data ----
# Young Peoples Training, Education, and Employment
# Source: https://data.nisra.gov.uk/
url <- "https://ws-data.nisra.gov.uk/public/api.restful/PxStat.Data.Cube_API.ReadDataset/DESLSDLGD/CSV/1.0/"
young_peoples_raw <- read_csv(url)

lives_young_peoples_training <- young_peoples_raw |>
  filter(
    UNIT == "%",
    FSME == "All",
    `Academic Year` == "2022/23",
    `Statistic Label` %in% c(
      "% of School Leavers with Destination: Higher Education",
      "% of School Leavers with Destination: Further Education",
      "% of School Leavers with Destination: Employment",
      "% of School Leavers with Destination: Training"
    )
  ) |>
  summarise(
    young_peoples_eet_percentage = sum(VALUE, na.rm = TRUE),
    .by = c(`Academic Year`, "LGD2014")
  ) |>
  select(
    ltla24_code = LGD2014,
    young_peoples_eet_percentage,
    year = `Academic Year`
  ) |>
  filter(ltla24_code != "N92000002")

lives_young_peoples_training <- lives_young_peoples_training |>
  mutate(domain = "lives") |>
  mutate(subdomain = "children and young people") |>
  mutate(is_higher_better = TRUE)

# ---- Save output to data/ folder ----
usethis::use_data(lives_young_peoples_training, overwrite = TRUE)
