library(pmartR)
library(tidyverse)
##############
## FORMAT DATA ##
#################

# Read data into R
edata <- read.csv("Data/lipids/Lipid_POS_data.csv")
fdata <- read.csv("Data/lipids/Lipid_metadata.csv")




colnames(fdata)[1] <- "Sample.ID"
colnames(edata)[1] <- "Name"




# Create metabolite object --> make sure 0 is NA
metab_data <- as.metabData(edata, fdata, edata_cname = "Name", fdata_cname = "Sample.ID")

# Log transform data 
metab_data <- edata_transform(metab_data, "log2")


# Add group designation
metab_data <- group_designation(metab_data, main_effects = c("Pre","Inc"))
plot(metab_data,order_by = colnames(fdata) [2], color_by = colnames(fdata)[2])
plot(metab_data,order_by = colnames(fdata) [3], color_by = colnames(fdata)[3])

#################
## FILTER DATA ##
#################

# Add biomolecule filter
plot(molecule_filter(metab_data))
metab_filter2 <- applyFilt(molecule_filter(metab_data), metab_data,min_num=4)
plot(metab_filter2,order_by = colnames(fdata) [2], color_by = colnames(fdata)[2])
plot(metab_filter2,order_by = colnames(fdata) [3], color_by = colnames(fdata)[3])
# Add imd anova
metab_filter <- applyFilt(imdanova_filter(metab_data), metab_filter2, 
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
write.csv(metab_final$e_data, "Data/lipids/normalized_posLipid_pre_and_inc.csv", quote = F, row.names = F)

#########################################
## imd-anova "Differential Expression" ##
#########################################

statResAnova2 <- imd_anova(metab_final, test_method = "anova")

plot(statResAnova2)
write.csv(statResAnova2, "Data/lipids/stats_posLipid_pre_and_inc.csv", quote = F, row.names = F)


StatsLCpos_all<-statResAnova2 %>%
  select(1:25,98,111,113,136,137,152,164,177,179,202,203,218)
write.csv(StatsLCpos_all, "Data/LC/stats_posLipids_pre_and_inc_compare_at_inc.csv", quote = F, row.names = F)



Means<-statResAnova2 %>%
  select(1, 14:25)%>%
  pivot_longer(cols="Mean_-2_T0":"Mean_-6_10",
               names_to="treatment",
               values_to="mean")%>%
  separate_wider_delim(treatment, "_", names=c("fun","pre","inc"))%>%
  select(-fun)
  


Lipidpos<-Means%>%
  mutate(inc = factor(inc, levels=c("T0","2","4","6","8","10")),
         pre = factor(pre,levels=c("-2","-6"))) %>%
  ggplot(aes(x = inc, y = mean, color = pre))+
  geom_point(position = position_dodge(width = 0.5), size = 1.5)+
  facet_wrap(~Name, scales="free")+
  theme_light()+
  scale_colour_manual(values=cbPalette2)+
  ggtitle("Lipids_pos known compound means")


ggsave(Lipidpos,filename="Lipids_pos.png", "Graphs/", device="png",width = 25, height = 20 , units = "in")



Means2<-Means %>%
  filter(Name%in%c("DGDG(14:0/16:1)","DGDG(31:1)","PC(0:0/18:1)_B","PC(16:0/18:1)","TG(47:1)","TG(48:0)","PC(17:1/18:1)","Cer(d18:1/26:1(2OH))","DG(18:2/0:0/18:2)","DGDG(16:0/18:3)","TG(54:2)","TG(36:0)","TG(50:0)","TG(16:1/18:2/18:3)","DGDG(18:1/18:2)","PC(15:0/17:0)","PC(16:1/0:0)","DG(18:2/18:3/0:0)","Cer(d16:0/20:0)","DGDG(18:2/18:2)"))



Lipidpos2<-Means2%>%
  mutate(inc = factor(inc, levels=c("T0","2","4","6","8","10")),
         pre = factor(pre,levels=c("-2","-6"))) %>%
  ggplot(aes(x = inc, y = mean, color = pre))+
  geom_point(position = position_dodge(width = 0.5), size = 3)+
  facet_wrap(~Name, scales="free")+
  theme_light()+
  scale_colour_manual(values=cbPalette2)+
  ggtitle("Lipids_pos significant")


ggsave(Lipidpos2,filename="Lipids_pos_sig.png", "Graphs/", device="png",width = 15, height = 12 , units = "in")
