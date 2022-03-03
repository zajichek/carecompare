\name{datasets}
\alias{datasets}
\title{Extract dataset information}
\description{
Obtains metadata for the datasets in the supplied topics, including dataset identifiers, titles, descriptions, dates, and URLs.
}
\usage{
datasets(
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
datasets("Hospitals")
}  
