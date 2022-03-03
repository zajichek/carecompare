\name{read_cms}
\alias{read_cms}
\title{Import a dataset from the Provider Data Catalog}
\description{
Imports a specified dataset from the CMS Provider Data Catalog using \code{readr::read_csv}. 
}
\usage{
read_cms(
  datasetid = NULL,
  downloadurl = NULL,
  ...
)
}
\arguments{
\item{datasetid}{A dataset identifier. Used only if the download URL is not specified.}
\item{downloadurl}{The direct URL to the dataset of interest.}
\item{...}{Additional arguments passed to \code{\link{readr::read_csv}}.}
}
\value{
A \code{tibble::tibble}
}
\author{Alex Zajichek}
\examples{
read_cms(
  datasetid = "qqw3-t4ie"
)
}  
