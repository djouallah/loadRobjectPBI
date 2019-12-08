# Input load. Please do not change #
`dataset` = read.csv('https://raw.githubusercontent.com/djouallah/loadRobjectPBI/master/powerbidf.csv', check.names = FALSE, encoding = "UTF-8", blank.lines.skip = FALSE);
# Original Script. Please update your script content here and once completed copy below section back to the original editing window #
library(sf)
library(tmap)

tempdf <-  dataset[dataset$Value!="",]
tempdf <-  tempdf[!is.na(dataset$Value),]
if (nrow(tempdf) == 0){
  #do nothing
}else{
  tempdf <- tempdf[c("Index","Value")]
  tempdf <-  tempdf[order(tempdf$Index),]
  tempdf <-  stack(setNames(strsplit(as.character(tempdf$Value),'@'), tempdf$Index))
  tempdf <- tempdf["values"]
  write.table(tempdf, file="test3.rds",row.names = FALSE,quote = FALSE,  col.names=FALSE)
  rm(tempdf)
  background <- readRDS('test3.rds', refhook = NULL)
  file.remove('test3.rds')}

dataset <-  dataset[!is.na(dataset$x),]
dataset <- dataset[c("x","y","color","status","labels")]
dataset$color <- as.character(dataset$color)

map <- st_as_sf(dataset,coords = c("x", "y"), crs = 4326)


chartlegend <-     unique(dataset[c("status","color")])

rm(dataset)

if (!exists("background")) {
  tm_shape(map) +
    tm_symbols(col = "color", size = 0.04,shape=19)+
    tm_text(text="labels",col="white")+
    rm(map)+
    tm_add_legend(type='fill',labels=chartlegend$status, col=chartlegend$color)+
    tm_legend(position=c("left", "top"),text.size = 1.3)+
    tm_layout(bg.color="lightblue",frame = TRUE,legend.width=2)+
    rm(chartlegend)}else {
      
      tm_shape(background)+
        tm_rgb() +
        rm(background)+
        tm_shape(map) +
        tm_symbols(col = "color", size = 0.04,shape=19)+
        tm_text(text="labels",col="white")+
        rm(map)+
        tm_add_legend(type='fill',labels=chartlegend$status, col=chartlegend$color)+
        tm_legend(position=c("left", "top"),text.size = 1.3)+
        tm_layout(frame = TRUE,legend.width=2)+
        rm(chartlegend)}