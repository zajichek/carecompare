\name{pdc_read}
\alias{pdc_read}
\title{Import a dataset from the CMS Provider Data Catalog}
\description{
Imports a dataset from the CMS Provider Data Catalog given a dataset identifier. 
}
\usage{
pdc_read(
  datasetid = NULL,
  ...
)
}
\arguments{
\item{datasetid}{A dataset identifier. Used only if the download URL is not specified.}
\item{...}{Additional arguments passed to \code{\link{readr::read_csv}}.}
}
\value{
A \code{tibble::tibble}
}
\author{Alex Zajichek}
\examples{
pdc_read(
  datasetid = "qqw3-t4ie"
)
}  
