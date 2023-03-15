plot_respiration = function(respiration_processed){
  
  
  gg_res =
    respiration_processed %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("-2","-6"))) %>%
    ggplot(aes(x = JD2, y = Res, color = pre_inc))+
    geom_point(position = position_dodge(width = 0.4),
               size = 2)+
    stat_smooth(method= "lm")+
    stat_cor(label.y=c(90,100), size=2)+
    stat_regline_equation(label.y=c(110,120), size=2)+
    #geom_text(data = res_lm , aes(y = 300, label = p.value))+
    ylab(expression(paste( "Respiration (",mu,"g-C",day^-1, ")")))+
    facet_wrap(~Inc_temp)+
    theme_light()+
    scale_colour_manual(values=cbPalette2)+
    scale_fill_manual(values=cbPalette2)+
    ylab(expression(paste( "Respiration (",mu,"g-C",day^-1, ")")))+
    xlab("incubation day")+
    labs(color='pre_inc temp') +
    ggtitle("Soil Respiration")
  
  gg_cumres =
    respiration_processed %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("-2","-6"))) %>%
    ggplot(aes(x = JD2, y = val, color =  pre_inc))+
    geom_point(position = position_dodge(width = 0.4),
               size = 2)+
    stat_smooth(method= "lm")+
    stat_cor(label.y=c(285,305), size=2)+
    stat_regline_equation(label.y=c(245,265), size=2)+
    ylab(expression(paste( "Respiration (",mu,"g-C)")))+
    facet_wrap(~Inc_temp)+
    theme_light()+
    scale_colour_manual(values=cbPalette2)+
    scale_fill_manual(values=cbPalette2)+
    ylab(expression(paste( "Respiration (",mu,"g-C)")))+
    xlab("incubation day")+
    labs(color='pre_inc temp') +
    ggtitle("Cumulative Soil Respiration")
  
  gg_Avgres =
    respiration_processed %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("-2","-6"))) %>%
    ggplot(aes(x=JD2, y=Res, color=pre_inc))+
    stat_summary(fun = mean,geom = "point",size = 2) +
    stat_summary(fun.data = mean_se, geom = "errorbar")+
    stat_smooth(method= "lm")+
    stat_cor(label.y=c(90,100), size=2)+
    stat_regline_equation(label.y=c(110,120), size=2)+
    facet_wrap(~Inc_temp)+
    theme_light()+
    scale_colour_manual(values=cbPalette2)+
    scale_fill_manual(values=cbPalette2)+
    ylab(expression(paste( "Respiration (",mu,"g-C",day^-1, ")")))+
    xlab("incubation day")+
    labs(color='pre_inc temp') +
    ggtitle("Average Soil Respiration")
  
  gg_Avgcumres =
    respiration_processed %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("-2","-6"))) %>%
  ggplot(aes(x=JD2, y=val, color=pre_inc))+
    stat_summary(fun = mean,geom = "point",size = 2) +
    stat_summary(fun.data = mean_se, geom = "errorbar")+
    stat_smooth(method= "lm")+
    stat_cor(label.y=c(285,305), size=2)+
    stat_regline_equation(label.y=c(245,265), size=2)+
    facet_wrap(~Inc_temp)+
    theme_light()+
    scale_colour_manual(values=cbPalette2)+
    scale_fill_manual(values=cbPalette2)+
    ylab(expression(paste( "Respiration (",mu,"g-C)")))+
    xlab("incubation day")+
    labs(color='pre_inc temp') +
    ggtitle("Average Cumulative Soil Respiration")
  
  list("Respiration" = gg_res,
       "Average Respiration" = gg_Avgres,
       "Cumulative Respiration" = gg_cumres,
       "Average Cumulative Respiration" = gg_Avgcumres)
  
}

