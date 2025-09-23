#--------------------------------------
##Data Check
##Created by Anna Thario
##Updated 9/8/2025
#--------------------------------------

#clearing the environment
rm(list = ls())

#Loading packages
library(tidyverse)

#Reading in our data
data <-read.csv("PSSBDownload_2015-2025.csv")

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

#Pulling out all of the info associated with each unique combo of sample id, life stage, and taxa
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
