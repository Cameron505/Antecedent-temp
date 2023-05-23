



Lip<-Lipid_PCA$Lipid_data_composite %>%
  separate_wider_delim(Name2, "__", names=c("Lipid","MODE"))%>%
  mutate(Inc = replace(Inc, Inc == "T0", "Pre"))%>%
  select(-c(MODE,Pre,Inc,class))%>%
  group_by(Lipid,Sample.ID)%>%
  summarize(value=mean(value))%>%
  pivot_wider(names_from = Sample.ID, values_from = value)


write.csv(Lip, "Data/ForLipidMap.csv", quote = F, row.names = F)