plot_nutrients = function(nutrients_data){
  
  ####
  #Significance between pre-incubation temps across incubation (Marked with asterisk)
    fit_aov = function(nutrients_data){
      
      a = aov(conc ~ pre_inc, data = nutrients_data)
      broom::tidy(a) %>% 
        filter(term == "pre_inc") %>% 
        dplyr::select(`p.value`) %>% 
        mutate(asterisk = case_when(`p.value` <= 0.05 ~ "*"))
      
    }
  
nutrients_data_long = nutrients_data %>%
    pivot_longer(cols= NH4:MBN,
                 names_to= "analyte",
                 values_to= "conc")

  all_aov = 
    nutrients_data_long %>% 
    group_by(analyte, Inc_temp) %>% 
    filter(pre_inc!="none")%>%
    do(fit_aov(.)) %>% 
    mutate(pre_inc = "-2") %>% 
    # factor the Inc_temp so they can line up in the graph
    mutate(Inc_temp = factor(Inc_temp, levels=c("Pre","-2","-6","2","4","6","8","10")))
  
 #### 
  
  ####
  #doing abc anova analysis comparing incubation temperatures
  #Yields all "a's for everything except for TRS
  
  fit_hsd = function(dat){
    a = aov(conc ~ Inc_temp, data = nutrients_data_long)
    h = HSD.test(a, "Inc_temp")
    h$groups %>% mutate(Inc_temp = row.names(.)) %>%
      dplyr::rename(label = groups) %>%  
      dplyr::select(Inc_temp, label)
  }
  
  hsd_label = 
    nutrients_data_long %>%
    filter(pre_inc != "none")%>%
    group_by(analyte,pre_inc) %>% 
    do(fit_hsd(.))
  
  hsd_label2 = 
    nutrients_data_long %>%
    group_by(analyte) %>% 
    do(fit_hsd(.)) %>%
    mutate(pre_inc= "-2")
  ####
  
  
  #### Setting up DunnettTest Yields no significant values
  
  
  dunnett_soil <- function(nutrients_data_long) {
    
    nutrients_data_long = nutrients_data_long %>% mutate(`Incubation.ID` = as.factor(`Incubation.ID`))
      
    d <- DescTools::DunnettTest(conc ~ `Incubation.ID`, control = "Pre", data = nutrients_data_long)
    t = 
      d$Pre %>% 
      as.data.frame() %>% 
      rownames_to_column("comparison") %>% 
      dplyr::select(comparison, pval) %>% 
      mutate(pre = if_else(pval<0.05, "*","")) %>% 
      # remove the pval column
      dplyr::select(-pval) %>% 
      separate(comparison, sep = "-", into = "Incubation.ID")
    
    t
    
  }
  
  dunnett_label = 
    nutrients_data_long %>%
    filter(`Incubation.ID` != "Pre-Pre") %>% 
    group_by(analyte, pre_inc) %>% 
    do(dunnett_soil(.))
    
  ####
  
  #Graphs commented out geom_text is for abc labels
  
  nutrients_data[nutrients_data == "none"] <- "T0"
  
  gg_NH4 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=NH4, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= position_dodge(0.85), width=0.5)+
    #geom_text(data = hsd_label2 %>% filter(analyte == "NH4"), aes(y = 5, label = label))+
    #geom_text(data = hsd_label %>% filter(analyte == "NH4"), aes(y = 6, label = label),position= position_dodge(width = 1))+
    geom_text(data = all_aov %>% filter(analyte == "NH4"), aes(y = 5, label = asterisk), size=10)+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
    labs(x = "Incubation Temp.", 
         y = bquote('Ammonium ('*mu*'g '*NH[4]^"+"~-N~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    ggtitle("Ammonium")
  
  gg_NO3 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=NO3, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= position_dodge(0.85), width=0.5)+
    #geom_text(data = hsd_label2 %>% filter(analyte == "NO3"), aes(y = 30, label = label))+
    #geom_text(data = hsd_label %>% filter(analyte == "NO3"), aes(y = 33, label = label),position= position_dodge(width = 1))+
    geom_text(data = all_aov %>% filter(analyte == "NO3"), aes(y = 30, label = asterisk), size=10)+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
    labs(x = "Incubation Temp.", 
         y = bquote('Nitrate ('*mu*'g '*NO[3]^"-"~-N~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    ggtitle("Nitrate")
  
  gg_TFPA =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=TFPA, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= position_dodge(0.85), width=0.5)+
    #geom_text(data = hsd_label2 %>% filter(analyte == "TFPA"), aes(y = 130, label = label))+
    #geom_text(data = hsd_label %>% filter(analyte == "TFPA"), aes(y = 138, label = label),position= position_dodge(width = 1))+
    geom_text(data = all_aov %>% filter(analyte == "TFPA"), aes(y = 130, label = asterisk), size=10)+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
    labs(x = "Incubation Temp.", 
         y = bquote(atop('Total free primary amines-Leucine equiv.',paste('(nMol' ~g^-1 ~ dry ~ soil*')'))))+
    labs(color='pre_inc temp') +
    ggtitle("TFPA")
  
  gg_TRS =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=TRS, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= position_dodge(0.85), width=0.5)+
    #geom_text(data = hsd_label2 %>% filter(analyte == "TRS"), aes(y = 0.8, label = label))+
    #geom_text(data = hsd_label %>% filter(analyte == "TRS"), aes(y = 0.9, label = label),position= position_dodge(width = 1))+
    geom_text(data = all_aov %>% filter(analyte == "TRS"), aes(y = 0.8, label = asterisk), size=10)+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
    labs(x = "Incubation Temp.", 
         y = bquote('Total reducing sugars-glucose equiv. ('*mu*'Mol' ~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    ggtitle("TRS")
  
  gg_PO4 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=PO4, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= position_dodge(0.85), width=0.5)+
    geom_text(data = all_aov %>% filter(analyte == "PO4"), aes(y = 0.58, label = asterisk), size=10)+
    #geom_text(data = hsd_label2 %>% filter(analyte == "PO4"), aes(y = 0.58, label = label))+
    #geom_text(data = hsd_label %>% filter(analyte == "PO4"), aes(y = 0.68, label = label),position= position_dodge(width = 1))+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
    labs(x = "Incubation Temp.", 
         y = bquote('Phosphate ('*mu*'g '*PO[4]^"3-"~-P~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    ggtitle("Phosphate")
  
  Nutrient_legend = get_legend(gg_NH4+ guides(color = guide_legend(nrow = 1)) +
                                 theme(legend.position = "bottom"))
  gg_Ncombine= plot_grid(
    gg_NH4 + theme(legend.position="none", axis.title.x = element_blank()),
    gg_NO3 + theme(legend.position="none",axis.title.x = element_blank()),
    gg_TFPA + theme(legend.position="none",axis.title.x = element_blank()),
    gg_PO4 + theme(legend.position="none",axis.title.x = element_blank()),
    align = 'vh',
    labels = c("A", "B", "C", "D"),
    label_x= 0.1,
    hjust = -1,
    nrow = 2
  )
gg_N_Legend=plot_grid(gg_Ncombine,Nutrient_legend, ncol=1, rel_heights =c(1,0.1))
  
  list("Ammonium" = gg_NH4,
       "Nitrate" = gg_NO3,
       "Total free primary amines" = gg_TFPA,
       "Phosphate" = gg_PO4,
       "Total reducing sugars" = gg_TRS,
       "N combined"=gg_N_Legend
  )
  
}

plot_MicrobialBiomass = function(nutrients_data){

  
  
   fit_aov = function(nutrients_data){
    
    a = aov(conc ~ pre_inc, data = nutrients_data)
    broom::tidy(a) %>% 
      filter(term == "pre_inc") %>% 
      dplyr::select(`p.value`) %>% 
      mutate(asterisk = case_when(`p.value` <= 0.05 ~ "*"))
    
  }
  
  nutrients_data_long = nutrients_data %>%
    pivot_longer(cols= NH4:MBN,
                 names_to= "analyte",
                 values_to= "conc")
  
  all_aov = 
    nutrients_data_long %>% 
    group_by(analyte, Inc_temp) %>% 
    filter(pre_inc!="none")%>%
    do(fit_aov(.)) %>% 
    mutate(pre_inc = "-2") %>% 
    # factor the Inc_temp so they can line up in the graph
    mutate(Inc_temp = factor(Inc_temp, levels=c("Pre","-2","-6","2","4","6","8","10")))
  
  fit_aov2 = function(nutrients_data){
    a = aov(conc ~ pre_inc*Inc_temp, data = nutrients_data)
    broom::tidy(a) %>%
      mutate(asterisk = case_when(`p.value` <= 0.05 ~ "*"))
    
  }  
  
  
  all_aov2 = 
    nutrients_data_long %>% 
    group_by(analyte) %>% 
    filter(Incubation.ID!=c("Pre","Pre-Pre"))%>%
    do(fit_aov2(.)) 
    
  

  
  nutrients_data[nutrients_data == "none"] <- "T0"  
  
   gg_MBC =
    nutrients_data %>%
     mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
            pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=MBC, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= position_dodge(0.85), width=0.5)+
     #geom_text(data = hsd_label2 %>% filter(analyte == "MBC"), aes(y = 875, label = label))+
     #geom_text(data = hsd_label %>% filter(analyte == "MBC"), aes(y = 885, label = label),position= position_dodge(width = 1))+
    geom_text(data = all_aov %>% filter(analyte == "MBC"), aes(y = 875, label = asterisk), size=10)+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
    labs(x = "Incubation Temp.", 
         y = bquote('Microbial biomass ('*mu*'g C'~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    ggtitle("Microbial biomass carbon")
  
  gg_MBN =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=MBN, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= position_dodge(0.85), width=0.5)+
    #geom_text(data = hsd_label2 %>% filter(analyte == "MBN"), aes(y = 125, label = label))+
    #geom_text(data = hsd_label %>% filter(analyte == "MBN"), aes(y = 135, label = label),position= position_dodge(width = 1))+
    #geom_text(data = all_aov %>% filter(analyte == "MBN"), aes(y = 125, label = asterisk), size=10)+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
    labs(x = "Incubation Temp.", 
         y = bquote('Microbial biomass ('*mu*'g N'~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    ggtitle("Microbial biomass nitrogen")
  
  
  
  biomass_legend = get_legend(gg_MBC+ guides(color = guide_legend(nrow = 1)) +
                                 theme(legend.position = "bottom"))
  gg_Biomasscombine= plot_grid(
    gg_MBC + theme(legend.position="none"),
    gg_MBN + theme(legend.position="none"),
    align = 'vh',
    labels = c("A", "B", "C"),
    hjust = -1,
    nrow = 1
  )
  gg_Biomass_Legend=plot_grid(gg_Biomasscombine,biomass_legend, ncol=1, rel_heights =c(1,0.1))
  
  list("Microbial biomass carbon" = gg_MBC,
       "Microbial biomass nitrogen" = gg_MBN,
       "Total Biomass"=gg_Biomass_Legend
       
  )
  
}

Print_stats= function(nutrients_data,respiration_processed){
  
  diffres<- respiration_processed %>%
    filter(JD2==5)%>%
    group_by(Inc_temp,pre_inc) %>%
    select(-c(Sample_ID,Res))%>%
    dplyr::summarize(Mean = mean(val, na.rm=TRUE))%>%
    pivot_wider(names_from = pre_inc, values_from = Mean)%>%
    unnest() %>%
    ungroup%>%
    mutate(Diff= `-6` - `-2`) %>%
    knitr::kable("simple", caption= "Difference in cumulative respiration between pre incubation temperatures")
  
  
 LASTRES<- respiration_processed %>%
   filter(JD2==5)
 
   summary(aov(val~pre_inc+Inc_temp, data=LASTRES))
 
 
  a = nlme::lme(Res ~ JD2 + Inc_temp + pre_inc,
                random = ~1|Sample_ID,
                data = respiration_processed)
    
  aanova<-anova(a) %>%
    knitr::kable("simple")
  
  
   fit_aov = function(nutrients_data){
    
    a = aov(conc ~ pre_inc, data = nutrients_data)
    broom::tidy(a) %>% 
      filter(term == "pre_inc") %>% 
      dplyr::select(`p.value`) %>% 
      mutate(asterisk = case_when(`p.value` <= 0.05 ~ "*"))
    
  }
  
  nutrients_data_long = nutrients_data %>%
    pivot_longer(cols= NH4:MBN,
                 names_to= "analyte",
                 values_to= "conc")
  
  all_aov = 
    nutrients_data_long %>% 
    group_by(analyte, Inc_temp) %>% 
    filter(pre_inc!="none")%>%
    do(fit_aov(.)) %>% 
    mutate(pre_inc = "-2") %>% 
    # factor the Inc_temp so they can line up in the graph
    mutate(Inc_temp = factor(Inc_temp, levels=c("Pre","-2","-6","2","4","6","8","10")))
  
  fit_aov2 = function(nutrients_data){
    a = aov(conc ~ pre_inc*Inc_temp, data = nutrients_data)
    broom::tidy(a) %>%
      mutate(asterisk = case_when(`p.value` <= 0.05 ~ "*"))
    
  } 
  
  all_aov2 = 
    nutrients_data_long %>% 
    group_by(analyte) %>% 
    filter(Incubation.ID!=c("Pre","Pre-Pre"))%>%
    do(fit_aov2(.)) %>%
    knitr::kable("simple")


  aanova
  
  all_aov2
  
  diffres


  list("Respiration statistics: anova(lme(Res ~ JD2 + Inc_temp + pre_inc,random = ~1|Sample_ID))"= aanova,
       "ANOVA Nutrients and Microbial biomass: aov(conc ~ pre_inc*Inc_temp)" = all_aov2,
       diffres = diffres
       
  )
  
}

