library(pmartR)
library(tidyverse)
##############
## FORMAT DATA ##
#################

# Read data into R
edata <- read.csv("Data/LC/LC_neg_Data.csv")
fdata <- read.csv("Data/LC/LC_fdata.csv")


edata2<-edata%>%
  select(-m.z,-RT..min.,-Tags,-RefMet.Nomenclature,-Main.class,-Sub.class,-Formula,-Annot..DeltaMass..ppm.,-Calc..MW,-Reference.Ion
  )
emeta<-edata%>%
  select(m.z,RT..min.,Name,Tags,RefMet.Nomenclature,Main.class,Sub.class,Formula,Annot..DeltaMass..ppm.,Calc..MW,Reference.Ion
  )



colnames(fdata)[1] <- "Sample.ID"
colnames(edata2)[1] <- "Name"




# Create metabolite object --> make sure 0 is NA
metab_data <- as.metabData(edata2, fdata, edata_cname = "Name", fdata_cname = "Sample.ID")

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

write.csv(metab_final$e_data, "Data/LC/normalized_neg_preinc.csv", quote = F, row.names = F)

#########################################
## imd-anova "Differential Expression" ##
#########################################

statResAnova <- imd_anova(metab_final, test_method = "anova")

plot(statResAnova)
write.csv(statResAnova, "Data/LC/stats_neg_preinc.csv", quote = F, row.names = F)










metab_data2 <- group_designation(metab_data, main_effects = "inc")
plot(metab_data2,order_by = colnames(fdata) [3], color_by = colnames(fdata)[3])

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

write.csv(metab_final$e_data, "Data/LC/normalized_neg_inc.csv", quote = F, row.names = F)

#########################################
## imd-anova "Differential Expression" ##
#########################################

statResAnova <- imd_anova(metab_final, test_method = "anova")

plot(statResAnova)
write.csv(statResAnova, "Data/LC/stats_neg_inc.csv", quote = F, row.names = F)



##preinc only
Pre_2_1, Pre_2_2, Pre_2_3, Pre_6_1,	Pre_6_2, Pre_6_3

edata2<-edata%>%
  select(-m.z,-RT..min.,-Tags,-RefMet.Nomenclature,-Main.class,-Sub.class,-Formula,-Annot..DeltaMass..ppm.,-Calc..MW,-Reference.Ion
  ) %>%
  select(Name,Pre_2_1, Pre_2_2, Pre_2_3, Pre_6_1,	Pre_6_2, Pre_6_3)
emeta<-edata%>%
  select(m.z,RT..min.,Name,Tags,RefMet.Nomenclature,Main.class,Sub.class,Formula,Annot..DeltaMass..ppm.,Calc..MW,Reference.Ion
  )

fdata<-fdata%>%
  filter(inc=="pre")

colnames(fdata)[1] <- "Sample.ID"
colnames(edata2)[1] <- "Name"




# Create metabolite object --> make sure 0 is NA
metab_data <- as.metabData(edata2, fdata, edata_cname = "Name", fdata_cname = "Sample.ID")

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




#########################################
## imd-anova "Differential Expression" ##
#########################################

statResAnova <- imd_anova(metab_filter, test_method = "anova")

plot(statResAnova)
write.csv(statResAnova, "Data/LC/stats_neg_preincONLY.csv", quote = F, row.names = F)



