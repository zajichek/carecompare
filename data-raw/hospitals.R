# Created: 2022-07-10
# Author: Alex Zajichek
# Project: carecompare
# Description: Builds hospital dataset in /data

# Load package
require(magrittr)

# Hospitals registered with Medicare (from data.cms.gov, updated annually)
hospital_file <- "https://data.cms.gov/provider-data/sites/default/files/resources/092256becd267d9eeccf73bf7d16c46b_1641873938/Hospital_General_Information.csv"

# Import file
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
  ) %>%
  
  # Create an address string to feed
  dplyr::mutate(
    FullAddress = paste0(Address, ", ", City, ", ", State, ", ", Zip, ", United States of America")
  )

## Add geocoded hospital addresses (using opencage: https://opencagedata.com/)

# Supply the API key (must create a user account)
opencage::oc_config(key = rstudioapi::askForPassword("Enter API Key"))

# Using free account (limited to 2500 requests per day), so will split up and run over multiple days
hospitals_split <-
  hospitals %>%
  
  # Keep a couple columns
  dplyr::select(
    HospitalID,
    FullAddress
  ) %>%
  
  # Split into a list
  split(rep(1:3, length.out = nrow(.), each = ceiling(nrow(.)/3)))

# Batch 1 (7/9/22)
batch1 <-
  hospitals_split[[1]] %>%
  
  # Forward geocode
  opencage::oc_forward_df(
    placename = FullAddress
  )

# Batch 2 
batch2 <-
  hospitals_split[[2]] %>%
  
  # Forward geocode
  opencage::oc_forward_df(
    placename = FullAddress
  )

# Batch 3
batch3 <-
  hospitals_split[[3]] %>%
  
  # Forward geocode
  opencage::oc_forward_df(
    placename = FullAddress
  )

# Update the dataset with coordinates
hospitals <-
  hospitals %>%
  
  # Join to attach hospital coordinates
  dplyr::left_join(
    y = 
      batch1 %>%
      dplyr::bind_rows(batch2) %>% 
      dplyr::bind_rows(batch3) %>%
      dplyr::select(
        HospitalID,
        Latitude = oc_lat,
        Longitude = oc_lng
      ),
    by = "HospitalID"
  )

# Save to /data
save(hospitals, file = "data/hospitals.rda")
