#--------------------------------------
##Data Check
##Created by Anna Thario
##Updated 9/8/2025
#--------------------------------------

#clearing the environment
rm(list = ls())

#Installing packages
#install.packages("xlsx")

#Loading packages
library(tidyverse)
library(xlsx) ##getting error loading this on 6/8/26; not sure it's needed?

#Reading in our data
#data <-read.csv("DataInputs/PSSBDownload_2015-2025_updated2025_11_10.csv")
data <-read.csv("DataInputs/PSSBDownload_2015-2025_updated2026_06_08.csv") #for this file, KM manually combined the duplicate Orthocladiinae duplicates; in PSSB downloads, we see there are duplicate larval Orthocladiinae rows in 45 samples; this is because the lab is able to enter "characteristics" for taxa that we don't see; the lab considers these both unique taxa, but for upoloading to EIM, we combined these. This will result in a loss of 1 taxon per sample. We did this for EIM upload, but we should fix this in PSSB too, so that these have distinct names when we download taxa counts from PSSB. 

#Looking at the structure of our data
str(data)

#Subsetting data to only look at duplicates among site, taxon, and lifestage
data_sub <- data[,c("Sample_ID","Result_Taxon_Name","Result_Taxon_Life_Stage")]

#Which data entries are duplicates? *Only pulls out the second occurrence of the same data
dupes<-data_sub[which(duplicated(data_sub)),]

#asks how many unique sample IDs - (to help explain why there are an uneven number of dup pairs )
dupes |> select(Sample_ID) |> unique()|> count()

#filtering data in the big dataset that matches our duplicates
filtered_df <- semi_join(x = data, y = dupes) #KM - I'm not sure why the Result_Taxon_Name field dropped - I can see the counts in the filtered_df, but not the actual taxon name

#taking a quick look at which sites had more than a single duplicate pair - some of these are explained by life stage (larvae/pupae)
filtered_df |> group_by(Sample_ID) |> summarise(count = n()) |> filter(count > 2)

#Writing to a .csv to assess
write.csv(filtered_df, file = "duplicates_PSSB2015-2025.csv")

#-----------------------------------------------
###this upload, we decided that the duplicate values shouldn't impact the BIBI score.Thus, we decided to combine the counts for the duplicates. 

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
write_csv(final_df, file = "EIM_data_2015_2025.csv")

#-----------------------------------------------------
#Making changes according to EIM upload errors

#Reading in our data
EIMdata <- read.csv("EIM_data_2015_2025.csv")

#Looking at the data
str(EIMdata)

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
#For some reason, the dates are not correct, so they need to be changed
### but as of 6/8/2026, these files don't work to fix them. KM is not sure where Anna got the dates in "Date_Fox_pt1.csv file" etc.; KM downloaded data from sites from 2015-2024, created a concatenated column with site and date sampled in both sheets and then used vlookup to add released date into formatted datasheet


 # EIMdata<- EIMdata[, -39] #Removing the analysis date column

  #Data from PSSB to fix the lab analysis dates
#  date1 <- read.csv("DataInputs/Date_Fix_pt1.csv")
#  date1 <- date1[, c("Sample_ID", "Lab_Analysis_Date")] #I only need the dates
#  date2 <- read.csv("DataInputs/Date_Fix_pt2.csv")
# date2 <- date2[, c("Sample_ID", "Lab_Analysis_Date")]

#  dates <- distinct(rbind(date1, date2))

 # EIMdata <- left_join(x = EIMdata, y = dates, by = "Sample_ID")

#Checking that result taxon tsn align with accepted EIM values #with new taxon list, downloaded from EIM on 2025_11_06; this should have the taxa we asked them to add - and it does!!
taxon_20251106<-read.csv("DataInputs/Taxon_2025_11_06.csv")
tsn_diff <- setdiff(EIMdata$Result_Taxon_TSN, taxon_20251106$Taxonomic.Serial.Number..TSN.) # Are there TSN numbers in our EIMdata but not in the EIM taxon list?

diff_tsn_df <- EIMdata %>%
  filter(Result_Taxon_TSN %in% tsn_diff)

diff_tsn_df |> select(Result_Taxon_TSN) |> group_by(Result_Taxon_TSN) |> summarise(TSNcount = n())

write.csv(diff_tsn_df, file = "diff_tsn_df_2025_11_06.csv")  


#Checking that result taxon name align with accepted EIM values
taxon_20251106 <- read.csv("DataInputs/Taxon_2025_11_06.csv")

taxon_name_diff <- setdiff(EIMdata$Result_Taxon_Name, taxon_20251106$Taxon.Name) #Are there Elements in EIMdata but not taxon

diff_name_df <- EIMdata %>%
  filter(Result_Taxon_Name %in% taxon_name_diff)

write.csv(diff_name_df, file = "diff_name_df_2025_11_06.csv")

#Result Taxon Unidentified Species
unique(EIMdata$Result_Taxon_Unidentified_Species)

#Result Taxon Life Stage
unique(EIMdata$Result_Taxon_Life_Stage)

#----------------------------------------------------------

#Replacing Incorrect taxon names
#replacement <- read.csv("DataInputs/Replacement_Values_updated2025_11_07.csv")
replacement <- read.csv("DataInputs/Replacement_Values_updated2025_11_10.csv")

#old code - works with "DataInputs/Replacement_Values_updated2025_11_07.csv"
#EIMdata_updated <- EIMdata %>%
#  left_join(replacement, by = c("Result_Taxon_TSN" = "Old_TSN", "Result_Taxon_Name" = "PSSB_Name")) %>%
#  mutate(
#    Result_Taxon_TSN = if_else(!is.na(TSN_for_EIM), TSN_for_EIM, Result_Taxon_TSN),
#    Result_Taxon_Name = if_else(!is.na(EIM_Name), EIM_Name, Result_Taxon_Name)
# ) %>%
#  select(-TSN_for_EIM, -EIM_Name)  # Removing extra columns

#updated code; works with "DataInputs/Replacement_Values_updated2025_11_10.csv"
EIMdata_updated <- EIMdata %>%
  left_join(replacement, by = c("Result_Taxon_TSN" = "PSSB_TSN", "Result_Taxon_Name" = "PSSB_Name")) %>%
  mutate(
    Result_Taxon_TSN = if_else(!is.na(EIM_TSN), EIM_TSN, Result_Taxon_TSN),
    Result_Taxon_Name = if_else(!is.na(EIM_Name), EIM_Name, Result_Taxon_Name)
  ) %>%
  select(-EIM_TSN, -EIM_Name)  # Removing extra columns

#Exporting
write.csv(EIMdata_updated, file = "EIMData_R_Edit_updated_2026_06_08.csv")

#KM then manually arranged columns to match template, checked for errors (e.g., NAs for # grids processed, etc.)