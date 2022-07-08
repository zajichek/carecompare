# Load packages
require(magrittr)

# Hospitals registered with Medicare (from data.cms.gov)
hospital_file <- "https://data.cms.gov/provider-data/sites/default/files/resources/092256becd267d9eeccf73bf7d16c46b_1641873938/Hospital_General_Information.csv"

hospitals <-
  
  # Import the dataset
  readr::read_csv(
    file = hospital_file
  ) %>%
  
  # Select/rename columns
  dplyr::select(
    HospitalID = `Facility ID`,
    Name = `Facility Name`,
    Address,
    City,
    State,
    Zip = `ZIP Code`,
    County = `County Name`,
    Type = `Hospital Type`,
    Ownership = `Hospital Ownership`
  ) 

# Save to package sub-directory
save(hospitals, file = "data/hospitals.rda")
