#library(here)
library(burro)
library(dplyr)

setwd("c:/Code/clinical_data_wrangling/")

#load the data in and assign it to an object called sleep_data
sleep_data <- readRDS("data/common_data_small.rds")
#similarly, read the data dictionary in
data_dictionary <- read.csv("data/shhs-data-dictionary-0.13.1-variables.csv")

burro::explore_data(dataset= sleep_data, 
                    outcome_var = "any_cvd", 
                    data_dictionary = data_dictionary)