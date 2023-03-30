plot_respiration = function(respiration_processed){
  
inc.lab<-c("2 °C","4 °C","6 °C","8 °C","10 °C")
names(inc.lab) <- c("2","4","6","8","10")
  gg_res =
    respiration_processed %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("-2","-6"))) %>%
    ggplot(aes(x = JD2, y = Res, color = pre_inc))+
    geom_point(position = position_dodge(width = 0.4),
               size = 2)+
    geom_smooth(se=F)+
    #stat_smooth(method= "lm")+
    #stat_cor(label.y=c(90,100), size=2)+
    #stat_regline_equation(label.y=c(110,120), size=2)+
    #geom_text(data = res_lm , aes(y = 300, label = p.value))+
    ylab(expression(paste( "Respiration (",mu,"g-C",day^-1, ")")))+
    facet_wrap(~Inc_temp,labeller = labeller(Inc_temp =inc.lab ))+
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
    facet_wrap(~Inc_temp,labeller = labeller(Inc_temp =inc.lab ))+
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
    facet_wrap(~Inc_temp,labeller = labeller(Inc_temp =inc.lab ))+
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
    facet_wrap(~Inc_temp,labeller = labeller(Inc_temp =inc.lab ))+
    theme_light()+
    scale_colour_manual(values=cbPalette2)+
    scale_fill_manual(values=cbPalette2)+
    ylab(expression(paste( "Respiration (",mu,"g-C)")))+
    xlab("incubation day")+
    labs(color='pre_inc temp') +
    ggtitle("Average Cumulative Soil Respiration")
  
  
  
  LASTRES<- respiration_processed %>%
    filter(JD2==5)
  fit_aov = function(LASTRES){
    
    a = aov(val ~ pre_inc, data = LASTRES)
    broom::tidy(a) %>% 
      filter(term == "pre_inc") %>% 
      dplyr::select(`p.value`) %>% 
      mutate(asterisk = case_when(`p.value` <= 0.05 ~ "*"))
    
  }  
  
  rescum_aov = 
    LASTRES %>% 
    group_by(Inc_temp) %>% 
    filter(pre_inc!="none")%>%
    do(fit_aov(.)) %>% 
    mutate(pre_inc = "-2") %>% 
    # factor the Inc_temp so they can line up in the graph
    mutate(Inc_temp = factor(Inc_temp, levels=c("2","4","6","8","10")))
  
  
  gg_CumresLastday =
    LASTRES %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=val, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= position_dodge(0.85), width=0.5)+        
    scale_y_continuous(expand=c(0,0),limits=c(0,370))+
    geom_text(data = rescum_aov, aes(y = 350, label = asterisk), size=4)+
    theme_light()+
    scale_colour_manual(values=cbPalette2)+
    scale_fill_manual(values=cbPalette2,labels=c('-2 °C', '-6 °C'))+
    ylab(expression(paste( "Total respired C (",mu,"g-C)")))+
    xlab("Incubation Temp. (°C)")+
    labs(color='pre-incubation temp') +
    guides(fill=guide_legend(title="Pre-Incubation (°C)"))+
    ggtitle("Cumulative respiration")
  
  respiration_legend = get_legend(gg_CumresLastday+ guides(color = guide_legend(nrow = 1)) +
                                 theme(legend.position = "bottom"))
  gg_Ncombine= plot_grid(
    gg_res + theme(legend.position="none"),
    gg_CumresLastday + theme(legend.position="none"),
    labels = c("A", "B"),
    #label_x= 0.1,
    hjust = -1,
    ncol = 1
  )
  
  gg_N_Legend=plot_grid(gg_Ncombine,respiration_legend, ncol=1, rel_heights =c(1,0.08))
  
  
  list(#"Respiration" = gg_res,
        gg_N_Legend=gg_N_Legend,
       "Average Respiration" = gg_Avgres,
       "Cumulative Respiration" = gg_cumres,
       "Average Cumulative Respiration" = gg_Avgcumres
       )
  
}

