library(pmartR)
library(tidyverse)
##############
## FORMAT DATA ##
#################

# Read data into R
edata <- read.csv("Data/GC/GC_Data.csv")
fdata <- read.csv("Data/GC/GC_LC_fdata2.csv")

colnames(fdata)[1] <- "Sample.ID"
colnames(edata)[1] <- "Metabolites"

edata2<-edata%>%
  select(-Tags,-RefMet.Nomenclature,-Main.class,-Sub.class,-Alternative.Identifications
)
emeta<-edata%>%
  select(Metabolites,Tags,RefMet.Nomenclature,Main.class,Sub.class,Alternative.Identifications
  )


# Create metabolite object --> make sure 0 is NA
metab_data <- as.metabData(edata2, fdata, edata_cname = "Metabolites", fdata_cname = "Sample.ID")

# Log transform data 
metab_data <- edata_transform(metab_data, "log2")

# Add group designation
metab_data <- group_designation(metab_data, main_effects = "pre")
plot(metab_data,order_by = colnames(fdata) [2], color_by = colnames(fdata)[2])

#################
## FILTER DATA ##
#################

# Add biomolecule filter
plot(molecule_filter(metab_data))
metab_filter <- applyFilt(molecule_filter(metab_data), metab_data,min_num=4)
plot(metab_filter,order_by = colnames(fdata) [2], color_by = colnames(fdata)[2])
# Add imd anova
metab_filter <- applyFilt(imdanova_filter(metab_data), metab_filter, 
                          min_nonmiss_anova = 3, min_nonmiss_gtest = 3)

# Add rmd filter

plot(rmd_filter(metab_data,ignore_singleton_groups = TRUE, metrics = NULL), pvalue_threshold = 0.0001)
metab_filter <- applyFilt(rmd_filter(metab_data,ignore_singleton_groups = TRUE,metrics=NULL), metab_filter, pvalue_threshold = 0.000001)

###################
## NORMALIZATION ##
###################

normal_test <- normalize_global(metab_filter, subset_fn = "all", norm_fn = "mean")
pmartR::normRes_tests(normal_test) # Bad option! We want it to be > 0.05 at least. 

metab_final <- normalize_global(metab_filter, subset_fn = "all", norm_fn = "mean", apply_norm = TRUE, 
                                backtransform = TRUE)
plot(metab_final,order_by = colnames(fdata) [2], color_by = colnames(fdata)[2])

write.csv(metab_final$e_data, "Data/GC/normalized_preinc.csv", quote = F, row.names = F)

#########################################
## imd-anova "Differential Expression" ##
#########################################

statResAnova <- imd_anova(metab_final, test_method = "anova")

plot(statResAnova)
write.csv(statResAnova, "Data/GC/stats_preinc.csv", quote = F, row.names = F)










metab_data2 <- group_designation(metab_data, main_effects = "inc")
plot(metab_data2,order_by = colnames(fdata) [2], color_by = colnames(fdata)[2])

#################
## FILTER DATA ##
#################

# Add biomolecule filter
plot(molecule_filter(metab_data2))
metab_filter <- applyFilt(molecule_filter(metab_data2), metab_data2,min_num=4)
plot(metab_filter,order_by = colnames(fdata) [3], color_by = colnames(fdata)[3])
# Add imd anova
metab_filter <- applyFilt(imdanova_filter(metab_data2), metab_filter, 
                          min_nonmiss_anova = 3, min_nonmiss_gtest = 3)

# Add rmd filter

plot(rmd_filter(metab_data2,ignore_singleton_groups = TRUE, metrics = NULL), pvalue_threshold = 0.0001)
metab_filter <- applyFilt(rmd_filter(metab_data2,ignore_singleton_groups = TRUE,metrics=NULL), metab_filter, pvalue_threshold = 0.000001)

###################
## NORMALIZATION ##
###################

normal_test <- normalize_global(metab_filter, subset_fn = "all", norm_fn = "mean")
pmartR::normRes_tests(normal_test) # Bad option! We want it to be > 0.05 at least. 

metab_final <- normalize_global(metab_filter, subset_fn = "all", norm_fn = "mean", apply_norm = TRUE, 
                                backtransform = TRUE)
plot(metab_final,order_by = colnames(fdata) [3], color_by = colnames(fdata)[3])

write.csv(metab_final$e_data, "Data/GC/normalized_inc.csv", quote = F, row.names = F)

#########################################
## imd-anova "Differential Expression" ##
#########################################

statResAnova <- imd_anova(metab_final, test_method = "anova")

plot(statResAnova)
write.csv(statResAnova, "Data/GC/stats_inc.csv", quote = F, row.names = F)














#PREINCUBATION ONLY


# Read data into R
edata <- read.csv("Data/GC/GC_Data.csv")
fdata <- read.csv("Data/GC/GC_LC_fdata2.csv")

colnames(fdata)[1] <- "Sample.ID"
colnames(edata)[1] <- "Metabolites"


fdata<-fdata %>%
  filter(inc== c("pre"))


edata2<-edata%>%
  select(-Tags,-RefMet.Nomenclature,-Main.class,-Sub.class,-Alternative.Identifications
  )%>%
  select(Metabolites,Wein_2_Pre_6_3,Wein_7_Pre_6_2,Wein_20_Pre_2_3,Wein_22_Pre_2_2,Wein_35_Pre_6_1,Wein_36_Pre_2_1)
emeta<-edata%>%
  select(Metabolites,Tags,RefMet.Nomenclature,Main.class,Sub.class,Alternative.Identifications
  )


# Create metabolite object --> make sure 0 is NA
metab_data <- as.metabData(edata2, fdata, edata_cname = "Metabolites", fdata_cname = "Sample.ID")

# Log transform data 
metab_data <- edata_transform(metab_data, "log2")

# Add group designation
metab_data <- group_designation(metab_data, main_effects = "pre")
plot(metab_data,order_by = colnames(fdata) [2], color_by = colnames(fdata)[2])

#################
## FILTER DATA ##
#################

# Add biomolecule filter
plot(molecule_filter(metab_data))
metab_filter <- applyFilt(molecule_filter(metab_data), metab_data,min_num=1)
plot(metab_filter,order_by = colnames(fdata) [2], color_by = colnames(fdata)[2])

#########################################
## imd-anova "Differential Expression" ##
#########################################

statResAnova <- imd_anova(metab_filter, test_method = "anova")

plot(statResAnova)
write.csv(statResAnova, "Data/GC/stats_preincONLY.csv", quote = F, row.names = F)
