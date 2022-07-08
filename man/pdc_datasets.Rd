\name{pdc_datasets}
\alias{pdc_datasets}
\title{Extract dataset information from the CMS Provider Data Catalog}
\description{
Obtains metadata for the datasets in the supplied topics, including dataset identifiers, titles, descriptions, dates, and URLs.
}
\usage{
pdc_datasets(
  topics = NULL
)
}
\arguments{
\item{topics}{One or more topic names to request dataset information for. If \code{NULL}, all topics are selected.}
}
\value{
A \code{tibble::tibble}
}
\author{Alex Zajichek}
\examples{
pdc_datasets("Hospitals")
}  
