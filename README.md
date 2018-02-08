# geogratis

Query and retrieve data from [Natural Resources Canada](http://www.nrcan.gc.ca/earth-sciences/geography/topographic-information/free-data-geogratis/11042)

## Requirements

+ [R (>= 3.3.0)](https://www.r-project.org/)

+ [httr](https://CRAN.R-project.org/package=httr)

+ [curl](https://CRAN.R-project.org/package=curl)

+ [sf](https://CRAN.R-project.org/package=sf)

## Installation

```
devtools::install_github("BigelowLab/geogratis")
```

## geoloc - Geolocation Services

[Geolocation Service](http://geogratis.gc.ca/site/eng/geoloc)

```
library(geogratis)
library(sf)

# simplest query
x <- query_geoloc("Baleine Rd, Baleine, NS")
x
# Simple feature collection with 2 features and 3 fields
# geometry type:  POINT
# dimension:      XY
# bbox:           xmin: -59.84238 ymin: 45.96356 xmax: -59.83667 ymax: 45.97446
# epsg (SRID):    4326
# proj4string:    +proj=longlat +datum=WGS84 +no_defs
#                                                                title
# 1                             Baleine Road, Main-À-Dieu, Nova Scotia
# 2 Baleine Road,Louisbourg Main-A-Dieu Road, Main-À-Dieu, Nova Scotia
#               qualifier                                       type
# 1 INTERPOLATED_CENTROID       ca.gc.nrcan.geoloc.data.model.Street
# 2              LOCATION ca.gc.nrcan.geoloc.data.model.Intersection
#                         geom
# 1 POINT (-59.83667 45.96356)
# 2 POINT (-59.84238 45.97446)

# ask for score and components (streetname, placename, province )
x <- query_geoloc("Baleine Rd, Baleine, NS", expand = 'score,component')
x
# Simple feature collection with 2 features and 7 fields
# geometry type:  POINT
# dimension:      XY
# bbox:           xmin: -59.84238 ymin: 45.96356 xmax: -59.83667 ymax: 45.97446
# epsg (SRID):    4326
# proj4string:    +proj=longlat +datum=WGS84 +no_defs
#                                                                title
# 1                             Baleine Road, Main-À-Dieu, Nova Scotia
# 2 Baleine Road,Louisbourg Main-A-Dieu Road, Main-À-Dieu, Nova Scotia
#               qualifier                                       type    score
# 1 INTERPOLATED_CENTROID       ca.gc.nrcan.geoloc.data.model.Street 4.983900
# 2              LOCATION ca.gc.nrcan.geoloc.data.model.Intersection 1.285753
#                                 streetname   placename province
# 1                             Baleine Road Main-À-Dieu       NS
# 2 Baleine Road,Louisbourg Main-A-Dieu Road Main-À-Dieu       NS
#                         geom
# 1 POINT (-59.83667 45.96356)
# 2 POINT (-59.84238 45.97446)

```

