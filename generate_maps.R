
library(ggmap)
library(dplyr)
library(tidyr)
library(readr)
library(lubridate)

sf_crime <- read_csv("train.csv.gz")

sf_crime <- sf_crime %>% 
    mutate(month = month(Dates), year=year(Dates)) %>%
    filter( X < -122 ) %>%  # remove events too far east to be reasonable
    filter( Y < 37.8 )      # remove events too far north to be reasonable

left <- -122.52
bottom <- 37.70
right <- -122.35
top <- 37.82
location <-  c(left, bottom, right, top)

print("loading map")
sf_osm <- get_map(location = location, color = "bw", source = "osm")
print("map loaded")

categories <- c("ARSON", "ASSAULT", "BRIBERY", "BURGLARY", "DRIVING UNDER THE INFLUENCE", "DRUG/NARCOTIC", "EMBEZZLEMENT", "EXTORTION", "FRAUD", "GAMBLING", "LARCENY/THEFT", "PROSTITUTION", "ROBBERY", "SEX OFFENSES FORCIBLE", "SUICIDE", "VEHICLE THEFT")

SFMap <- ggmap(sf_osm)

for(cat in categories) {
    print(paste("Rendering",cat))
    nextmap <- SFMap + 
                    stat_density2d(
                        aes(x=X, y=Y, fill = ..level.., alpha=..level..), 
                        geom = "polygon", n=100, 
                        data = sf_crime %>% filter( Category == cat )
                    ) +
                    scale_fill_gradient(low = "yellow", high = "red") +
                    scale_alpha(range = c(0.25, 0.5), guide = FALSE) +
                    theme(legend.position = "right", axis.title = element_blank(), 
                          text = element_text(size = 8))
    filename <- paste0( gsub(" |/","",cat), ".jpeg")
    ggsave(filename = filename, plot = nextmap, width=4, height=4, units="in", dpi=200)
}

print("Finished Rendering")

