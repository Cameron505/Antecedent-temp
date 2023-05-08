
##Lipid non-normalized data

statResAnova <- imd_anova(metab_filter, test_method = "anova")

StatsLC<-statResAnova %>%
  select(1:25,98,111,113,136,137,152,164,177,179,202,203,218)%>%
  knitr::kable()








Lipid_data_composite = metab_filter$e_data %>%
  pivot_longer(cols=Wein_51407_22_Pre_2_2_L:Wein_51407_19_A_2_1_L, names_to= "Sample.ID")%>%
  left_join(metab_filter$f_data, by= "Sample.ID")%>%
  mutate(class = case_when(grepl("Cer", Name2) ~ "Sphingolipid",
                           grepl("CoQ", Name2) ~ "Prenol Lipid",
                           grepl("PC", Name2) ~ "Glycerophospholipid",
                           grepl("PE", Name2) ~ "Glycerophospholipid",
                           grepl("PG", Name2) ~ "Glycerophospholipid",
                           grepl("PI", Name2) ~ "Glycerophospholipid",
                           grepl("DG", Name2) ~ "Glycerolipid",
                           grepl("TG", Name2) ~ "Glycerolipid"))









Means<-Lipid_PCA$Lipid_data_composite %>%
  separate_wider_delim(Name2, "__", names=c("Lipid","MODE"))


Lipid_pos<-Means%>%
  mutate(Inc = factor(Inc, levels=c("T0","2","4","6","8","10")),
         Pre = factor(Pre,levels=c("-2","-6"))) %>%
  filter(MODE=="pos")%>%
  ggplot(aes(x = Inc, y = value, color = Pre))+
  geom_boxplot(show.legend = F, 
               outlier.colour = NULL,
               outlier.fill = NULL,
               position = position_dodge(width = 1), 
               alpha = 0.2,
               aes(group = interaction(Inc, Pre)))+
  geom_point(position = position_dodge(width = 1), size = 1.5)+
  facet_wrap(~Lipid, scales="free")+
  theme_light()+
  scale_colour_manual(values=cbPalette2)+
  ggtitle("LC_pos known compound means")



Lipid_neg<-Means%>%
  mutate(Inc = factor(Inc, levels=c("T0","2","4","6","8","10")),
         Pre = factor(Pre,levels=c("-2","-6"))) %>%
  filter(MODE=="neg")%>%
  ggplot(aes(x = Inc, y = value, color = Pre))+
  geom_boxplot(show.legend = F, 
               outlier.colour = NULL,
               outlier.fill = NULL,
               position = position_dodge(width = 1), 
               alpha = 0.2,
               aes(group = interaction(Inc, Pre)))+
  geom_point(position = position_dodge(width = 1), size = 1.5)+
  facet_wrap(~Lipid, scales="free")+
  theme_light()+
  scale_colour_manual(values=cbPalette2)+
  ggtitle("LC_neg known compound means")

Means2<-Means %>%
  filter(Lipid%in%c("DGDG(14:0/16:1)",
                    "DGDG(31:1)",
                    "PC(0:0/18:1)_B",
                    "PC(16:0/18:1)",
                    "TG(47:1)",
                    "TG(48:0)",
                    "PC(17:1/18:1)",
                    "Cer(d18:1/26:1(2OH))",
                    "DG(18:2/0:0/18:2)",
                    "DGDG(16:0/18:3)",
                    "TG(54:2)",
                    "TG(36:0)",
                    "TG(50:0)",
                    "TG(16:1/18:2/18:3)",
                    "DGDG(18:1/18:2)",
                    "PC(15:0/17:0)",
                    "PC(16:1/0:0)",
                    "DG(18:2/18:3/0:0)",
                    "Cer(d16:0/20:0)",
                    "DGDG(18:2/18:2)"))

Means3<-Means %>%
  filter(Lipid%in%c(
    "PE(16:0/17:0)_A",
    "PE(15:0/15:0)",
    "PE(14:0/15:0)",
    "PE(16:1/17:1)",
    "PE(15:0/16:1)_B",
    "PE(15:0/17:0)",
    "PE(15:0/17:1)",
    "PE(33:2)",
    "PG(15:0/16:1)_B",
    "PG(16:1/17:1)_B",
    "PG(16:0/16:1)",
    "PE(16:0/17:0)_B",
    "PG(16:1/16:1)",
    "PG(16:0/17:1)",
    "PG(16:0/17:0)",
    "PG(15:0/17:1)",
    "PG(15:0/16:1)_A",
    "PE(16:0/17:0)_A",
    "PG(15:0/16:0)_B"))

Lipid_neg2<-Means3%>%
  mutate(Inc = factor(Inc, levels=c("T0","2","4","6","8","10")),
         Pre = factor(Pre,levels=c("-2","-6"))) %>%
  filter(MODE=="neg")%>%
  ggplot(aes(x = Inc, y = value, color = Pre))+
  geom_boxplot(show.legend = F, 
               outlier.colour = NULL,
               outlier.fill = NULL,
               position = position_dodge(width = 1), 
               alpha = 0.2,
               aes(group = interaction(Inc, Pre)))+
  geom_point(position = position_dodge(width = 1), size = 1.5)+
  facet_wrap(~Lipid, scales="free")+
  theme_light()+
  scale_colour_manual(values=cbPalette2)+
  ggtitle("Lipid_neg significant compound means")


Lipid_pos2<-Means2%>%
  mutate(Inc = factor(Inc, levels=c("T0","2","4","6","8","10")),
         Pre = factor(Pre,levels=c("-2","-6"))) %>%
  filter(MODE=="pos")%>%
  ggplot(aes(x = Inc, y = value, color = Pre))+
  geom_boxplot(show.legend = F, 
               outlier.colour = NULL,
               outlier.fill = NULL,
               position = position_dodge(width = 1), 
               alpha = 0.2,
               aes(group = interaction(Inc, Pre)))+
  geom_point(position = position_dodge(width = 1), size = 1.5)+
  facet_wrap(~Lipid, scales="free")+
  theme_light()+
  scale_colour_manual(values=cbPalette2)+
  ggtitle("Lipid_pos significant compound means")


Stat_plot<-plot(statResAnova)
