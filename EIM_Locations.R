##EIM Data Upload 2025
##Code by Anna Thario
##Last Updated: 8/12/2025

#Install Packages
install.packages("tidyr")

#Load in packages
library(tidyr)
library(dplyr)

#####Updating EIM with newly added study locations (LOCATIONS TEMPLATE)####

#Loading in our csvs

#Data from PSSB added since last EIM upload
PSSB <- read.csv("DataInputs/PSSBDownload_2015-2025.csv") 
  #Just checking the column headers
  head(PSSB)

##Just the location information already in EIM
EIM_2014 <- read.csv("DataInputs/EIMLocationDetails_2025Aug12_149.csv") 
  #Just checking the column headers
  head(EIM_2014)

#Assigning the locations to a variable for each dataset
PSSB_Locations <- PSSB$Study_Specific_Location_ID
  PSSB_Locations <- unique(PSSB_Locations) #Filtering out the list to get only one entry of each site location

EIM_Locations <- unique(EIM_2014$Location_ID)

#Seeing what locations are in the PSSB data (list a) but not in the EIM data (list b)
#This list of should be used to fill out a location form, telling EIM what sites we've added since last upload
added_locations <-setdiff(PSSB_Locations,EIM_Locations)

#Loading in our location template
location_template <- read.csv("BlankTemplates/EIMLocationTemplate.csv")
  #Just checking the column headers
  head(location_template)
  #Adding in rows of NA values to dataset the length of the number of new sites
  #This will allow us to add in data to each column from various sources
  location_template[1:length(added_locations),] <- ""

  #Let's fill out the template!
  
  #Adding in the location_ids
  location_template$Location_ID <- added_locations
  
    #Removing incorrect data entry
    location_template <- location_template[-41,]
  
  #Adding in the location setting
  location_template$Location_Setting <-"Stream/River-Riffle"

  #Is location a well
  location_template$Is_Location_A_Well <-"N"
  
  #State
  location_template$State <- "WA"
  
  #Coordinate System
  location_template$Coordinate_System <- "LAT/LONG"
  
  #Horizontal Coordinates Represent
  location_template$Horizontal_Coordinates_Represent <- 26 #26 for a Stream/Segment according to EIM Help Document
  
  #Horizontal Datum
  location_template$Horizontal_Datum <- 3 #3 for NAD 1983 HARN according to EIM Help Document
  
  #Horizontal Coordinate Accuracy
  location_template$Horizontal_Coordinate_Accuracy <- 5 #Estimate based on iPhone 14 GPS accuracy, +- 20 ft
  
  #Horizontal Coordinate Collection Method
  location_template$Horizontal_Coordinate_Collection_Method <- 16 #Based on EIM guidebook, "consumer unit"
  
  #Loading in other information from PSSB and Site Master
  PSSB_loc2 <- read.csv("DataInputs/PSSB_LocationInfo.csv")
  SiteMaster <- read.csv("DataInputs/SiteMaster_NewSites.csv")
  
  #Merging our PSSB and SiteMaster location information together into one dataframe
  PSSB_loc2 <-rename(PSSB_loc2, Location_ID = Site.Code)
  SiteMaster <-rename(SiteMaster, Location_ID = Site.Name)
  location_template <- merge.data.frame(location_template, PSSB_loc2, by = "Location_ID", all.x = TRUE)
  location_template <- merge.data.frame(location_template, SiteMaster, by = "Location_ID", all.x = TRUE)
  
  #Copying over data from the added columns to the template columns (since they should now be in the same order)
  location_template$Location_Name <- location_template$Stream.or.River
  location_template$Location_Description <- location_template$Navigate.to
  location_template$Latitude_Decimal_Degrees <- location_template$Lat
  location_template$Longitude_Decimal_Degrees <- location_template$Long
  
  #Deleting superfluous columns
  location_template <- location_template[,-(66:115)]
  
  #Exporting as a .csv
  write.csv(location_template, "locationtemplate_v1.csv")
  
  
  
  