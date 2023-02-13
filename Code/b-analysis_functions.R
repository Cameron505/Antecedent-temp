plot_respiration = function(respiration_processed){
  
  fit_lm = function(dat){
    
    a = lm(val ~ JD2, data = dat)
    broom::tidy(a) %>% 
      dplyr::select(`p.value`) %>% 
      mutate(asterisk = case_when(`p.value` <= 0.05 ~ "*"))
    
  }
  res_lm = 
    respiration_processed %>% 
    group_by(Inc_temp,pre_inc) %>% 
    do(fit_lm(.)) #Not used
  
  
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
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
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
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
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
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
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
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
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
    do(fit_aov(.)) %>% 
    mutate(pre_inc = "-2") %>% 
    # factor the Inc_temp so they can line up in the graph
    mutate(Inc_temp = factor(Inc_temp, levels=c("Pre","-2","-6","2","4","6","8","10")))
  
  
  gg_NH4 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=NH4, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= "dodge")+
    geom_text(data = all_aov %>% filter(analyte == "NH4"), aes(y = 5, label = asterisk))+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
    labs(x = "Incubation temperature", 
         y = bquote('Ammonium ('*mu*'g '*NH[4]^"+"~-N~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    ggtitle("Ammonium")
  
  gg_NO3 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=NO3, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= "dodge")+
    geom_text(data = all_aov %>% filter(analyte == "NO3"), aes(y = 30, label = asterisk))+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
    labs(x = "Incubation temperature", 
         y = bquote('Nitrate ('*mu*'g '*NO[3]^"-"~-N~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    ggtitle("Nitrate")
  
  gg_TFPA =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=TFPA, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= "dodge")+
    geom_text(data = all_aov %>% filter(analyte == "NO3"), aes(y = 130, label = asterisk))+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
    labs(x = "Incubation temperature", 
         y = bquote('Total free primary amines-Leucine equiv. (nMol' ~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    ggtitle("TFPA")
  
  gg_TRS =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=TRS, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= "dodge")+
    geom_text(data = all_aov %>% filter(analyte == "TRS"), aes(y = 0.5, label = asterisk))+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
    labs(x = "Incubation temperature", 
         y = bquote('Total reducing sugars-glucose equiv. ('*mu*'Mol' ~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    ggtitle("TRS")
  
  gg_PO4 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=PO4, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= "dodge")+
    geom_text(data = all_aov %>% filter(analyte == "PO4"), aes(y = 0.58, label = asterisk))+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
    labs(x = "Incubation temperature", 
         y = bquote('Phosphate ('*mu*'g '*PO[4]^"3-"~-P~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    ggtitle("Phosphate")
  
  
  list("Ammonium" = gg_NH4,
       "Nitrate" = gg_NO3,
       "Total free primary amines" = gg_TFPA,
       "Phosphate" = gg_PO4,
       "Total reducing sugars" = gg_TRS
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
    do(fit_aov(.)) %>% 
    mutate(pre_inc = "-2") %>% 
    # factor the Inc_temp so they can line up in the graph
    mutate(Inc_temp = factor(Inc_temp, levels=c("Pre","-2","-6","2","4","6","8","10")))
  
  
   gg_MBC =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=MBC, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= "dodge")+
    geom_text(data = all_aov %>% filter(analyte == "MBC"), aes(y = 875, label = asterisk))+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
    labs(x = "Incubation temperature", 
         y = bquote('Microbial biomass ('*mu*'g C'~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    ggtitle("Microbial biomass carbon")
  
  gg_MBN =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("-2","-6"))) %>%
    ggplot(aes(x=Inc_temp, y=MBN, fill=pre_inc))+
    stat_summary(fun = mean,geom = "bar",size = 2, position= "dodge") +
    stat_summary(fun.data = mean_se, geom = "errorbar", position= "dodge")+
    geom_text(data = all_aov %>% filter(analyte == "MBN"), aes(y = 125, label = asterisk))+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette)+
    labs(x = "Incubation temperature", 
         y = bquote('Microbial biomass ('*mu*'g N'~g^-1 ~ dry ~ soil*')'))+
    labs(color='pre_inc temp') +
    ggtitle("Microbial biomass Nitrogen")
  
  list("Microbial biomass carbon" = gg_MBC,
       "Microbial biomass nitrogen" = gg_MBN
       
  )
  
}

