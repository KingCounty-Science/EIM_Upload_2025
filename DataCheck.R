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

#Writing to a .csv
write.csv(filtered_df, file = "duplicates_PSSB2015-2025")
