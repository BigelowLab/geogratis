% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geoloc.R
\name{parse_geoloc}
\alias{parse_geoloc}
\title{Retrieve sf data frame from geoloc query response}
\usage{
parse_geoloc(x, crs = "+init=epsg:4326", capture = "none")
}
\arguments{
\item{x}{the \code{httr::content} of a response}

\item{crs}{character the desired proj4string}

\item{capture}{character vector of possibly ("bbox", "component").  If "none"
then capture neither 'bbox' nor 'component'}
}
\value{
a sf dataframe
}
\description{
Components are difficult to handle as they change form entity to entity.
You can see this variability in this query
  x <- query_geoloc("Sidney, NS", parse = FALSE)
}
