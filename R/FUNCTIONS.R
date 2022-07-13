# Created: 2022-03-02
# Author: Alex Zajichek
# Project: carecompare
# Description: Package function definitions

### General Functions for the CMS Provider Data Catalog

# Name: pdc_topics
# Description: Returns the collection of topics data is available for
pdc_topics <-
  function() {
    
    # URL to query
    url <- "https://data.cms.gov/provider-data/api/1/search?fulltext=theme&page=1&page-size=20&sort-order=desc&facets=theme"
    
    # Request results
    request <- httr::GET(url)
    
    # Check for success
    if(request$status_code != 200)
      stop("Request did not return a successful status code.")
    
    # Extract the content
    request <- httr::content(request)
    
    # Extract needed components
    results <- request$facets
    
    # Iterate result, collect topic names
    topics <- c()
    for(i in seq_along(results))
      topics <- c(topics, results[[i]]$name)
    
    # Return the topics
    topics
    
  }

# Name: pdc_datasets
# Description: Returns information on available datasets for a given topic
pdc_datasets <-
  function(
    topics = NULL # Collection of topics to return dataset information for; returns all if left NULL
  ) {
    
    # Check for input topics
    if(is.null(topics))
      topics <- pdc_topics()
    
    # Iterate to import metadata
    dataset_list <- list()
    for(i in seq_along(topics)) {
      
      # Extract this topic
      this_topic <- topics[i]
      
      # Make the url
      url <- paste0("https://data.cms.gov/provider-data/api/1/search?sort=title&page=1&page-size=100&sort-order=asc&facets=0&theme=", stringr::str_replace_all(this_topic, " ", "%20"))
      
      # Request results, extract contents 
      request <- httr::content(httr::GET(url))
      
      # Extract the needed component
      results <- request$results
      
      # Iterate the response to extract metadata for each dataset
      temp_dataset_list <- list()
      for(j in seq_along(results)) 
        temp_dataset_list[[j]] <- tibble::tibble(datasetid = results[[j]]$identifier, topic = this_topic, title = results[[j]]$title, description = results[[j]]$description, issued = results[[j]]$issued, modified = results[[j]]$modified, downloadurl = results[[j]]$distribution[[1]]$downloadURL)
      
      # Bind rows
      temp_dataset_list <- dplyr::bind_rows(temp_dataset_list)
      
      # Add to master list
      dataset_list[[i]] <- temp_dataset_list
      
    }
    
    dataset_list %>%
      
      # Bind rows and return
      dplyr::bind_rows() %>%
      
      # Convert dates
      dplyr::mutate(
        dplyr::across(
          c(
            issued,
            modified
          ),
          as.Date
        )
      )
    
  }

# Name: pdc_read
# Description: Imports the specified dataset
pdc_read <-
  function(
    datasetid = NULL,
    ...
  ) {
    
    # Check for input
    if(is.null(datasetid)) 
      stop("Please specify a dataset identifier.")
    
    # Make the url
    url <- paste0("https://data.cms.gov/provider-data/api/1/metastore/schemas/dataset/items/", datasetid, "?show-reference-ids=false")
    
    # Make the request, extract the content
    request <- httr::content(httr::GET(url))
    
    # Update the variable
    downloadurl <- request$distribution[[1]]$data$downloadURL

    # Import the dataset
    readr::read_csv(
      file = downloadurl,
      ...
    )
    
  }

### Data Access Functions

# Name: cms_msdrg
# Description: Returns data frame of MSDRG weights and related information for most recent final rule
  # - Current: FY2022
cms_msdrg <-
  function() {
    
    # Set zip file name
    msdrg_zip <- "https://www.cms.gov/files/zip/fy2022-ipps-fr-table-5-fy-2022-ms-drgs-relative-weighting-factors-and-geometric-and-arithmetic-mean.zip"
    
    # Set data file name
    msdrg_file <- "CMS-1752-F Table 5.txt"
    
    # Create a temporary file (Credits: rpubs.com/otienodominic/398952)
    temp_file <- tempfile()
    
    # Download into the temporary file
    download.file(msdrg_zip, temp_file)
    
    # Unzip, and place the file in the current working directory
    unzip(temp_file, msdrg_file, exdir = ".")
    
    # Import the file
    msdrg <-
      readr::read_tsv(
        file = msdrg_file,
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
    file.remove(msdrg_file)
    unlink(temp_file)

    # Return dataset
    msdrg
    
  }

# Name: cms_payments
# Description: Returns data frame of payments made to each hospital by MSDRG
  # Current: 2019
cms_payments <-
  function() {
    
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
    
    # Return dataset
    payments
    
  }

