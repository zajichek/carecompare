\name{cms_payments}
\alias{cms_payments}
\title{Import CMS payment amounts}
\description{
Imports a dataset containing charge and payment amounts by MS-DRG for IPPS hospitals from 2019
}
\usage{
cms_payments()
}
\value{
A \code{tibble::tibble}
}
\author{Alex Zajichek}
\source{https://data.cms.gov/provider-summary-by-type-of-service/medicare-inpatient-hospitals/medicare-inpatient-hospitals-by-provider-and-service}
\examples{
cms_payments()
}  