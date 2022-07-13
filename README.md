
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="man/figures/carecompare.png" width="200" />

<!-- badges: start -->

[![CRAN
Status](https://www.r-pkg.org/badges/version/carecompare)](https://cran.r-project.org/package=carecompare)
![CRAN_Download_Counter](http://cranlogs.r-pkg.org/badges/grand-total/carecompare)
<!-- badges: end -->

***Currently in development***

# Introduction

The `carecompare` package is an `R` toolkit built to enable US hospitals
and health systems to access, explore, and analyze performance in
[quality measures and payment programs](https://qualitynet.cms.gov/)
from the [*Centers for Medicare and Medicaid
Services*](https://www.cms.gov/) *(CMS)*.

## Installation

-   From source

`devtools::install_github("zajichek/carecompare")`

## Load

``` r
require(carecompare)
#> Loading required package: carecompare
```

# Accessing Data

## Generic access to the [CMS Provider Data Catalog](https://data.cms.gov/provider-data/).

``` r

# Extract the topics
topics <- pdc_topics()
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
hospital_data <- pdc_datasets("Hospitals")
hospital_data
#> # A tibble: 67 × 7
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
#>  9 bzsr-4my4 Hospitals Data Updat… Lists the … 2020-12-10 2022-03-21 https://da…
#> 10 y9us-9xdf Hospitals Footnote C… The footno… 2020-12-10 2021-09-22 https://da…
#> # … with 57 more rows

# Search for a dataset
hospital_data %>% 
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
pdc_read(
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

## Formatted datasets

``` r
hospitals
#> # A tibble: 5,306 × 12
#>    HospitalID Name  Address City  State Zip   County Type  Ownership FullAddress
#>    <chr>      <chr> <chr>   <chr> <chr> <chr> <chr>  <chr> <chr>     <chr>      
#>  1 010001     SOUT… 1108 R… DOTH… AL    36301 HOUST… Acut… Governme… 1108 ROSS …
#>  2 010005     MARS… 2505 U… BOAZ  AL    35957 MARSH… Acut… Governme… 2505 U S H…
#>  3 010006     NORT… 1701 V… FLOR… AL    35630 LAUDE… Acut… Propriet… 1701 VETER…
#>  4 010007     MIZE… 702 N … OPP   AL    36467 COVIN… Acut… Voluntar… 702 N MAIN…
#>  5 010008     CREN… 101 HO… LUVE… AL    36049 CRENS… Acut… Propriet… 101 HOSPIT…
#>  6 010011     ST. … 50 MED… BIRM… AL    35235 JEFFE… Acut… Voluntar… 50 MEDICAL…
#>  7 010012     DEKA… 200 ME… FORT… AL    35968 DE KA… Acut… Propriet… 200 MED CE…
#>  8 010016     SHEL… 1000 F… ALAB… AL    35007 SHELBY Acut… Voluntar… 1000 FIRST…
#>  9 010018     CALL… 1720 U… BIRM… AL    35233 JEFFE… Acut… Voluntar… 1720 UNIVE…
#> 10 010019     HELE… 1300 S… SHEF… AL    35660 COLBE… Acut… Governme… 1300 SOUTH…
#> # … with 5,296 more rows, and 2 more variables: Latitude <dbl>, Longitude <dbl>
cms_payments()
#> # A tibble: 188,806 × 6
#>    HospitalID MSDRGCode Discharges AverageCoveredCharges AverageTotalPayment
#>    <chr>      <chr>          <dbl>                 <dbl>               <dbl>
#>  1 010001     003               14               326515.              62788.
#>  2 010001     023               55               140875.              29767.
#>  3 010001     024               20               109788.              22780.
#>  4 010001     025               23               124579.              24107.
#>  5 010001     027               16                75029.              18216.
#>  6 010001     038               20                73875.               9721.
#>  7 010001     039               45                47281.               6985.
#>  8 010001     054               11                34797.               7782 
#>  9 010001     056               15                66157.              11793.
#> 10 010001     057               38                27677.               7393.
#> # … with 188,796 more rows, and 1 more variable: AverageMedicarePayment <dbl>
cms_msdrg()
#> Rows: 767 Columns: 9
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: "\t"
#> chr (6): MS-DRG, FY 2022 Final Post-Acute DRG, FY 2022 Final Special Pay DRG...
#> dbl (3): Weights, Geometric mean LOS, Arithmetic mean LOS
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> # A tibble: 767 × 7
#>    MSDRGCode MSDRGDescription      MSDRGType MajorDiagnostic… Weight GMLOS AMLOS
#>    <chr>     <chr>                 <chr>     <chr>             <dbl> <dbl> <dbl>
#>  1 001       HEART TRANSPLANT OR … SURG      PRE               28.9   30.1  39.1
#>  2 002       HEART TRANSPLANT OR … SURG      PRE               15.0   15.4  18.2
#>  3 003       ECMO OR TRACHEOSTOMY… SURG      PRE               19.1   22.4  30.2
#>  4 004       TRACHEOSTOMY WITH MV… SURG      PRE               11.9   20    24.6
#>  5 005       LIVER TRANSPLANT WIT… SURG      PRE               10.2   14.4  19.4
#>  6 006       LIVER TRANSPLANT WIT… SURG      PRE                4.70   7.5   8.1
#>  7 007       LUNG TRANSPLANT       SURG      PRE               11.6   17.4  20.8
#>  8 008       SIMULTANEOUS PANCREA… SURG      PRE                5.43   9    10.2
#>  9 010       PANCREAS TRANSPLANT   SURG      PRE                3.62   8     9.1
#> 10 011       TRACHEOSTOMY FOR FAC… SURG      PRE                5.02  10.9  13.8
#> # … with 757 more rows
```
