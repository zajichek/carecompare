# Created: 2022-07-10
# Author: Alex Zajichek
# Project: carecompare
# Description: Builds data sets found in /data

# Load package
require(magrittr)

### Name: msdrg
### Description: FY22 final rule MSDRG weights
### Source: https://www.cms.gov/medicare/acute-inpatient-pps/fy-2022-ipps-final-rule-home-page

# Set file name
msdrg_zip <- "https://www.cms.gov/files/zip/fy2022-ipps-fr-table-5-fy-2022-ms-drgs-relative-weighting-factors-and-geometric-and-arithmetic-mean.zip"

# Create a temporary file (Credits: rpubs.com/otienodominic/398952)
temp_file <- tempfile()

# Download into the temporary file
download.file(msdrg_zip, temp_file)

# Import the file
msdrg <-
  readr::read_tsv(
    file = unzip(temp_file, "CMS-1752-F Table 5.txt"),
    skip = 1,
    na = c("", " ", "NA", "**", ".")
  ) %>%
  
  # Rename columns
  dplyr::select(
    MSDRGCode = `MS-DRG`,
    MSDRGDescription = `MS-DRG Title`,
    MSDRGType = TYPE,
    MajorDiagnosticCategory = MDC,
    Weight = Weights,
    GMLOS = `Geometric mean LOS`,
    AMLOS = `Arithmetic mean LOS`
  )

# Remove temporary file
unlink(temp_file)

# Save to /data
save(msdrg, file = "data/msdrg.rda")

### Name: payments
### Description: 2019 Medicare payments by MS-DRG and hospital
### Source: https://data.cms.gov/provider-summary-by-type-of-service/medicare-inpatient-hospitals/medicare-inpatient-hospitals-by-provider-and-service

# Payments file
payments_file <- "https://data.cms.gov/data-api/v1/dataset/3cb202ad-fd90-45eb-b12e-febaa57356fe/data.csv"

# Import the file
payments <-
  readr::read_csv(
    file = payments_file,
    col_types = 
      list(
        Tot_Dschrgs = readr::col_number(),
        Avg_Submtd_Cvrd_Chrg = readr::col_number(),
        Avg_Tot_Pymt_Amt = readr::col_number(),
        Avg_Mdcr_Pymt_Amt = readr::col_number()
      )
  ) %>%
  
  # Select and rename columns
  dplyr::transmute(
    HospitalID = Rndrng_Prvdr_CCN,
    MSDRGCode = DRG_Cd,
    Discharges = Tot_Dschrgs,
    AverageCoveredCharges = Avg_Submtd_Cvrd_Chrg,
    AverageTotalPayment = Avg_Tot_Pymt_Amt,
    AverageMedicarePayment = Avg_Mdcr_Pymt_Amt
  )

# Save to /data
save(payments, file = "data/payments.rda")

### Name: hospitals
### Description: Hospitals registered with Medicare
### Source: https://data.cms.gov/provider-data/dataset/xubh-q36u

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
  ) %>%
  
  # Join to get total payment amounts
  dplyr::left_join(
    y = 
      payments %>%
      
      # Send down the rows
      tidyr::pivot_longer(
        cols = tidyselect::starts_with("Average"),
        names_prefix = "^Average"
      ) %>%
      
      # For each hospital, metric
      dplyr::group_by(HospitalID, name) %>%
      
      # Compute the totals via weighted-sum
      dplyr::summarise(
        value = sum(Discharges * value),
        .groups = "drop"
      ) %>%
      
      # Send over columns
      tidyr::pivot_wider(
        names_from = name,
        values_from = value
      ),
    by = "HospitalID"
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

# save(batch3, file = "batch3.Rda")

# Update the dataset with coordinates
hospitals <-
  hospitals %>%
  
  # Join to attach hospital coordinates
  dplyr::left_join(
    y = 
      batch1 %>%
      dplyr::bind_rows(batch2) %>% # dplyr::bind_rows(batch3)
      dplyr::select(
        HospitalID,
        Latitude = oc_lat,
        Longitude = oc_lng
      ),
    by = "HospitalID"
  )

# Save to /data
save(hospitals, file = "data/hospitals.rda")
