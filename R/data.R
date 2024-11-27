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

#' Travel time to GPs
#'
#' A dataset containing the average (median) travel time (in minutes) to the nearest
#' GP in each Local Government District. This is based on the travel time to the
#' nearest GP in each Super Data Zone within a Local Government District.
#'
#' Travel times are calculated using the TravelTime API (https://traveltime.com/apis/distance-matrix)
#' and are based on travelling by public transport on a weekday morning.
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#'   \item{lgd14_code}{Local Authority Code}
#'   \item{gp_median_travel_time}{Median travel time (in minutes) to the nearest
#'   GP among all the Super Data Zones within a Local Authority}
#'   \item{year}{Year the data was last updated}
#'   ...
#' }
#' @source \url{https://openstreetmap.org/}
#'
"places_gp_travel_time"

#' Travel time to pharmacies
#'
#' A dataset containing the average (median) travel time (in minutes) to the nearest
#' pharmacy in each Local Government District. This is based on the travel time to the
#' nearest sports centre in each Super Data Zone within a Local Government District.
#'
#' Travel times are calculated using the TravelTime API (https://traveltime.com/apis/distance-matrix)
#' and are based on travelling by public transport on a weekday morning.
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#'   \item{lgd14_code}{Local Authority Code}
#'   \item{pharmacy_median_travel_time}{Median travel time (in minutes) to the nearest
#'   pharmacy among all the Super Data Zones within a Local Authority}
#'   \item{year}{Year the data was last updated}
#'   ...
#' }
#' @source \url{https://openstreetmap.org/}
#'
"places_pharmacy_travel_time"

#' Travel time to sports facilities
#'
#' A dataset containing the average (median) travel time (in minutes) to the nearest
#' sports centre in each Local Government District. This is based on the travel
#' time to the nearest sports centre in each Super Data Zone within a Local Government District.
#'
#' Travel times are calculated using the TravelTime API (https://traveltime.com/apis/distance-matrix)
#' and are based on travelling by public transport on a weekday morning.
#'
#' @format A data frame with 11 rows and 3 variables:
#' \describe{
#'   \item{lgd14_code}{Local Authority Code}
#'   \item{pharmacy_median_travel_time}{Median travel time (in minutes) to the nearest
#'   pharmacy among all the Super Data Zones within a Local Authority}
#'   \item{year}{Year the data was last updated}
#'   ...
#' }
#' @source \url{https://openstreetmap.org/}
#'
"places_sports_centre_travel_time"
