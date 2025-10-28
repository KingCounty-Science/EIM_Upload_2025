# EIM_Upload_2025
A project containing the scripts used to 1) fill  out the location template and 2) prepare data downloaded from PSSB (2015-2025) to be added to EIM

Helpful Quicklinks:
- PugetSound Stream Benthos: https://pugetsoundstreambenthos.org/
- WA Department of Ecology EIM Help Page: https://ecology.wa.gov/research-data/data-resources/environmental-information-management-database/eim-submit-data
- EIM Search : https://apps.ecology.wa.gov/eim/search/Eim/EIMSearch.aspx?SearchType=AllEIM&State=newsearch&Section=all

Directory:

R Code
- How to EIM (with R).Rmd: A comprehensive guide on how to complete EIM upload, including helpful snippets of R code from both R files
- EIM_Locations.R : R code used to fill out the location template (i.e., adding new sites to EIM) using a combination of data from PSSB and SiteMaster. Creates .csv output that wll still require some editing.
- EIM_Results.R: R code used to check for duplicate entries of data for a given sample, based on taxa and lifestage. Duplcates are written out to a .csv for manual review. For 2025, we ended up cmombining the counts for our duplicate data.

2025 data files - all in the folder DataInputs:

-Date_Fix_pt1.csv and Date_Fix_pt2.csv : Data downloaded from PSSB to fix dates within the bug data (likely not needed next time)
-EIMLocationDetails_2021Aug12_149.csv : List of locations downloaded from EIM
- PSSB_LocationInfo.csv : Download from PSSB that had location information for each site (like the WRIA, subbasin, etc.). 
- PSSBDownload_2015-2025.csv: Our "bug data" from 2015-2025 to be uploaded to EIM. Was manually reformatted to meet EIM standards.
- Replacement_Values.csv : a .csv of values to replace within the results data
- SiteMaster_NewSites.csv : Downloaded from SiteMaster; list of sites
- Taxon.csv : List of accepted values for taxa from EIM Valid Values Lookup


2025 location templates - all in the folder Blank Templates:
- - EIMLocationTemplate.csv : Empty spreadsheet containing column headers for the 2025 location template. To be filled out using the EIM_Location_Template.R script.

images folder - just a folder for helpful screenshots :)
