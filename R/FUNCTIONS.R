# Created: 2022-03-02
# Author: Alex Zajichek
# Project: carecompare
# Description: Package function definitions

# Name: show_topics
# Description: Returns the collection of topics data is available for
show_topics <-
  function() {
    
    # URL to query
    url <- "https://data.cms.gov/provider-data/api/1/search?fulltext=theme&page=1&page-size=20&sort-order=desc&facets=theme"
    
    # Request results, extract contents 
    request <- httr::content(httr::GET(url))
    
    # Extract needed components
    results <- request$facets
    
    # Iterate result, collect topic names
    topics <- c()
    for(i in seq_along(results))
      topics <- c(topics, results[[i]]$name)
    
    # Return the topics
    topics
    
  }

# Name: datasets
# Description: Returns information on available datasets for a given topic
list_datasets <-
  function(
    topics = NULL # Collection of topics to return dataset information for; returns all if left NULL
  ) {
    
    # Check for input topics
    if(is.null(topics))
      topics <- show_topics()
    
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

# Name: read_cms
# Description: Imports the specified dataset
read_cms <-
  function(
    datasetid = NULL,
    downloadurl = NULL,
    ...
  ) {
    
    # Check for at least one input
    if(is.null(datasetid) & is.null(downloadurl)) 
      stop("Please specify at least one dataset identifier.")
    
    # If the download url is not supplied, find it
    if(is.null(downloadurl)) {
      
      # Make the url
      url <- paste0("https://data.cms.gov/provider-data/api/1/metastore/schemas/dataset/items/", datasetid, "?show-reference-ids=false")
      
      # Make the request, extract the content
      request <- httr::content(httr::GET(url))
      
      # Update the variable
      downloadurl <- request$distribution[[1]]$data$downloadURL
      
    }
    
    # Import the dataset
    readr::read_csv(
      file = downloadurl,
      ...
    )
    
  }
