library(shiny)
library(leaflet)
library(shinythemes)

categories <- c("ARSON", "ASSAULT", "BRIBERY", "BURGLARY", "DRIVING UNDER THE INFLUENCE", "DRUG/NARCOTIC", "EMBEZZLEMENT", "EXTORTION", "FRAUD", "GAMBLING", "LARCENY/THEFT", "PROSTITUTION", "ROBBERY", "SEX OFFENSES FORCIBLE", "SUICIDE", "VEHICLE THEFT")

shinyUI(
    navbarPage(theme = shinytheme("spacelab"),
        "SF Crime Predictor",
               tabPanel("Summary", 
                        fluidPage(
                            titlePanel(
                                h3("SF Crime Predictor App")
                            ),
                            navlistPanel(
                                "Summary",
                                tabPanel("Using the App",
                                         h2("Using the SF Crime Predictor App"),
                                         br(),
                                         br(),
                                         p("Click on the Predictions or Crime Density tab to begin using the app."),
                                         p("The maps may take a moment to load."),
                                         br(),
                                         p("For the ",strong("Crime Prediction map"),", click on the map of San Francisco to make a prediction for the top 5 crimes and their probabilities 
                                            for that location. The inputs for month, day and time 
                                            of day can be varied individually to view the crime predictions and probabilities for each selection. 
                                            The Predictions map can be zoomed in or out, but a selection must be made within San Francisco or no prediction will be made."),
                                         br(),
                                         p("For the ", strong("Crime Density map"), ", select the crime category to view the density map for each crime type."),
                                         br(),
                                         br(),
                                         p("Code available at ",
                                           a("Github. ",
                                             href = "https://github.com/StephRoark/SFCrime-Predictor"))
                                         ),
                                tabPanel("Predictions",
                                         h2("Crime Predictions Map"),
                                         br(), 
                                         br(), 
                                         p("The Crime Predictions App displays an interactive map of San Francisco which features crime predictions based on 
                                            location, month, day of week and time of day. By clicking on the map and selecting other inputs, the app makes a 
                                            prediction for the top 5 crimes that occur at that specific location. The predictions are made using H2O.ai's 
                                            predictive modeling software with location, month, day of week and time of day as predictors. The user can 
                                            select the inputs and vary them independently to make new crime predictions for that location. 
                                            This app could potentially be used for making predictions when a 911 call comes in without additional information. 
                                            Other possible uses are for renters considering where to live and tourists wanting to have a safe visit. ")
                                ),
                                tabPanel("Crime Density",
                                         h2("Crime Density Maps"),
                                         br(),
                                         br(),
                                         p("The SF Crime App displays a map of San Francisco with a crime density plot overalyed. 
                                            The app allows the user to choose a crime category and then displays the density of that 
                                            crime over a map of San Francisco. 
                                            The darker color indicates a higher concentration of the specific crime in that location.
                                            These maps could potentially be used by tourists for for a safe visit to SF, 
                                           by renters considering where to live or by a neighborhood watch organization wanting to be 
                                           informed of the likelihood of a particular crime occuring near their homes.")
                                ),
                                tabPanel("Future Features",
                                         h2("Possible Future Features"),
                                         br(),
                                         br(),
                                         p("Furture features include predictions for crime based on weather data, presence of homeless population, PD District and income level.")
                                )
                            )
                            
                        )),
                 tabPanel("Predictions", 
                          sidebarLayout(
                              sidebarPanel(
                                  h6("Click on the map to make a prediction."),
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
                 tabPanel("Crime Density", 
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


