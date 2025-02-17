#--- method --------------------------------------------------------------------
#
# # Adapted from:
# # https://www.oecd-ilibrary.org/docserver/9789264043466-en.pdf?expires=1732447217&id=id&accname=guest&checksum=C9FB3C0E94A6DE6D49C811382692119B
#


#--- libraries -----------------------------------------------------------------

library(tidyverse)
library(psych)


#--- prepare indicators --------------------------------------------------------

# load all indicators
files <- list.files("data", pattern = "^(lives|places|people).*\\.rda", full.names = TRUE)
indicators <- map(files, ~ get(load(.x)))
indicators <- map(indicators, ~ select(.x, -starts_with("year")))

# check whether all indicator tables had the same number of columns
stopifnot(all(lengths(indicators) == 2))

# NOTE: a few indicators have "lgd14_code" - renaming the column
indicators <- map(indicators, ~ rename(.x, any_of(c(ltla24_code = "lgd14_code"))))

# combine to a single table
indicators <- reduce(indicators, left_join, by = "ltla24_code")

# NOTE: fix low_birth_weight_percentage to numeric
indicators <- indicators |>
  mutate(low_birth_weight_percentage = as.numeric(str_replace(low_birth_weight_percentage, "%", "")))

names(indicators)[-1] <- str_replace(basename(files), ".rda$", "")

# NOTE: move infant mortality from "lives" to people
indicators <- indicators |>
  rename(people_infant_mortality = "lives_infant_mortality")

# NOTE: move child poverty from "lives" to places
indicators <- indicators |>
  rename(places_child_poverty = "lives_child_poverty")

# NOTE: move unemployment from "lives" to places
indicators <- indicators |>
  rename(places_unemployment = "lives_unemployment")


# all the indicators that should be represented as higher = better
# but are currently higher = worse
toflip <- c("lives_alcohol_misuse", "lives_childhood_overweight_obesity",
            "lives_high_blood_pressure", "lives_low_birth_weight", "lives_pupil_absence",
            "lives_smoking", "lives_teenage_pregnancy",
            "people_all_mortality", "people_avoidable_deaths", "people_cancer",
            "people_cardiovascular_conditions", "people_dementia", "people_diabetes",
            "people_disability_daily_activities", "people_infant_mortality", "people_mental_health",
            "people_respiratory_conditions", "people_self_harm", "people_suicide",
            "places_air_pollution", "places_child_poverty", "places_gp_travel_time",
            "places_household_overcrowding", "places_internet_access",
            "places_noise_complaints", "places_personal_crime", "places_pharmacy_travel_time",
            "places_road_safety", "places_sports_centre_travel_time", "places_unemployment"
            )

# check if all present
stopifnot(all(toflip %in% colnames(indicators)))

# align the indicators so that higher = better
indicators[toflip] <- - indicators[toflip]

# scale to z-scores
indicators[-1] <- map(indicators[-1], function(x) scale(x)[,1])  # NOTE: [,1] to drop attribtes

# impute NA values by using a simple mean
# note that means are 0 after scaling
indicators[is.na(indicators)] <- 0


#--- combine -------------------------------------------------------------------

build_pc_indicators <- function(x) {
  # NOTE: if only one indicator - return it
  if(ncol(x) == 1) {
    return(x[[1]])
  }
  # pca
  # center and scale to make sure all indicators are weighted equally
  pca <- prcomp(x, center = TRUE, scale. = TRUE)
  # determine the number of components selected (cummulative variance > 60 %)
  npc <- which(cumsum(round(pca$sdev^2 / sum(pca$sdev^2) * 100)) > 60)[1]

  # factors
  # NOTE: based on replication from OECD toy dataset example
  # NOTE: using psych::principal() since it aligned with OECD results
  fa <- principal(cor(x), npc)
  # variance explained by each factor
  fw <- fa$Vaccounted[1,] / sum(fa$Vaccounted[1,])

  # square loadings and make sure they sum to 1
  l <- apply(unclass(fa$loadings)^2, 2, function(x) x/sum(x))
  # for each indicator only leave the highest weight
  l[l < apply(l, 1, max)] <- 0
  # scale again so each factor sums to 1
  l <- apply(l, 2, function(x) x/sum(x))
  # multiply by variance explain
  # NOTE: not sure why, but it's in the OECD example
  l <- l * fw[col(l)]

  # indicator weights
  w <- apply(l, 1, max)

  # final score
  colSums(t(x) * w)
}

