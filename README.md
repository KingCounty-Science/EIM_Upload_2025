# EIM_Upload_2025
A project containing the scripts used to 1) fill  out the location template and 2) prepare data downloaded from PSSB (2015-2025) to be added to EIM

Helpful Quicklinks:
- PugetSound Stream Benthos: https://pugetsoundstreambenthos.org/
- WA Department of Ecology EIM Help Page: https://ecology.wa.gov/research-data/data-resources/environmental-information-management-database/eim-submit-data
- EIM Search : https://apps.ecology.wa.gov/eim/search/Eim/EIMSearch.aspx?SearchType=AllEIM&State=newsearch&Section=all

Directory:

R Code
- EIM_Location_Template.R : R code used to fill out the location template (i.e., adding new sites to EIM) using a combination of data from PSSB and SiteMaster. Creates .csv output that wll still require some editing. (https://github.com/AnnaThario/EIM_Upload_2025/blob/c601913492e42896004050881b40d8d1a361b85a/EIM_Location_Template.R)
- DataCheck.R: R code used to check for duplicate entries of data for a given sample, based on taxa and lifestage. Duplcates are written out to a .csv for manual review. For 2025, we ended up cmombining the counts for our duplicate data. (https://github.com/AnnaThario/EIM_Upload_2025/blob/c601913492e42896004050881b40d8d1a361b85a/EIM_Location_Template.R)

2025 data files
- EIMLocationTemplate.csv : Empty spreadsheet containing column headers for the 2025 location template. To be filled out using the EIM_Location_Template.R script.(https://github.com/AnnaThario/EIM_Upload_2025/blob/c601913492e42896004050881b40d8d1a361b85a/EIMLocationTemplate.csv)
- PSSBDownload_2015-2025.csv & PSSBDownload_Vashon_2015-2025.csv : Our "bug data" from 2015-2025 to be uploaded to EIM. Was manually reformatted to meet EIM standards. (https://github.com/AnnaThario/EIM_Upload_2025/blob/c601913492e42896004050881b40d8d1a361b85a/PSSBDownload_2015-2025.csv) (https://github.com/AnnaThario/EIM_Upload_2025/blob/c601913492e42896004050881b40d8d1a361b85a/PSSBDownload_Vashon_2015-2024.csv)
- PSSB_LocationInfo.csv : Download from PSSB that had location information for each site (like the WRIA, subbasin, etc.). (https://github.com/AnnaThario/EIM_Upload_2025/blob/c601913492e42896004050881b40d8d1a361b85a/PSSB_LocationInfo.csv)
- duplicates_PSSB2015-2025 : Output .csv from DataCheck.R containing duplicate site entries based on taxa and lifestage. (https://github.com/AnnaThario/EIM_Upload_2025/blob/c601913492e42896004050881b40d8d1a361b85a/duplicates_PSSB2015-2025.csv)
- locationtemplate.xlsx : A manually reviewed and edited version of the output file from EIM_Location_Template.R. Contains all of the new sites to be added in the 2025 PSSB upload. (https://github.com/AnnaThario/EIM_Upload_2025/blob/c601913492e42896004050881b40d8d1a361b85a/locationtemplate.xlsx)
