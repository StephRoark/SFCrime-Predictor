
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

left <- -122.50
bottom <- 37.72
right <- -122.37
top <- 37.80
location <-  c(left, bottom, right, top)

shinyServer(function(input, output, session) {
    
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
