% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_data.R
\name{fetch_and_clean_raw_ENCODE_tables}
\alias{fetch_and_clean_raw_ENCODE_tables}
\title{Fetches and preprocess the raw metadata tables from ENCODE.}
\usage{
fetch_and_clean_raw_ENCODE_tables(
  cache_filename = "tables.RDA",
  types = get_encode_types(),
  overwrite = FALSE,
  precache = NULL
)
}
\arguments{
\item{cache_filename}{A file name for caching the selected tables into.}

\item{types}{The names of the tables to extract using the ENCODE rest api.}

\item{overwrite}{If cache_filename already exists, should it be overwritten?
Default: \code{FALSE}.}

\item{precache}{A path to cache the raw metadata as returned by ENCODE and
              parsed using jsonlite. If NULL, no caching is performed.
Default: \code{FALSE}.}
}
\value{
A \code{list} with all selected tables from ENCODE.
}
\description{
Fetches and preprocess the raw metadata tables from ENCODE.
}
\examples{
fetch_and_clean_raw_ENCODE_tables(cache_filename = "platform.RDA", types = "platform")
file.remove("platform.RDA")
    
}
