## FTICR-MS WORKFLOW
## USE THIS SCRIPT TO PROCESS FTICR-MS DATA

##############################
##############################

## SOURCE THE FUNCTION FILES FIRST, AND THEN RUN THE SCRIPT
## DON'T RUN THE PROCESSING SCRIPT MULTIPLE TIMES. ONCE IS ENOUGH.
## -KFP/ 2022

##############################
##############################


# 1. SET input file paths -------------------------------
#This code is set up to process two sets of 
#For non polar data (Must be COREKEY because that is called directly from the functions)
COREKEY_nonpolar = "data/fticr/Field_NonPolar_Fdata.csv"
REPORT_nonpolar = "data/fticr/xtra_Report_15T_FieldSite_Lower_non-polar_Consolidated.csv"

#FOR POLAR DATA
COREKEY_polar = "data/fticr/Field_Polar_Fdata.csv"
REPORT_polar = "data/fticr/xtra_Report_15T_FieldSite_Upper_Polar_Consolidated.csv"
## SET the treatment variables
## this will work with multiple variables too. just add all the variable names in the parentheses.
TREATMENTS = dplyr::quos(Site, Year, Season)

#
# 2. load packages and source the functions --------------------------------------------------------
source("code/0-packages.R")
source("code/fticrrr/a-functions_processing.R")


#
# 3. import files needed --------------------------------------------------
## import the FTICR report and the corekey/sample info

report_polar = read.csv(REPORT_polar)
corekey_polar = read.csv(COREKEY_polar)

report_nonpolar = read.csv(REPORT_nonpolar)
corekey_nonpolar = read.csv(COREKEY_nonpolar)

#
# 4. process the data -----------------------------------------------------

## process and create eMeta file
## this file contains Metadata for each m/z peak

fticr_meta_polar = make_fticr_meta(report_polar)$meta2

fticr_meta_nonpolar = make_fticr_meta(report_nonpolar)$meta2

## process and create the longform Data file

# *_longform: molecules on a presence/absence bases, including all reps analyzed
# use *_longform file for statistical analyses, relative abundances

corekey_polar <- read.csv(COREKEY_polar)
fticr_data_longform_polar = make_fticr_data(report_polar, corekey_polar, TREATMENTS)$data_long_key_repfiltered %>% 
  mutate(Polar = "polar")

corekey_nonpolar <- read.csv(COREKEY_nonpolar)
fticr_data_longform_nonpolar = make_fticr_data(report_nonpolar, corekey_nonpolar, TREATMENTS)$data_long_key_repfiltered %>% 
  mutate(Polar = "nonpolar")

# *_trt: summary of the longform file, by treatment. replicates are removed
# use *_trt file for Van Krevelen graphs
fticr_data_trt_polar = make_fticr_data(report_polar, corekey_polar, TREATMENTS)$data_long_trt %>% 
  mutate(Polar = "polar")

fticr_data_trt_nonpolar = make_fticr_data(report_nonpolar, corekey_nonpolar, TREATMENTS)$data_long_trt %>% 
  mutate(Polar = "nonpolar")
#


#
# 4b. combine polar and nonpolar ------------------------------------------
fticr_meta_combined = 
  rbind(fticr_meta_polar, fticr_meta_nonpolar) %>% 
  distinct()

fticr_data_longform_combined = 
  rbind(fticr_data_longform_polar, fticr_data_longform_nonpolar)

fticr_data_trt_combined = 
  rbind(fticr_data_trt_polar, fticr_data_trt_nonpolar)

#
# 5. export processed data ------------------------------------------------
fticr_meta_polar %>% write.csv("data/processed/fticr_polar_meta.csv", row.names = FALSE)
fticr_data_longform_polar %>% write.csv("data/processed/fticr_polar_data_longform.csv", row.names = FALSE)
fticr_data_trt_polar %>% write.csv("data/processed/fticr_polar_trt.csv", row.names = FALSE)

fticr_meta_nonpolar %>% write.csv("data/processed/fticr_nonpolar_meta.csv", row.names = FALSE)
fticr_data_longform_nonpolar %>% write.csv("data/processed/fticr_nonpolar_data_longform.csv", row.names = FALSE)
fticr_data_trt_nonpolar %>% write.csv("data/processed/fticr_nonpolar_trt.csv", row.names = FALSE)

fticr_meta_combined %>% write.csv("data/processed/fticr_meta_combined.csv", row.names = FALSE)
fticr_data_longform_combined %>% write.csv("data/processed/fticr_data_longform_combined.csv", row.names = FALSE)
fticr_data_trt_combined %>% write.csv("data/processed/fticr_data_trt_combined.csv", row.names = FALSE)

