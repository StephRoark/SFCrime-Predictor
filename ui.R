library(shiny)
library(leaflet)

categories <- c("ARSON", "ASSAULT", "BRIBERY", "BURGLARY", "DRIVING UNDER THE INFLUENCE", "DRUG/NARCOTIC", "EMBEZZLEMENT", "EXTORTION", "FRAUD", "GAMBLING", "LARCENY/THEFT", "PROSTITUTION", "ROBBERY", "SEX OFFENSES FORCIBLE", "SUICIDE", "VEHICLE THEFT")

shinyUI(
    navbarPage("SF Crime Predictor",
               tabPanel("Summary", 
                        fluidPage(
                            titlePanel(
                                h2("SF Crime Predictor App")
                            ),
                            sidebarLayout(
                                sidebarPanel( "Summary"),
                                mainPanel("main panel")
                            )
                        )),
                 tabPanel("Predictions", 
                          sidebarLayout(
                              sidebarPanel(
                                  selectInput("month", label = h4("Select Month"), 
                                              choices = list("January" = 1, "February" = 2, "March" = 3, 
                                                             "April" = 4, "May" = 5, "June" = 6, "July" = 7, 
                                                             "August" = 8, "September" = 9, "October" = 10, 
                                                             "November" = 11, "December" = 12), 
                                              selected = 1),
                                  selectInput("day", label = h4("Select Day of Week"), 
                                              choices = list("Monday", "Tuesday", "Wednesday", 
                                                             "Thursday", "Friday", "Saturday", 
                                                             "Sunday"), 
                                              selected = 1),
                                  radioButtons("time", label = h4("Time of Day"), 
                                                     choices = list("Morning (6 am-noon)" = 1, 
                                                                    "Afternoon (noon-6 pm)" = 2, 
                                                                    "Evening (6 pm-midnight)" = 3, 
                                                                    "Late Night (midnight-6am)" = 4),
                                                     selected = 1),
                                  tableOutput("Predictions")
                                  
                              ),
                              mainPanel(
                                  h2("Predicting Crime in San Francisco", align = "center"),
                                  leafletOutput("map1")
                              )   )
                 ), 
                 tabPanel("Crime Heatmaps", 
                          sidebarLayout(
                              sidebarPanel(
                                  helpText("Choose a crime category to explore the maps."),
                                  
                                  radioButtons("radio", label = h3("Crime Category"),
                                               choices = categories,
                                               selected = categories[1])
                              ),
                              mainPanel(
                                  h2("Mapping Crime Locations in San Francisco", align = "center"),  
                                  div(imageOutput("SFMap"), style="text-align: center;")
                              ) 
                            )
                          )
    )
)


