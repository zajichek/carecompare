
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
topics <- topics()
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
hospitals <- datasets("Hospitals")
hospitals %>% 
  head() %>%
  knitr::kable(format = "pandoc")
```

| datasetid | topic     | title                                                                   | description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | issued     | modified   | downloadurl                                                                                                                                          |
|:----------|:----------|:------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------|:-----------|:-----------------------------------------------------------------------------------------------------------------------------------------------------|
| 4jcv-atw7 | Hospitals | Ambulatory Surgical Center Quality Measures - Facility                  | A list of ambulatory surgical centers participating in the Ambulatory Surgical Center Quality Reporting (ASCQR) Program and their performance rates for calendar years 2019 and 2020.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 2022-01-07 | 2022-01-07 | <https://data.cms.gov/provider-data/sites/default/files/resources/9f2d12e524d9ab36a0046ce25d6ac22a_1641873914/ASC_Facility.csv>                      |
| axe7-s95e | Hospitals | Ambulatory Surgical Center Quality Measures - State                     | This file contains state-level data for all measures reported through the Ambulatory Surgical Center Quality Reporting Program for calendar years 2019 and 2020.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | 2022-01-07 | 2022-01-07 | <https://data.cms.gov/provider-data/sites/default/files/resources/8fcad48fb47852d29549b98e93b9b178_1641873917/ASC_State.csv>                         |
| wue8-3vwe | Hospitals | Ambulatory Surgical Center Quality Measures - National                  | This file contains the national averages for all measures reported through the Ambulatory Surgical Center Quality Reporting Program for calendar years 2019 and 2020.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 2022-01-07 | 2022-01-07 | <https://data.cms.gov/provider-data/sites/default/files/resources/eeab0bd6ff1f6704bd1febeeb7281b5f_1641873915/ASC_National.csv>                      |
| muwa-iene | Hospitals | CMS Medicare PSI-90 and component measures - six-digit estimate dataset | This data set includes the Patient Safety and Adverse Events Composite measure (CMS Medicare PSI 90) and the individual CMS Patient Safety Indicators. CMS Medicare PSI 90 is a composite complication measure composed from 10 separate Patient Safety Indicators. The measure provides an overview of hospital-level quality as it relates to a set of potentially preventable hospital-related events associated with harmful outcomes for patients. NOTICE: Data from the 1st and 2nd quarters of 2020 are not being reported due to the impact of the COVID-19 pandemic. For more information, please reference <https://qualitynet.cms.gov/files/5fb838aef61c410025a64709?filename=2020-111-IP.pdf>. | 2020-12-10 | 2022-01-07 | <https://data.cms.gov/provider-data/sites/default/files/resources/06f0a6eff78f06b8bee4b4bf4a1f20a2_1641873919/CMS_PSI_6_decimal_file.csv>            |
| ynj2-r877 | Hospitals | Complications and Deaths - Hospital                                     | Complications and deaths - provider data. This data set includes provider-level data for the hip/knee complication measure, the CMS Patient Safety Indicators, and 30-day death rates. NOTICE: Data from the 1st and 2nd quarters of 2020 are not being reported due to the impact of the COVID-19 pandemic. For more information, please reference <https://qualitynet.cms.gov/files/5fb838aef61c410025a64709?filename=2020-111-IP.pdf>.                                                                                                                                                                                                                                                                  | 2020-12-10 | 2022-01-07 | <https://data.cms.gov/provider-data/sites/default/files/resources/1818d71cb5d94636b87ed8459af818d6_1641873920/Complications_and_Deaths-Hospital.csv> |
| qqw3-t4ie | Hospitals | Complications and Deaths - National                                     | Complications and deaths - national data. This data set includes national-level data for the hip/knee complication measure, the CMS Patient Safety Indicators, and 30-day death rates. NOTICE: Data from the 1st and 2nd quarters of 2020 are not being reported due to the impact of the COVID-19 pandemic. For more information, please reference <https://qualitynet.cms.gov/files/5fb838aef61c410025a64709?filename=2020-111-IP.pdf>.                                                                                                                                                                                                                                                                  | 2020-12-10 | 2022-01-07 | <https://data.cms.gov/provider-data/sites/default/files/resources/38113f000450f4087877f618fc6441a6_1641873921/Complications_and_Deaths-National.csv> |

``` r
# Import the data for a given dataset
read_cms(
  datasetid = "ynj2-r877"
)
#> Rows: 92112 Columns: 18
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (17): Facility ID, Facility Name, Address, City, State, ZIP Code, County...
#> dbl  (1): Footnote
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> # A tibble: 92,112 × 18
#>    `Facility ID` `Facility Name`    Address City  State `ZIP Code` `County Name`
#>    <chr>         <chr>              <chr>   <chr> <chr> <chr>      <chr>        
#>  1 010001        SOUTHEAST HEALTH … 1108 R… DOTH… AL    36301      HOUSTON      
#>  2 010001        SOUTHEAST HEALTH … 1108 R… DOTH… AL    36301      HOUSTON      
#>  3 010001        SOUTHEAST HEALTH … 1108 R… DOTH… AL    36301      HOUSTON      
#>  4 010001        SOUTHEAST HEALTH … 1108 R… DOTH… AL    36301      HOUSTON      
#>  5 010001        SOUTHEAST HEALTH … 1108 R… DOTH… AL    36301      HOUSTON      
#>  6 010001        SOUTHEAST HEALTH … 1108 R… DOTH… AL    36301      HOUSTON      
#>  7 010001        SOUTHEAST HEALTH … 1108 R… DOTH… AL    36301      HOUSTON      
#>  8 010001        SOUTHEAST HEALTH … 1108 R… DOTH… AL    36301      HOUSTON      
#>  9 010001        SOUTHEAST HEALTH … 1108 R… DOTH… AL    36301      HOUSTON      
#> 10 010001        SOUTHEAST HEALTH … 1108 R… DOTH… AL    36301      HOUSTON      
#> # … with 92,102 more rows, and 11 more variables: `Phone Number` <chr>,
#> #   `Measure ID` <chr>, `Measure Name` <chr>, `Compared to National` <chr>,
#> #   Denominator <chr>, Score <chr>, `Lower Estimate` <chr>,
#> #   `Higher Estimate` <chr>, Footnote <dbl>, `Start Date` <chr>,
#> #   `End Date` <chr>
```
