#' Percentage of Absolute Child Poverty (2017)
#'
#' A dataset containing statistics on the percentage of children (aged 15 and
#' under) living in absolute low income families in each Council, 2017.
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{child_poverty_percentage}{Percentage of children 15 and under living in
#' absolute low incomes families (where a household's income is below 60% of
#' the median income in 2010/11, adjusted for inflation).}
#' \item{year}{Year}
#'
#' ...
#' }
#' @source \url{https://data.nisra.gov.uk/}
#'
"lives_child_poverty"

#' Percentage GSCE Attainment, including Maths and English (2022/23)
#'
#' A dataset containing statistics on the percentage of GSCE attainment,
#' including Maths and English (A-C grade).
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{gcse_qualifications_percent}{Grade A-C percentage of GSCEs, including
#' Maths and English on results day, by Council, end of school year 2023}
#' \item{year}{School Year}
#'
#' ...
#' }
#' @source \url{https://data.nisra.gov.uk/}
#'
"lives_gsce_attainment"

#' Percentage of Babies Born Not at a Healthy Birth Weight (2022-2023)
#'
#' A dataset containing percentage babies born not at a healthy birth weight.
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{low_birth_weight_percentage}{Percentage of babies born not at a healthy birth weight}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{https://www.publichealth.hscni.net/publications/statistical-profile-childrens-health-northern-ireland-202223}
#'
"lives_low_birth_weight"

#' Average percentage of Children Overweight/Obese (2022/23)
#'
#' A dataset containing statistics on the average percentage of children
#' clinically classed as overweight and obese in each Council, 2022/23.
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{overweight_obesity_percentage}{Average percentage of children clinically
#' classed as overweight and obese in P1 and P6 (aged 4/5 and 10/11)}
#' \item{year}{School Year}
#'
#' ...
#' }
#' @source \url{https://data.nisra.gov.uk/}
#'
"lives_childhood_overweight_obesity"

#' Percentage of Pupil Absences (2021/22)
#'
#' A dataset containing statistics on the percentage of unauthorised school
#' absences.
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{total_pupil_absence_percentage}{Percentage of unauthorised school
#' absences across primary, secondary, and special schools}
#' \item{year}{School Year}
#'
#' ...
#' }
#' @source \url{https://data.nisra.gov.uk/}
#'
"lives_pupil_absence"

#' Rates of teenage pregnancies per 1,000 (2020-22)
#'
#' A dataset containing statistics on the rate of teenage pregnancies per 1k.

#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{teenage_pregnancies_per_1k}{Rate of teenage pregnancies per 1k where
#' teenagers are aged between 13 and 19}
#' \item{year}{3-year aggregated period}
#'
#' ...
#' }
#' @source \url{https://data.nisra.gov.uk/}
#'
"lives_teenage_pregnancy"

#' Percentage of Young People in Education, Employment, and Training (2022/23)
#'
#' A dataset containing statistics on the percentage of young people (aged 16-18)
#' who are in education, employment, and training.
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{young_peoples_eet_percentage}{Percentage of young people (aged 16-18 in
#' Years 12-14) who are in education, employment, and training}
#' \item{year}{School Year}
#'
#' ...
#' }
#' @source \url{https://data.nisra.gov.uk/}
#'
"lives_young_peoples_training"

##' Percentage of People Experiencing Unemployment (2023)
#'
#' A dataset containing statistics on the percentage of people experiencing
#' unemployment, claiming unemployed-related benefits.
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{unemployment_percentage}{Percentage of people experiencing unemployment
#' and claiming unemployed-related benefits(Jobseeker’s Allowance plus
#' out-of-work Universal Credit claimants who were claiming principally
#' for the reason of being unemployed.)}
#' \item{year}{Year}
#'
#' ...
#' }
#' @source \url{https://data.nisra.gov.uk/}
#'
"lives_unemployment"

#' Mortality all causes rate per 100k (2020-22)
#'
#' A dataset containing statistics from an age-sex standardised rate for all
#' causes of mortality per 100k, by Council (2020-22).
#'
#' To note: England's Health Index uses a single year to calculate mortality rates
#' from all causes. Northern Ireland only has 3-year aggregate data available.
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{death_rate_per_100k}{age-sex standardised rate for all causes of
#' mortality per 100k}
#' \item{year}{3-year aggregated period}
#'
#' ...
#' }
#' @source \url{https://data.nisra.gov.uk/}
#'
"people_all_mortality"

#' Average Measurement of Anxiety Out of 10 (2022-23)
#'
#' A dataset containing statistics of personal ratings on feelings of
#' anxiety out of 10, by Council (2022-23).
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{anxiety_score_out_of_10}{Average personal ratings on feelings of
#' anxiety out of 10 - 10 is most anxious, 1 is least anxious}
#' \item{year}{Time period}
#' ...
#' }
#' @source \url{https://www.ons.gov.uk/datasets/wellbeing-local-authority/editions/time-series/versions/4}
"people_anxiety"

#' Percentage of People Aged 15-64 with Long-Term Health Problem/Disability
#' that Limits Daily Activities
#'
#' A dataset containing statistics on the percentage of people aged 15-64 with
#' long-term health problem/disability that limits daily activities, by Council
#' (2021).
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{disability_activities_limited_percentage}{percentage of people aged 15-64
#' with long-term health problem/disability that limits daily activities by a
#' lot or by a little.}
#' \item{year}{Year}
#'
#' ...
#' }
#' @source \url{https://www.nisra.gov.uk/publications/census-2021-main-statistics-health-disability-and-unpaid-care-tables}
#'
"people_disability_daily_activities"


#' Rate of Self-Harm Related Admissions per 100,000 (2018/19-2022/23)
#'
#' A dataset containing statistics on the rate of self-harm related admissions
#' per 100k, per Council (2018/19-2022/23).
#'
#' To note: England's Health Index collects rate of self-harm admissions per
#' 100k in single-year increments. Only data available for Northern Ireland looks
#' at 5-year aggregates across financial years.
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{self_harm_per_100k}{Rate of self-harm related admissions per 100k,
#' standardised by age and sex with respect to the European Standard Population
#' 2013}
#' \item{year}{Grouped financial year aggregrate, 5 year period}
#'
#' ...
#' }
#' @source \url{https://data.nisra.gov.uk/}
#'
"people_self_harm"

#' Average Measurement of Life Satisfaction Out of 10 (2022-23)
#'
#' A dataset containing statistics of personal ratings on feelings of
#' life satisfaction out of 10, by Council (2022-23).
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{satisfaction_score_out_of_10}{Average personal ratings on feelings of
#' life satisfaction out of 10 - 10 is most satisfied, 1 is least satisfied}
#' \item{year}{Time period}
#' ...
#' }
#' @source \url{https://www.ons.gov.uk/datasets/wellbeing-local-authority/editions/time-series/versions/4}
"people_life_satisfaction"
