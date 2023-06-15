# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("tibble", "tidyverse"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):

# tar_make_future() configuration (okay to leave alone):
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Load the R scripts with your custom functions:
source("Code/0-packages.R")
source("Code/a-processing_functions.R")
source("Code/b-analysis_functions.R")
source("Code/fticr/b-functions_analysis.R")


# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:
list(
  
  # sample metadata
  tar_target(sample_key_data, "Data/Sample_key_AntecedentTemp.csv", format = "file"),
  tar_target(sample_key, read.csv(sample_key_data)),
  
  
  # data files
  #tar_target()
  tar_target(respiration_data_read,"Data/Respiration_Antecedent_temp.csv", format="file"),
  tar_target(respiration_data, read.csv(respiration_data_read)),
  tar_target(respiration_processed, process_respiration(respiration_data)),
  tar_target(nutrients_data_read,"Data/Nutrients_MicrobialBiomass_AntecedentTemp.csv", format="file"),
  tar_target(nutrients_data, read.csv(nutrients_data_read)),
  #GC analysis
  tar_target(GC_data_read,"Data/GC/GC_Data.csv", format="file"),
  tar_target(GC_data, read.csv(GC_data_read)),
  tar_target(GC_fdata_read,"Data/GC/GC_LC_fdata2.csv", format="file"),
  tar_target(GC_fdata, read.csv(GC_fdata_read)),
  tar_target(GC_processed, process_GC(GC_data,GC_fdata)),
  tar_target(GC_volcano, process_GC_volcano(GC_data,GC_fdata)),
  tar_target(GC_PCA, GC_process_PCA(GC_processed)),
  tar_target(gg_GC_PCA, plot_GC_PCA(GC_PCA)),
  tar_target(gg_GC, plot_GC(GC_processed)),
  tar_target(gg_GC_PLS, plot_GC_PLS(GC_PCA)),
  
  #LC analysis
  tar_target(LC_POS_data_read,"Data/LC/LC_pos_Data.csv", format="file"),
  tar_target(LC_POS_data, read.csv(LC_POS_data_read)),
  tar_target(LC_fdata_read,"Data/LC/LC_fdata.csv", format="file"),
  tar_target(LC_fdata, read.csv(LC_fdata_read)),
  tar_target(LC_neg_data_read,"Data/LC/LC_neg_Data.csv", format="file"),
  tar_target(LC_neg_data, read.csv(LC_neg_data_read)),
  tar_target(LC_processed, process_LC(LC_POS_data,LC_fdata,LC_neg_data,LC_neg_fdata)),
  tar_target(LC_volcano, process_LC_volcano(LC_POS_data,LC_fdata,LC_neg_data,LC_neg_fdata)),
  tar_target(LC_PCA, LC_process_PCA(LC_processed)),
  tar_target(gg_LC, plot_LC(LC_processed)),
  tar_target(gg_LC_PCA, plot_LC_PCA(LC_PCA)),
  tar_target(gg_LC_PLS, plot_LC_PLS(LC_PCA)),
  
  #Lipid analysis
  tar_target(Lipid_POS_data_read,"Data/lipids/Lipid_POS_data.csv", format="file"),
  tar_target(Lipid_POS_data, read.csv(Lipid_POS_data_read)),
  tar_target(Lipid_NEG_data_read,"Data/lipids/Lipid_NEG_data.csv", format="file"),
  tar_target(Lipid_NEG_data, read.csv(Lipid_NEG_data_read)),
  tar_target(Lipid_fdata_read,"Data/lipids/Lipid_metadata.csv", format="file"),
  tar_target(Lipid_fdata, read.csv(Lipid_fdata_read)),
  tar_target(Lipid_processed, process_Lipid(Lipid_POS_data,Lipid_NEG_data,Lipid_fdata)),
  tar_target(Lipid_PCA, Lipid_process_PCA(Lipid_processed)),
  tar_target(gg_Lipid_PLS, plot_Lipid_PLS(Lipid_PCA)),
  
  tar_target(gg_Lipid, plot_Lipid(Lipid_processed,Lipid_PCA)),
  
  
  
  
  #FTICR
  tar_target(FTICR_Lipid_read,"Data/FTICR/Report_Lipid_NegESI_Consolidation123.csv", format="file"),
  tar_target(FTICR_Lipid, read.csv(FTICR_Lipid_read)),
  tar_target(FTICR_Metabolite_read,"Data/FTICR/Report_Metabolite_NegESI_Consolidation123.csv", format="file"),
  tar_target(FTICR_Metabolite, read.csv(FTICR_Metabolite_read)),
  
  tar_target(FTICR_processed, Process_FTICR(FTICR_Lipid,FTICR_Metabolite)),
  tar_target(FTICR_relabund, FTICR_relabund_fun(FTICR_processed)),
  tar_target(FTICR_relabund2, FTICR_relabund_fun2(FTICR_processed)),
  tar_target(FTICR_relabund_filter, FTICR_relabund_fun_Filter(FTICR_processed)),
  tar_target(FTICR_relabund_filter2, FTICR_relabund_fun_Filter2(FTICR_processed)),
  tar_target(FTICR_relabund_filter_N2N6, FTICR_relabund_fun_Filter_N2N6(FTICR_processed)),
  tar_target(FTICR_relabund_filter_N2N6_2, FTICR_relabund_fun_Filter_N2N6_2(FTICR_processed)),
  
  tar_target(gg_FTICR_vk, plot_FTICR_vk(FTICR_processed)),
  
  tar_target(gg_FTICR_unique, plot_FTICR_unique_all(FTICR_processed)),
  tar_target(gg_FTICR_unique_polar, plot_FTICR_unique_polar(FTICR_processed)),
  tar_target(gg_FTICR_unique_nonpolar, plot_FTICR_unique_nonpolar(FTICR_processed)),
  
  tar_target(gg_FTICR_relabund, plot_FTICR_relabund(FTICR_relabund)),
  tar_target(gg_FTICR_permanova, plot_FTICR_permanova(FTICR_relabund)),
  tar_target(gg_FTICR_PCA, plot_FTICR_PCA(FTICR_relabund)),
  tar_target(gg_FTICR_PCA_DetailedClass, plot_FTICR_PCA_DetailedClass(FTICR_relabund2)),
  tar_target(gg_FTICR_PCA_filter, plot_FTICR_PCA_filter(FTICR_relabund_filter)),
  tar_target(gg_FTICR_PCA_filter_DetailedClass, plot_FTICR_PCA_filter_DetailedClass(FTICR_relabund_filter2)),
  tar_target(gg_FTICR_NOSC, plot_FTICR_NOSC(FTICR_processed)),
  tar_target(gg_FTICR_PCA_filter_N2N6, plot_FTICR_PCA_filter_N2N6(FTICR_relabund_filter_N2N6)),
  tar_target(gg_FTICR_PCA_filter_N2N6_2, plot_FTICR_PCA_filter_N2N6_2(FTICR_relabund_filter_N2N6_2)),
  tar_target(gg_FTICR_PLS, plot_FTICR_PLS(FTICR_relabund)),
  
  # analysis - graphs
  tar_target(gg_respiration, plot_respiration(respiration_processed)),
  tar_target(gg_nutrients, plot_nutrients(nutrients_data)),
  tar_target(gg_MicrobialBiomass, plot_MicrobialBiomass(nutrients_data)),
  tar_target(Stats_Table, Print_stats(nutrients_data,respiration_processed)),
  
  #reports
  tar_render(report, path = "reports/AntecedentTemp_report.Rmd"),
  tar_render(report2, path = "reports/GC_LC_Lipids.Rmd"),
  tar_render(report3, path = "reports/FTICR.Rmd"),
  tar_render(report4, path = "reports/SCGSR_Final_data_report.Rmd"),
  tar_render(report5, path = "reports/SCGSR_Final_data_report2.Rmd"),
  tar_render(report6, path = "reports/Data_explore.Rmd")
)