plot_nutrients = function(nutrients_data){
  
  
  inc.lab<-c("2 °C","4 °C","6 °C","8 °C","10 °C")
  names(inc.lab) <- c("2","4","6","8","10")
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
  
  dunnett_prepre <- function(nutrients_data_long) {
    
    nutrients_data_long = nutrients_data_long %>% mutate(`Incubation.ID` = as.factor(`Incubation.ID`))
    
    d <- DescTools::DunnettTest(conc ~ `Incubation.ID`, control = "Pre-Pre", data = nutrients_data_long)
    t = 
      d$Pre %>% 
      as.data.frame() %>% 
      rownames_to_column("comparison") %>% 
      dplyr::select(comparison, pval) %>% 
      mutate(T0 = if_else(pval<0.05, "*","")) %>% 
      # remove the pval column
      dplyr::select(-pval) %>% 
      separate(comparison, sep = "-", into = "Incubation.ID")
    
    t
    
  }
  
 
    
  #### pre vs incubated
  dunnett_label = 
    nutrients_data_long %>%
    filter(`Incubation.ID` != "Pre-Pre") %>% 
    group_by(analyte, pre_inc) %>% 
    do(dunnett_soil(.))
  
  #### Dunnett test 2 (-2) prepre vs incubated
  
  dunnett_label2 = 
    nutrients_data_long %>%
    filter(`Incubation.ID` != "-6") %>% 
    group_by(analyte) %>% 
    do(dunnett_prepre(.)) %>%
    mutate(pre_inc= "-2")
  
  
  #### Dunnett test 3 (-6)
  
  dunnett_label3 = 
    nutrients_data_long %>%
    filter(`Incubation.ID` != "-2") %>% 
    group_by(analyte) %>% 
    do(dunnett_prepre(.)) %>%
    mutate(pre_inc= "-6")
  
  
  Dunnett_label_prepre<- rbind(dunnett_label2,dunnett_label3)
  #Graphs commented out geom_text is for abc labels
  
  nutrients_data[nutrients_data == "none"] <- "T0"
  
  gg_NH4 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=NH4, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= position_dodge(0.85), width=0.5)+        
    scale_y_continuous(expand=c(0,0),limits=c(0,5.2))+
    #geom_text(data = hsd_label2 %>% filter(analyte == "NH4"), aes(y = 5, label = label))+
    #geom_text(data = hsd_label %>% filter(analyte == "NH4"), aes(y = 6, label = label),position= position_dodge(width = 1))+
    geom_text(data = all_aov %>% filter(analyte == "NH4"), aes(y = 5, label = asterisk), size=10)+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    
    labs(x = "Incubation Temp. (°C)", 
         y = bquote(' '*NH[4]^"+"~-N~'('*mu*'g '*g^-1~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    guides(fill=guide_legend(title="Pre-Incubation"))+
    ggtitle("Ammonium")
 # y = bquote('Ammonium ('*mu*'g '*NH[4]^"+"~-N~g^-1 ~ dry ~ soil*')'))+
  
  
  
  gg_NO3 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=NO3, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= position_dodge(0.85), width=0.5)+       
    scale_y_continuous(expand=c(0,0),limits=c(0,32))+
    #geom_text(data = hsd_label2 %>% filter(analyte == "NO3"), aes(y = 30, label = label))+
    #geom_text(data = hsd_label %>% filter(analyte == "NO3"), aes(y = 33, label = label),position= position_dodge(width = 1))+
    geom_text(data = all_aov %>% filter(analyte == "NO3"), aes(y = 30, label = asterisk), size=10)+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    
    labs(x = "Incubation Temp. (°C)", 
         y = bquote(' '*NO[3]^"-"~-N~'('*mu*'g '~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    guides(fill=guide_legend(title="Pre-Incubation"))+
    ggtitle("Nitrate")
  #y = bquote('Nitrate ('*mu*'g '*NO[3]^"-"~-N~g^-1 ~ dry ~ soil*')'))+
  
  
  
  gg_TFPA =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=TFPA, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= position_dodge(0.85), width=0.5)+        
    scale_y_continuous(expand=c(0,0),limits=c(0,135))+
    #geom_text(data = hsd_label2 %>% filter(analyte == "TFPA"), aes(y = 130, label = label))+
    #geom_text(data = hsd_label %>% filter(analyte == "TFPA"), aes(y = 138, label = label),position= position_dodge(width = 1))+
    geom_text(data = all_aov %>% filter(analyte == "TFPA"), aes(y = 130, label = asterisk), size=10)+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    
    labs(x = "Incubation Temp. (°C)", 
         y = bquote(atop('TFPA-Leucine equiv.',paste('(nMol' ~g^-1 ~ dry ~ soil*')'))))+
    labs(color='pre_inc temp') +
    guides(fill=guide_legend(title="Pre-Incubation"))+
    ggtitle("Total free primary amines")
  #y = bquote(atop('Total free primary amines-Leucine equiv.',paste('(nMol' ~g^-1 ~ dry ~ soil*')'))))+
  
  
  
  gg_TRS =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=TRS, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= position_dodge(0.85), width=0.5)+        
    scale_y_continuous(expand=c(0,0),limits=c(0,0.6))+
    #geom_text(data = hsd_label2 %>% filter(analyte == "TRS"), aes(y = 0.8, label = label))+
    #geom_text(data = hsd_label %>% filter(analyte == "TRS"), aes(y = 0.9, label = label),position= position_dodge(width = 1))+
    geom_text(data = all_aov %>% filter(analyte == "TRS"), aes(y = 0.54, label = asterisk), size=4)+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    
    labs(x = "Incubation Temp. (°C)", 
         y = bquote('TRS-glucose equiv. ('*mu*'Mol' ~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    guides(fill=guide_legend(title="Pre-Incubation"))+
    ggtitle("Total reducing sugars")
  #y = bquote('Total reducing sugars-glucose equiv. ('*mu*'Mol' ~g^-1 ~ dry ~ soil*')'))+
  
  gg_PO4 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=PO4, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= position_dodge(0.85), width=0.5)+
    scale_y_continuous(expand=c(0,0),limits=c(0,0.62))+
    geom_text(data = all_aov %>% filter(analyte == "PO4"), aes(y = 0.58, label = asterisk), size=10)+
    #geom_text(data = hsd_label2 %>% filter(analyte == "PO4"), aes(y = 0.58, label = label))+
    #geom_text(data = hsd_label %>% filter(analyte == "PO4"), aes(y = 0.68, label = label),position= position_dodge(width = 1))+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    
    labs(x = "Incubation Temp. (°C)", 
         y = bquote(' '*PO[4]^"3-"~-P~'('*mu*'g '~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    guides(fill=guide_legend(title="Pre-Incubation"))+
    ggtitle("Phosphate")
  #y = bquote('Phosphate ('*mu*'g '*PO[4]^"3-"~-P~g^-1 ~ dry ~ soil*')'))+
  
  
  
  Nutrient_legend = get_legend(gg_NH4+ guides(color = guide_legend(nrow = 1)) +
                                 theme(legend.position = "bottom"))
  gg_Ncombine= plot_grid(
    gg_NH4 + theme(legend.position="none", axis.title.x = element_blank()),
    gg_NO3 + theme(legend.position="none",axis.title.x = element_blank()),
    gg_TFPA + theme(legend.position="none"),
    gg_PO4 + theme(legend.position="none"),
    align = 'vh',
    labels = c("A", "B", "C", "D"),
    label_x= 0.1,
    hjust = -1,
    nrow = 2
  )
gg_N_Legend=plot_grid(gg_Ncombine,Nutrient_legend, ncol=1, rel_heights =c(1,0.1))
  
  list(#"Ammonium" = gg_NH4,
       #"Nitrate" = gg_NO3,
       #"Total free primary amines" = gg_TFPA,
       #"Phosphate" = gg_PO4,
       "Total reducing sugars" = gg_TRS,
       "Nutrient combined"=gg_N_Legend
  )
  
}

plot_MicrobialBiomass = function(nutrients_data){

  inc.lab<-c("2 °C","4 °C","6 °C","8 °C","10 °C")
  names(inc.lab) <- c("2","4","6","8","10")
  
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
     scale_y_continuous(expand=c(0,0),limits=c(0,865))+
     #geom_text(data = hsd_label2 %>% filter(analyte == "MBC"), aes(y = 875, label = label))+
     #geom_text(data = hsd_label %>% filter(analyte == "MBC"), aes(y = 885, label = label),position= position_dodge(width = 1))+
    geom_text(data = all_aov %>% filter(analyte == "MBC"), aes(y = 775, label = asterisk), size=4)+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation Temp. (°C)", 
         y = bquote(atop('Microbial biomass', paste('('*mu*'g C'~g^-1~ dry ~ soil*')'))))+
    labs(color='pre_inc temp') +
     guides(fill=guide_legend(title="Pre-Incubation"))+
    ggtitle("Microbial biomass C")
   #y = bquote(atop('Microbial biomass', paste('('*mu*'g C'~g^-1 ~ dry ~ soil*')'))))+
   
   
   
   
   
   
  gg_MBN =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=MBN, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= position_dodge(0.85), width=0.5)+        
    scale_y_continuous(expand=c(0,0),limits=c(0,130))+
    #geom_text(data = hsd_label2 %>% filter(analyte == "MBN"), aes(y = 125, label = label))+
    #geom_text(data = hsd_label %>% filter(analyte == "MBN"), aes(y = 135, label = label),position= position_dodge(width = 1))+
    geom_text(data = all_aov %>% filter(analyte == "MBN"), aes(y = 125, label = asterisk), size=10)+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation Temp. (°C)", 
         y = bquote(atop('Microbial biomass',paste( '('*mu*'g N'~g^-1~ dry ~ soil*')'))))+
    labs(color='pre_inc temp') +
    guides(fill=guide_legend(title="Pre-Incubation"))+
    ggtitle("Microbial biomass N")
  #y = bquote(atop('Microbial biomass',paste( '('*mu*'g N'~g^-1 ~ dry ~ soil*')'))))+
  
  
  biomass_legend = get_legend(gg_MBC+ guides(color = guide_legend(nrow = 1)) +
                                 theme(legend.position = "bottom"))
  gg_Biomasscombine= plot_grid(
    gg_MBC + theme(legend.position="none"),
    gg_MBN + theme(legend.position="none"),
    align = 'vh',
    labels = c("A", "B", "C"),
    label_x= 0.1,
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
 
LastRES_aov = summary(aov(val~pre_inc+Inc_temp, data=LASTRES))
 
 
  a = nlme::lme(Res ~ JD2 + Inc_temp + pre_inc,
                random = ~1|Sample_ID,
                data = respiration_processed)
    
  aanova<-anova(a) %>%
    knitr::kable("simple")
  
  
   fit_aov = function(nutrients_data){
    
    a = aov(conc ~ pre_inc, data = nutrients_data)
    broom::tidy(a) %>% 
      filter(term == "pre_inc") %>% 
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
    mutate(Inc_temp = factor(Inc_temp, levels=c("Pre","-2","-6","2","4","6","8","10")))%>%
    knitr::kable("simple")
  
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
#### Dunnett tests
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
      #dplyr::select(-pval) %>% 
      separate(comparison, sep = "-", into = "Incubation.ID")
    
    t
    
  }
  
  dunnett_prepre <- function(nutrients_data_long) {
    
    nutrients_data_long = nutrients_data_long %>% mutate(`Incubation.ID` = as.factor(`Incubation.ID`))
    
    d <- DescTools::DunnettTest(conc ~ `Incubation.ID`, control = "Pre-Pre", data = nutrients_data_long)
    t = 
      d$Pre %>% 
      as.data.frame() %>% 
      rownames_to_column("comparison") %>% 
      dplyr::select(comparison, pval) %>% 
      mutate(pre = if_else(pval<0.05, "*","")) %>% 
      # remove the pval column
      #dplyr::select(-pval) %>% 
      separate(comparison, sep = "-", into = "Incubation.ID")
    
    t
    
  }
  
  
  
  #### pre vs incubated
  dunnett_label = 
    nutrients_data_long %>%
    filter(`Incubation.ID` != "Pre-Pre") %>% 
    group_by(analyte, pre_inc) %>% 
    do(dunnett_soil(.))
  
  
  #### Dunnett test 2 (-2) prepre vs incubated
  
  dunnett_label2 = 
    nutrients_data_long %>%
    filter(`Incubation.ID` != "-6") %>% 
    group_by(analyte) %>% 
    do(dunnett_prepre(.)) %>%
    mutate(pre_inc= "-2 vs T0")
  
  
  #### Dunnett test 3 (-6)
  
  dunnett_label3 = 
    nutrients_data_long %>%
    filter(`Incubation.ID` != "-2") %>% 
    group_by(analyte) %>% 
    do(dunnett_prepre(.)) %>%
    mutate(pre_inc= "-6 vs T0")
  
  
  Dunnett_label_all<- rbind(dunnett_label,dunnett_label2,dunnett_label3)%>%
    mutate(pre_inc = ifelse(pre_inc == "-2", "-2 vs pre", as.character(pre_inc))) %>%
    mutate(pre_inc = ifelse(pre_inc == "-6", "-6 vs pre", as.character(pre_inc))) %>%
    mutate(Inc_temp = ifelse(Incubation.ID == c("A","B","C","D","E"), c("2","4","6","8","10"), as.character(Incubation.ID))) %>%
    arrange(analyte)%>%
    knitr::kable("simple", caption= "Dunnett test results comparing T0 and pre incubations to all")
  ####

  aanova
  
  diffres
  
  LastRES_aov
  
  all_aov
  
  all_aov2
  
  Dunnett_label_all


  list("Respiration statistics: anova(lme(Res ~ JD2 + Inc_temp + pre_inc,random = ~1|Sample_ID))"= aanova,
       diffres = diffres,
       LastRES_aov=LastRES_aov,
       "ANOVA Nutrients and Microbial biomass: aov(conc ~ pre_inc*Inc_temp)" = all_aov2,
       all_aov=all_aov,
       Dunnett_label_all=Dunnett_label_all
       
  )
  
}

