# Input load. Please do not change #
`dataset` = read.csv('https://raw.githubusercontent.com/djouallah/loadRobjectPBI/master/powerbidf.csv', check.names = FALSE, encoding = "UTF-8", blank.lines.skip = FALSE);
# Original Script. Please update your script content here and once completed copy below section back to the original editing window #
library(sf)
library(dplyr)
library(tmap)
library(tidyr)

tempdf <- dataset %>%
  filter(!is.na(Value))%>%
  dplyr::select(Index,Value)%>%
  arrange(Index)%>%
  mutate(Value = strsplit(as.character(Value), "@")) %>%
  unnest(Value)%>%
  dplyr::select(Value)

  
write.table(tempdf, file="test3.rds",row.names = FALSE,quote = FALSE,  col.names=FALSE)
rm(tempdf)
background <- readRDS('test3.rds', refhook = NULL)

dataset <- dataset[c("x","y","color","status","labels")]
dataset$color <- as.character(dataset$color)
dataset$labels <- as.character(dataset$labels)

map <- st_as_sf(dataset,coords = c("x", "y"), crs = 4326)

chartlegend <- dataset %>%
   dplyr::select(status,color)%>%
   distinct(status, color)%>%
   arrange(status)
 
rm(dataset)

tm_shape(background)+
           tm_rgb() +
           rm(background)+
           tm_shape(map) +
           tm_symbols(col = "color", size = 0.04,shape=19)+
           tm_shape(filter(map, !is.na(labels))) +
           tm_text(text="labels",col="white")+
           rm(map)+
           tm_add_legend(type='fill',labels=chartlegend$status, col=chartlegend$color)+
           tm_layout(frame = FALSE,bg.color = "transparent",legend.width=2)+
           tm_legend(position=c("left", "top"),text.size = 1.3)+
           rm(chartlegend)

