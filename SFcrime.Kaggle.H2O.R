# SF Crime Kaggle - H2O
library(dplyr)
library(lubridate)
library(readr)

train <- read_csv("train.csv.zip")

# Data cleaning step
train.final <- train %>%
    filter( X < -122 ) %>%  # remove events too far east to be reasonable
    filter( Y < 37.8 ) %>%  # remove events too far north to be reasonable
    mutate( Lon = round(X,3), Lat = round(Y,3) ) %>% # rename X and Y to Longitude and Latitude
    mutate( HourBin = cut(hour(Dates), 
                          breaks=c(-1,5,11,17,23), 
                          labels=c('LateNight','Morning','Afternoon','Evening')) ) %>%
    mutate( Month = month(Dates) ) %>%
    mutate( TrainWeights = year(Dates) - min( year(Dates) ) + 1 ) %>% # Weight more recent years more
    select( -X, -Y, -Address, -Descript, -Resolution, -Dates, -PdDistrict )

train.final$Category <- as.factor(train.final$Category)
train.final$DayOfWeek <- as.factor(train.final$DayOfWeek)

# Generate cartesian product of predictors
targets <- expand.grid( Lon = unique(train.final$Lon),
                  Lat = unique(train.final$Lat),
                  HourBin = unique(train.final$HourBin),
                  DayOfWeek = unique(train.final$DayOfWeek),
                  Month = unique(train.final$Month) )

# Create no crime category for all locations where crime has happened
# all.latlonpairs <- unique( data.frame( Lon=targets$Lon, Lat=targets$Lat ) )
# train.latlonpairs <- unique( data.frame( Lon=train.final$Lon, Lat=train.final$Lat ) )
# nocrime.latlonpairs <- dplyr::setdiff( all.latlonpairs, train.latlonpairs )
# nocrime.text <- paste(nocrime.latlonpairs$Lon, nocrime.latlonpairs$Lat)
# nocrime.train <- expand.grid(Location=nocrime.text,
 #                            HourBin = unique(train.final$HourBin),
 #                            DayOfWeek = unique(train.final$DayOfWeek),
 #                            Month = unique(train.final$Month),
 #                            Category = "None")

library(h2o)
h2o.init(nthreads = -1)

h2o.train <- as.h2o(train.final)
h2o.targets <- as.h2o(targets)
y <- "Category"
x <- c("Lon", "Lat", "HourBin", "DayOfWeek", "Month")

rf.model <- h2o.randomForest(x=x, y=y, weights_column = "TrainWeights",
                             training_frame = h2o.train)

# make predictions
predictions <- h2o.predict(rf.model, h2o.targets)

# added back to original frame
preds.with.targets <- h2o.cbind(predictions,h2o.targets)

# prep data for writing out
h2o.exportFile(preds.with.targets, paste(getwd(), "sfcrimepreds.csv", sep = "/"), force = TRUE)

