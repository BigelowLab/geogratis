#' Retrieve sf data frame from geoloc query response
#'
#' Components are difficult to handle as they change form entity to entity.
#' You can see this variability in this query
#'   x <- query_geoloc("Sidney, NS", parse = FALSE)
#'
#' @export
#' @param x the \code{httr::content} of a response
#' @param crs character the desired proj4string
#' @param capture character vector of possibly ("bbox", "component").  If "none"
#'   then capture neither 'bbox' nor 'component'
#' @return a sf dataframe
parse_geoloc <- function(x, crs = "+init=epsg:4326", capture = "none" ){

    # @param do_bbox logical if TRUE then extract bbox (if possible) as POLYGON
    parse_one <- function(x, capture = 'none'){
        x$geom <- sf::st_sfc(
            sf::st_point(
                c( x$geometry$coordinates[[1]], x$geometry$coordinates[[2]] )),
                crs = crs )
        x$geometry <- NULL
        if (all(c('bbox' %in% capture , 'bbox' %in% names(x))) ){
            p = unlist(x$bbox)
            x$bbox <- sf::st_sfc(
                sf::st_polygon(
                    x = list(cbind(
                        c(p[1],p[1], p[3], p[3], p[1]),
                        c(p[2],p[4], p[4], p[2], p[2])) ),
                    dim = "XY"),
                crs = crs )
        } else {
            x$bbox <- NULL
        }
        if (all(c('component' %in% capture , 'component' %in% names(x))) ) {
            for (n in names(x$component)) x[[n]] <- x$component[[n]]
            x$component <- NULL
        } else {
            x$component <- NULL
        }
        x <- sf::st_sf(x, sf_column_name = 'geom', stringsAsFactors = FALSE)
        x
    }
    do.call(rbind, lapply(x, parse_one, capture = capture))
}


#' Query the Geolocation Service
#'
#' @seealso \url{http://geogratis.gc.ca/site/eng/geoloc}
#' @export
#' @param query character vector of one or more locations to query
#' @param expand character vector or NULL to retrieve additional bits of info per object.
#'   By default NULL, but allowed is \code{'score,component'} or one or the other
#' @param callback NULL see \url{http://geogratis.gc.ca/site/eng/geoloc}
#' @param verb character the resource to query, by default 'locate'
#' @param parse logical if TRUE then try to parse to sf dataframe
#' @param baseuri character the resource uri without the verb
#' @param ... further arguments for \code{parse_geoloc()}
#' @examples
#' \dontrun{
#'    # query one of the prettiest places on the planet
#'    x <- query_geoloc("Baleine Rd, Baleine, NS")
#' }
query_geoloc<- function(
    query       = "Baleine Rd, Baleine, NS",
    expand      = NULL,
    callback    = NULL,
    verb        = c("locate", "suggest", "autocomplete")[1],
    baseuri     = 'http://geogratis.gc.ca/services/geolocation/en',
    parse       = TRUE,
    ...){

    uri <- sprintf("%s?q=%s", file.path(baseuri, tolower(verb[1])),
        curl::curl_escape(query[1]))

    if (!is.null(expand[1]))
        uri <- sprintf("%s&expand=%s", uri, curl::curl_escape(expand[1]))

    if (!is.null(callback[1]))
        uri <- sprintf("%s&callback=%s", uri, callback[1])

    x <- httr::GET(uri)

    if (x$status_code != 200) {
        httr::warn_for_status(x)
        x <- list()
    }

    if (parse && (length(x) > 0)) x <- parse_geoloc(httr::content(x),...)
    x
}
