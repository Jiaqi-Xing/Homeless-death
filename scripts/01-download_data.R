#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto
# Author: Ariel Xing
# Date: 24 September 2024
# Contact: ariel.xing@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None.


#### Workspace setup ####
library(opendatatoronto)
library(dplyr)

# get package
package <- show_package("a7ae08f3-c512-4a88-bb3c-ab40eca50c5e")
package

# get all resources for this package
resources <- list_package_resources("a7ae08f3-c512-4a88-bb3c-ab40eca50c5e")

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# load the datastore resource
data_1 <- filter(datastore_resources, row_number()==2) %>% get_resource()
data_1
data_2 <- filter(datastore_resources, row_number()==4) %>% get_resource()
data_2
data_3 <- filter(datastore_resources, row_number()==6) %>% get_resource()
data_3

#### Save data ####

write_csv(data_1, file = "~/sta304/starter_folder-main/data/raw_data/raw_data(death by month).csv") 
write_csv(data_2, file = "~/sta304/starter_folder-main/data/raw_data/raw_data(death by cause).csv") 
write_csv(data_3, file = "~/sta304/starter_folder-main/data/raw_data/raw_data(death by demographics).csv") 

         
