#--------------------------------------
##Data Check
##Created by Anna Thario
##Updated 9/8/2025
#--------------------------------------

#clearing the environment
rm(list = ls())

#Installing packages
install.packages("xlsx")

#Loading packages
library(tidyverse)
library(xlsx)

#Reading in our data
data <-read.csv("DataInputs/PSSBDownload_2015-2025.csv")

#Looking at the structure of our data
str(data)

#Subsetting data to only look at duplicates among site, taxon, and lifestage
data_sub <- data[,c("Sample_ID","Result_Taxon_Name","Result_Taxon_Life_Stage")]

#Which data entries are duplicates? *Only pulls out the second occurrence of the same data
dupes<-data_sub[which(duplicated(data_sub)),]

#filtering data in the big dataset that matches our duplicates
filtered_df <- semi_join(x = data, y = dupes)

#Writing to a .csv to assess
write.csv(filtered_df, file = "duplicates_PSSB2015-2025.csv")

#-----------------------------------------------
#For 2025, we decided that the duplicate values shouldn't impact the BIBI score.Thus, we decided to combine the counts for the duplicates. 

#Combining the counts of all entries based on the same criteria we used to determine the duplicates

#Pulling out all of the info associated with each unique combo of sample id, life stage, and taxa (except for the counts!)
metadata <- data %>%
  distinct(Sample_ID, Result_Taxon_Name, Result_Taxon_Life_Stage, .keep_all = TRUE) %>%
  select(-Result_Value)

#Adding together the counts for all entries with the same unique combo, then joining the other columns back in
newcounts <- summarize(
  data,
  Result_Value = sum(Result_Value),
  .by = c(Sample_ID, Result_Taxon_Name, Result_Taxon_Life_Stage)
) %>%
  left_join(metadata, by = c("Sample_ID", "Result_Taxon_Name", "Result_Taxon_Life_Stage"))

#Removing duplicates based on the previous criteria, keeping all of the columns
#Not necessary, but a good final check
final_df <- distinct(newcounts, Sample_ID, Result_Taxon_Name, Result_Taxon_Life_Stage, .keep_all = TRUE)

#Saving data to new .csv
write.csv(final_df, file = "EIM_data_2015-2025.csv")

#-----------------------------------------------------
#Making changes according to EIM upload errors

#Reading in our data
EIMdata <- read.csv("DataInputs/EIM_data_2015-2025.csv")

#Looking at the data
str(EIMdata)

#Removing extra column
EIMdata <- EIMdata[,-1]

#Replacing NA values with ""
EIMdata[is.na(EIMdata)] <- ""

#Making variables numeric
EIMdata$Result_Reporting_Limit <- as.numeric(EIMdata$Result_Reporting_Limit)
EIMdata$Result_Detection_Limit <- as.numeric(EIMdata$Result_Detection_Limit)

#Making dates in the right format
EIMdata$Field_Collection_Start_Date <- mdy(EIMdata$Field_Collection_Start_Date)
EIMdata$Field_Collection_Start_Date <- format(EIMdata$Field_Collection_Start_Date, "%m-%d-%Y")

#Checking the Lab Analysis Date
unique(EIMdata$Lab_Analysis_Date)
#For some reason, the dates are not correct, so I need to change them

  EIMdata<- EIMdata[, -39] #Removing the analysis date column

  #Data from PSSB to fix the lab analysis dates
  date1 <- read.csv("DataInputs/Date_Fix_pt1.csv")
  date1 <- date1[, c("Sample_ID", "Lab_Analysis_Date")] #I only need the dates
  date2 <- read.csv("DataInputs/Date_Fix_pt2.csv")
  date2 <- date2[, c("Sample_ID", "Lab_Analysis_Date")]

  dates <- distinct(rbind(date1, date2))

  EIMdata <- left_join(x = EIMdata, y = dates, by = "Sample_ID")

#Checking that result taxon tsn align with accepted EIM values
taxon <- read.csv("DataInputs/Taxon.csv")

tsn_diff <- setdiff(EIMdata$Result_Taxon_TSN, taxon$Taxonomic.Serial.Number..TSN.) # Are there Elements in EIMdata but not taxon

diff_tsn_df <- EIMdata %>%
  filter(Result_Taxon_TSN %in% tsn_diff)

write.csv(diff_tsn_df, file = "diff_tsn_df.csv")
  
#Checking that result taxon name align with accepted EIM values
taxon <- read.csv("DataInputs/Taxon.csv")

taxon_name_diff <- setdiff(EIMdata$Result_Taxon_Name, taxon$Taxon.Name) #Are there Elements in EIMdata but not taxon

diff_name_df <- EIMdata %>%
                  filter(Result_Taxon_Name %in% taxon_name_diff)
  
write.csv(diff_name_df, file = "diff_name_df.csv")





#Result Taxon Unidentified Species
unique(EIMdata$Result_Taxon_Unidentified_Species)

#Result Taxon Life Stage
unique(EIMdata$Result_Taxon_Life_Stage)

#----------------------------------------------------------

#Replacing Incorrect Values
replacement <- read.csv("DataInputs/Replacement_Values.csv")

EIMdata_updated <- EIMdata %>%
  left_join(replacement, by = c("Result_Taxon_TSN" = "Old_TSN", "Result_Taxon_Name" = "Old_Name")) %>%
  mutate(
    Result_Taxon_TSN = if_else(!is.na(New_TSN), New_TSN, Result_Taxon_TSN),
    Result_Taxon_Name = if_else(!is.na(New_Name), New_Name, Result_Taxon_Name)
  ) %>%
  select(-New_TSN, -New_Name)  # Removing extra columns

#Exporting
write.csv(EIMdata_updated, file = "EIMData_R_Edit.csv")
