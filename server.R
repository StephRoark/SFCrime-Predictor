
library(shiny)
library(readr)
library(dplyr)
library(tidyr)
library(leaflet)

left <- -122.50
bottom <- 37.72
right <- -122.37
top <- 37.80
location <-  c(left, bottom, right, top)

timeBins <- c("Morning", "Afternoon", "Evening", "LateNight")

sf_crime_preds <- read_csv("sfcrimepreds.csv.gz",progress=TRUE)

shinyServer(function(input, output, session) {
    
    output$Predictions <- renderTable({
        timeBin <- timeBins[as.numeric(input$time)]
        if( !is.null(input$map1_click$lng) ) {
            result <- sf_crime_preds %>% 
                filter(Lon==round(input$map1_click$lng,3),
                       Lat==round(input$map1_click$lat,3),
                       HourBin==timeBin,
                       DayOfWeek==input$day,
                       Month==as.numeric(input$month)) %>%
                select(-Lon, -Lat, -HourBin, -DayOfWeek, -Month) %>% 
                gather(key="Crime Type", value="Probability") %>% 
                top_n(5, Probability) %>% 
                arrange(desc(Probability))
            return(result)
        }
    })
    
    
    output$SFMap <- renderImage({
        filename <- normalizePath(file.path('.',
                                            paste0( gsub(" |/","",input$radio), ".jpeg")))
        list(src = filename,
             contentType = 'image/jpg',
             width = 600,
             height = 600)
    }, deleteFile = FALSE)

    output$map1 <- renderLeaflet({
        leaflet() %>%
            addTiles() %>%  # Add default OpenStreetMap map tiles
            fitBounds(left, bottom, right, top)
    })
    
    observeEvent(input$map1_click, {
        content <- paste("Lat:",round(input$map1_click$lat,3),
                         "<br>Lon:",round(input$map1_click$lng,3))
        
        leafletProxy("map1", session) %>%
            clearPopups() %>%
            addPopups( lng=input$map1_click$lng,
                       lat=input$map1_click$lat,
                       popup=content,
                       options = popupOptions(closeButton = TRUE)
            )
    })
    

})
