# Input load. Please do not change #
`dataset` = read.csv('sa.csv', check.names = FALSE, encoding = "UTF-8", blank.lines.skip = FALSE);
# Original Script. Please update your script content here and once completed copy below section back to the original editing window #
library(sf)
library(ceramic)
library(raster)
Sys.setenv(MAPBOX_API_KEY = "write your token here")
map <- st_as_sf(dataset, coords = c("x", "y"), crs = 4326)
background <- cc_location(map)

saveRDS(background,'raster.rds',ascii = TRUE,compress = FALSE,version=2)


# just check it works

background <- readRDS('raster.rds', refhook = NULL)
plotRGB(background)