quantise <- function(x) {
  findInterval(x, quantile(x, seq(0,1,0.1)), rightmost.closed = TRUE)
}

# subdomains
subdomains <- list()
subdomains$people_difficulties_in_daily_life <- indicators[c("people_disability_daily_activities")]
subdomains$people_mental_health              <- indicators[c("people_mental_health", "people_suicide", "people_self_harm")]
subdomains$people_mortality                  <- indicators[c("people_avoidable_deaths", "people_infant_mortality", "people_life_expectancy", "people_all_mortality")]
subdomains$people_personal_wellbeing         <- indicators[c("people_life_worthwhileness", "people_anxiety", "people_happiness", "people_life_satisfaction")]
subdomains$people_physical_health_conditions <- indicators[c("people_cancer", "people_cardiovascular_conditions", "people_dementia", "people_diabetes", "people_respiratory_conditions")]

subdomains$lives_behavioural_risk_factors   <- indicators[c("lives_alcohol_misuse", "lives_healthy_eating", "lives_smoking")]
subdomains$lives_children_and_young_people  <- indicators[c("lives_gsce_attainment", "lives_pupil_absence", "lives_teenage_pregnancy", "lives_young_peoples_training")]
subdomains$lives_physiological_risk_factors <- indicators[c("lives_high_blood_pressure", "lives_low_birth_weight", "lives_childhood_overweight_obesity")]
subdomains$lives_protective_measures        <- indicators[c("lives_cancer_screening", "lives_child_vaccine_coverage")]

# subdomains$places_access_to_green_space           <- indicators[c("places_private_outdoor_space")] # NOTE: missing
subdomains$places_access_to_services              <- indicators[c("places_gp_travel_time", "places_pharmacy_travel_time", "places_sports_centre_travel_time", "places_internet_access")]
subdomains$places_crime                           <- indicators[c("places_personal_crime")]
subdomains$places_economic_and_working_conditions <- indicators[c("places_child_poverty", "places_unemployment")]
subdomains$places_living_conditions               <- indicators[c("places_air_pollution", "places_household_overcrowding", "places_noise_complaints", "places_road_safety")]

subdomains <- data.frame(ltla24_code = indicators$ltla24_code, sapply(subdomains, build_pc_indicators))


scores <- data.frame(ltla24_code = indicators$ltla24_code)

# healthy lives
scores$healthy_lives_score    <- rowSums(select(subdomains, starts_with("lives")))
scores$healthy_lives_rank     <- rank(scores$healthy_lives_score)
scores$healthy_lives_quantile <- quantise(scores$healthy_lives_rank)

# healthy places
scores$healthy_places_score    <- rowSums(select(subdomains, starts_with("places")))
scores$healthy_places_rank     <- rank(scores$healthy_places_score)
scores$healthy_places_quantile <- quantise(scores$healthy_places_rank)

# healthy people
scores$healthy_people_score    <- rowSums(select(subdomains, starts_with("people")))
scores$healthy_people_rank     <- rank(scores$healthy_people_score)
scores$healthy_people_quantile <- quantise(scores$healthy_people_rank)

# combined
scores$health_inequalities_score    <- rowSums(select(scores, ends_with("_score")))
scores$health_inequalities_rank     <- rank(scores$health_inequalities_score)
scores$health_inequalities_quantile <- quantise(scores$health_inequalities_rank)


#--- save ----------------------------------------------------------------------

ni_health_index_subdomains <- as_tibble(subdomains)
usethis::use_data(ni_health_index_subdomains, overwrite = TRUE)

ni_health_index <- as_tibble(scores)
usethis::use_data(ni_health_index, overwrite = TRUE)
