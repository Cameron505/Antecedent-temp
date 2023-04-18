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
metab_data <- group_designation(metab_data, main_effects = c("pre","inc"))
plot(metab_data,order_by = colnames(fdata) [2], color_by = colnames(fdata)[2])
plot(metab_data,order_by = colnames(fdata) [3], color_by = colnames(fdata)[3])
#################
## FILTER DATA ##
#################

# Add biomolecule filter
plot(molecule_filter(metab_data))
metab_filter <- applyFilt(molecule_filter(metab_data), metab_data,min_num=4)
plot(metab_filter,order_by = colnames(fdata) [2], color_by = colnames(fdata)[2])
plot(metab_filter,order_by = colnames(fdata) [3], color_by = colnames(fdata)[3])
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
plot(metab_final,order_by = colnames(fdata) [3], color_by = colnames(fdata)[3])
write.csv(metab_final$e_data, "Data/GC/normalized_GC_pre_and_inc.csv", quote = F, row.names = F)

#########################################
## imd-anova "Differential Expression" ##
#########################################

statResAnova <- imd_anova(metab_final, test_method = "anova")

plot(statResAnova)
write.csv(statResAnova, "Data/GC/stats_GC_pre_and_inc.csv", quote = F, row.names = F)


StatsGC<-statResAnova %>%
  select(1:25,100,111,117,124,130,154,166,177,183,190,196,220)

write.csv(StatsGC, "Data/GC/stats_GC_pre_and_inc_preinc_compare_at_inc.csv", quote = F, row.names = F)
