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
#'
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
