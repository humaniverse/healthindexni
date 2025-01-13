# Raw data files were not available to download from online.
# Noise-complaints data was available from a published reported (sourced below).
# Data is available in the following file path:
# healthindexni > data-raw > healthy-people > noise-complaints.xlsx

# ---- Load packages ----
library(tidyverse)
library(httr)
library(readxl)
library(geographr)

# ---- Get and clean data ----
# Noise Complaints Data
# Source: https://www.daera-ni.gov.uk/sites/default/files/publications/daera/Noise%20Complaint%20Statistics%20for%20NI%202023-24.PDF

