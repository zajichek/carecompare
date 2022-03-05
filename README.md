
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="man/figures/carecompare.png" width="200" />

<!-- badges: start -->

[![CRAN
Status](https://www.r-pkg.org/badges/version/carecompare)](https://cran.r-project.org/package=carecompare)
![CRAN_Download_Counter](http://cranlogs.r-pkg.org/badges/grand-total/carecompare)
<!-- badges: end -->

***Currently in development***

# Introduction

The `carecompare` package contains tools for accessing, exploring and
analyzing the [CMS Provider Data
Catalog](https://data.cms.gov/provider-data/)

``` r
# Load the package
require(carecompare)
#> Loading required package: carecompare

# Extract the topics
topics <- show_topics()
topics
#>  [1] "Helpful Contacts"                      
#>  [2] "Dialysis facilities"                   
#>  [3] "Home health services"                  
#>  [4] "Hospice care"                          
#>  [5] "Hospitals"                             
#>  [6] "Inpatient rehabilitation facilities"   
#>  [7] "Long-term care hospitals"              
#>  [8] "Nursing homes including rehab services"
#>  [9] "Physician office visit costs"          
#> [10] "Doctors and clinicians"                
#> [11] "Supplier directory"                    
#> [12] "Medicare plan finder"

# Examine the metadata for a given topic
hospitals <- list_datasets("Hospitals")
hospitals 
#> # A tibble: 68 × 7
#>    datasetid topic     title       description issued     modified   downloadurl
#>    <chr>     <chr>     <chr>       <chr>       <date>     <date>     <chr>      
#>  1 4jcv-atw7 Hospitals Ambulatory… A list of … 2022-01-07 2022-01-07 https://da…
#>  2 axe7-s95e Hospitals Ambulatory… This file … 2022-01-07 2022-01-07 https://da…
#>  3 wue8-3vwe Hospitals Ambulatory… This file … 2022-01-07 2022-01-07 https://da…
#>  4 muwa-iene Hospitals CMS Medica… This data … 2020-12-10 2022-01-07 https://da…
#>  5 ynj2-r877 Hospitals Complicati… Complicati… 2020-12-10 2022-01-07 https://da…
#>  6 qqw3-t4ie Hospitals Complicati… Complicati… 2020-12-10 2022-01-07 https://da…
#>  7 bs2r-24vh Hospitals Complicati… Complicati… 2020-12-10 2022-01-07 https://da…
#>  8 tqkv-mgxq Hospitals Comprehens… Comprehens… 2020-12-10 2021-06-15 https://da…
#>  9 bzsr-4my4 Hospitals Data Updat… Lists the … 2020-12-10 2022-01-07 https://da…
#> 10 y9us-9xdf Hospitals Footnote C… The footno… 2020-12-10 2021-09-22 https://da…
#> # … with 58 more rows

# Search for a dataset
hospitals %>% 
  dplyr::filter(
    title %>%
      stringr::str_detect(
        pattern = "(?i)readmission"
      )
  ) %>%
  knitr::kable(format = "pandoc")
```

| datasetid | topic     | title                                   | description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | issued     | modified   | downloadurl                                                                                                                                                                 |
|:----------|:----------|:----------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------|:-----------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 9n3s-kdb3 | Hospitals | Hospital Readmissions Reduction Program | In October 2012, CMS began reducing Medicare payments for subsection(d) hospitals with excess readmissions under the Hospital Readmissions Reduction Program (HRRP). Excess readmissions are measured by a ratio, calculated by dividing a hospital’s predicted rate of readmissions for heart attack (AMI), heart failure (HF), pneumonia, chronic obstructive pulmonary disease (COPD), hip/knee replacement (THA/TKA), and coronary artery bypass graft surgery (CABG) by the expected rate of readmissions, based on an average hospital with similar patients. | 2020-12-10 | 2022-01-19 | <https://data.cms.gov/provider-data/sites/default/files/resources/6862887588c0e2d720f0c821f6ed8e76_1642665920/FY_2022_Hospital_Readmissions_Reduction_Program_Hospital.csv> |

``` r
# Import the data for a given dataset
read_cms(
  datasetid = "9n3s-kdb3"
)
#> Rows: 19020 Columns: 12
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (11): Facility Name, Facility ID, State, Measure Name, Number of Dischar...
#> dbl  (1): Footnote
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> # A tibble: 19,020 × 12
#>    `Facility Name`  `Facility ID` State `Measure Name` `Number of Dis…` Footnote
#>    <chr>            <chr>         <chr> <chr>          <chr>               <dbl>
#>  1 SOUTHEAST HEALT… 010001        AL    READM-30-HIP-… 165                    NA
#>  2 SOUTHEAST HEALT… 010001        AL    READM-30-CABG… 193                    NA
#>  3 SOUTHEAST HEALT… 010001        AL    READM-30-AMI-… 424                    NA
#>  4 SOUTHEAST HEALT… 010001        AL    READM-30-HF-H… 905                    NA
#>  5 SOUTHEAST HEALT… 010001        AL    READM-30-COPD… 310                    NA
#>  6 SOUTHEAST HEALT… 010001        AL    READM-30-PN-H… 504                    NA
#>  7 MARSHALL MEDICA… 010005        AL    READM-30-COPD… 378                    NA
#>  8 MARSHALL MEDICA… 010005        AL    READM-30-AMI-… N/A                    NA
#>  9 MARSHALL MEDICA… 010005        AL    READM-30-HF-H… 223                    NA
#> 10 MARSHALL MEDICA… 010005        AL    READM-30-CABG… N/A                     5
#> # … with 19,010 more rows, and 6 more variables:
#> #   `Excess Readmission Ratio` <chr>, `Predicted Readmission Rate` <chr>,
#> #   `Expected Readmission Rate` <chr>, `Number of Readmissions` <chr>,
#> #   `Start Date` <chr>, `End Date` <chr>
```
