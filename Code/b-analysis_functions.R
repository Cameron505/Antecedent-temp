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
    scale_y_continuous(expand=c(0,0),oob=rescale_none)+
    ylab(expression(paste( "Respiration (",mu,"g-C",day^-1, ")")))+
    facet_wrap(~Inc_temp,labeller = labeller(Inc_temp =inc.lab ), nrow=1)+
    theme_light()+
    scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette2)+
    ylab(expression(paste( "Respiration (",mu,"g-C ",hour^-1, ")")))+
    xlab("Incubation day")+
    labs(color='Pre-incubation') +
    ggtitle("Soil respiration")+
    theme_CKM()
  
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
    scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette2)+
    ylab(expression(paste( "Respiration (",mu,"g-C)")))+
    xlab("Incubation day")+
    labs(color='Pre-incubation') +
    ggtitle("Cumulative soil respiration")+
    theme_CKM()
  
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
    scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette2)+
    ylab(expression(paste( "Respiration (",mu,"g-C ",hour^-1, ")")))+
    xlab("Incubation day")+
    labs(color='Pre-incubation') +
    ggtitle("Average soil respiration")+
    theme_CKM()
  
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
    scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette2)+
    ylab(expression(paste( "Respiration (",mu,"g-C)")))+
    xlab("Incubation day")+
    labs(color='Pre-incubation') +
    ggtitle("Average cumulative soil respiration")+
    theme_CKM()
  
  
  
  LASTRES<- respiration_processed %>%
    filter(JD2==5)
  fit_aov = function(LASTRES){
    
    a = aov(val ~ pre_inc, data = LASTRES)
    broom::tidy(a) %>% 
      filter(term == "pre_inc") %>% 
      dplyr::select(`p.value`, statistic) %>% 
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
    ggplot(aes(x = Inc_temp, y = val, color = pre_inc, group = pre_inc, fill = pre_inc))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 width=0.5,
                 aes(group = interaction(Inc_temp, pre_inc)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    guides(color=guide_legend(title="Pre-Incubation "),fill="none")+
    scale_y_continuous(expand=c(0,0),limits=c(50,375),oob=rescale_none)+
    geom_text(data = rescum_aov, aes(y = 350, label = asterisk), size=6, color="black")+
    theme_light()+
    scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette2,labels=c('-2 °C', '-6 °C'))+
    ylab(expression(paste( "Total respired C (",mu,"g-C)")))+
    xlab("Incubation temp. (°C)")+
    labs(color='Pre-incubation') +
    ggtitle("Cumulative respiration")+
    theme_CKM()
  
  respiration_legend = get_legend(gg_CumresLastday+ guides(color = guide_legend(nrow = 1)) +
                                 theme(legend.position = "bottom"))
S<-ggplot() + theme_void()
SS<-plot_grid(gg_CumresLastday,S,
          nrow=1)
  gg_Ncombine= plot_grid(
    gg_res + theme(legend.position="none"),
    gg_CumresLastday,
    align="none",
    rel_widths= c(2,1),
    labels = c("A", "B"),
    #label_x= 0.1,
    hjust = -1,
    vjust= 1,
    ncol = 1
  )
  
  gg_N_Legend=gg_Ncombine
  
  
  
  Check<-respiration_processed %>%
    filter(JD2==min(JD2)) %>%
    group_by(pre_inc)%>%
    summarise(mean_value = mean(Res, na.rm = TRUE)*90)
  
  
  
  
  list(#"Respiration" = gg_res,
        gg_N_Legend=gg_N_Legend,
       "Average Respiration" = gg_Avgres,
       "Cumulative Respiration" = gg_cumres,
       "Average Cumulative Respiration" = gg_Avgcumres
       )
  
}

plot_nutrients = function(nutrients_data){
  
  summary(nutrients_data)
  
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

Check<-nutrients_data_long %>%
  filter(analyte=="TRS", Incubation.ID=="Pre")%>%
  group_by(pre_inc)%>%
  select(-ID)%>%
  mutate(ID=c(1,2,3))%>%
  pivot_wider(names_from = pre_inc, values_from = conc)


Check2<-Check%>%
  mutate(DIF=`-6`-`-2`)%>%
  summarize(mean2= mean(`-2`)*180, mean6= mean(`-6`)*180, meanD=mean(DIF)*180)






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
  
  
 RDS<- nutrients_data%>%
    select(Inc_temp,pre_inc,TRS)%>%
   group_by(Inc_temp)%>%
    summarize(M=mean(TRS, na.rm = T), SD= sd(TRS))
  
  gg_NH4 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x = Inc_temp, y = NH4, color = pre_inc, group = pre_inc, fill = pre_inc))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2, width= 0.5,
                 aes(group = interaction(Inc_temp, pre_inc)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    guides(color=guide_legend(title="Pre-incubation"),fill="none")+
    geom_vline(xintercept=2.5, linetype="dotted", color= "black", size= 1.5)+
    geom_text(data = all_aov %>% filter(analyte == "NH4"), aes(y = 5, label = asterisk), size=8, color="black")+
    theme_light()+
    scale_colour_manual(values=cbPalette, breaks=c("T0","-2","-6"), labels=c("Time zero","Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation temp. (°C)", 
         y = bquote(' '*NH[4]^"+"~-N~'('*mu*'g '*g^-1~ dry ~ soil*')'))+
    labs(color='Pre-incubation') +
    ggtitle("Ammonium")+
    theme_CKM4()
  
  gg_NH4_2 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x = Inc_temp, y = NH4, color = pre_inc, group = pre_inc, fill = pre_inc))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2, width= 0.5,
                 aes(group = interaction(Inc_temp, pre_inc)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    geom_vline(xintercept=2.5, linetype="dotted", color= "black", size= 1.5)+
    guides(color=guide_legend(title="Pre-incubation"),fill="none")+
    stat_smooth(method= "lm")+
    stat_cor(label.y=c(5.3,5.8), size=2)+
    stat_regline_equation(label.y=c(5.5,6.1), size=2)+
    theme_light()+
    scale_colour_manual(values=cbPalette, breaks=c("T0","-2","-6"), labels=c("Time zero","Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation temp. (°C)", 
         y = bquote(' '*NH[4]^"+"~-N~'('*mu*'g '*g^-1~ dry ~ soil*')'))+
    labs(color='Pre-incubation') +
    ggtitle("Ammonium")+
    theme_CKM4()

  
  #Calulating P-value between lines
  nutrients_data2<-nutrients_data%>%
    mutate(Inc_temp = replace(Inc_temp, Inc_temp == "Pre", "0"),
           Inc_temp = as.numeric(as.character(Inc_temp)))
    
  lm1 = lm(NH4 ~ Inc_temp,data=subset(nutrients_data2,nutrients_data2$pre_inc=="-6"))
  lm2 = lm(NH4 ~ Inc_temp,data=subset(nutrients_data2,nutrients_data2$pre_inc=="-2"))
  b1 <- summary(lm1)$coefficients[2,1]
  se1 <- summary(lm1)$coefficients[2,2]
  b2 <- summary(lm2)$coefficients[2,1]
  se2 <- summary(lm2)$coefficients[2,2]
  p_value_NH4 = 2*pnorm(-abs(compare.coeff(b1,se1,b2,se2)))
  p_value_NH4 
  
  
  gg_NO3 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x = Inc_temp, y = NO3, color = pre_inc, group = pre_inc, fill = pre_inc))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2, width= 0.5,
                 aes(group = interaction(Inc_temp, pre_inc)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    guides(color=guide_legend(title="Pre-incubation"),fill="none")+
    geom_vline(xintercept=2.5, linetype="dotted", color= "black", size= 1.5)+
    geom_text(data = all_aov %>% filter(analyte == "NO3"), aes(y = 30, label = asterisk), size=8, color="black")+
    theme_light()+
    scale_colour_manual(values=cbPalette, breaks=c("T0","-2","-6"), labels=c("Time zero","Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation temp. (°C)", 
         y = bquote(' '*NO[3]^"-"~-N~'('*mu*'g '~g^-1 ~ dry ~ soil*')'))+
    labs(color='Pre-incubation') +
    ggtitle("Nitrate")+
    theme_CKM4()
  #y = bquote('Nitrate ('*mu*'g '*NO[3]^"-"~-N~g^-1 ~ dry ~ soil*')'))+
  
  gg_NO3_2 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x = Inc_temp, y = NO3, color = pre_inc, group = pre_inc, fill = pre_inc))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2, width= 0.5,
                 aes(group = interaction(Inc_temp, pre_inc)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    guides(color=guide_legend(title="Pre-incubation"),fill="none")+
    geom_vline(xintercept=2.5, linetype="dotted", color= "black", size= 1.5)+
    stat_smooth(method= "lm")+
    stat_cor(label.y=c(33,35), size=2)+
    stat_regline_equation(label.y=c(34,36), size=2)+
    theme_light()+
    scale_colour_manual(values=cbPalette, breaks=c("T0","-2","-6"), labels=c("Time zero","Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation temp. (°C)", 
         y = bquote(' '*NO[3]^"-"~-N~'('*mu*'g '~g^-1 ~ dry ~ soil*')'))+
    labs(color='Pre-incubation') +
    ggtitle("Nitrate")+
    theme_CKM4()
  #Calulating P-value between lines
  lm1 = lm(NO3 ~ Inc_temp,data=subset(nutrients_data2,nutrients_data2$pre_inc=="-6"))
  lm2 = lm(NO3 ~ Inc_temp,data=subset(nutrients_data2,nutrients_data2$pre_inc=="-2"))
  b1 <- summary(lm1)$coefficients[2,1]
  se1 <- summary(lm1)$coefficients[2,2]
  b2 <- summary(lm2)$coefficients[2,1]
  se2 <- summary(lm2)$coefficients[2,2]
  p_value_NO3 = 2*pnorm(-abs(compare.coeff(b1,se1,b2,se2)))
  p_value_NO3 
  
  gg_TFPA =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x = Inc_temp, y = TFPA, color = pre_inc, group = pre_inc, fill = pre_inc))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2, width= 0.5,
                 aes(group = interaction(Inc_temp, pre_inc)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    guides(color=guide_legend(title="Pre-incubation"),fill="none")+
    geom_vline(xintercept=2.5, linetype="dotted", color= "black", size= 1.5)+
    geom_text(data = all_aov %>% filter(analyte == "TFPA"), aes(y = 130, label = asterisk), size=8, color="black")+
    theme_light()+
    scale_colour_manual(values=cbPalette, breaks=c("T0","-2","-6"), labels=c("Time zero","Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation temp. (°C)", 
         y = bquote(atop('TFPA-Leucine equiv.',paste('(nMol' ~g^-1 ~ dry ~ soil*')'))))+
    labs(color='Pre-incubation') +
    ggtitle("Total free primary amines")+
    theme_CKM4()
  #y = bquote(atop('Total free primary amines-Leucine equiv.',paste('(nMol' ~g^-1 ~ dry ~ soil*')'))))+
  
  gg_TFPA_2 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x = Inc_temp, y = TFPA, color = pre_inc, group = pre_inc, fill = pre_inc))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2, width= 0.5,
                 aes(group = interaction(Inc_temp, pre_inc)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    guides(color=guide_legend(title="Pre-incubation"),fill="none")+
    geom_vline(xintercept=2.5, linetype="dotted", color= "black", size= 1.5)+
    stat_smooth(method= "lm")+
    stat_cor(label.y=c(130,138), size=2)+
    stat_regline_equation(label.y=c(134,142), size=2)+
    theme_light()+
    scale_colour_manual(values=cbPalette, breaks=c("T0","-2","-6"), labels=c("Time zero","Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation temp. (°C)", 
         y = bquote(atop('TFPA-Leucine equiv.',paste('(nMol' ~g^-1 ~ dry ~ soil*')'))))+
    labs(color='Pre-incubation') +
    ggtitle("Total free primary amines")+
    theme_CKM4()
  
  gg_TRS =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x = Inc_temp, y = TRS, color = pre_inc, group = pre_inc, fill = pre_inc))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2, width= 0.5,
                 aes(group = interaction(Inc_temp, pre_inc)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    guides(color=guide_legend(title="Pre-incubation"),fill="none")+
    geom_vline(xintercept=2.5, linetype="dotted", color= "black", size= 1.5)+
    geom_text(data = all_aov %>% filter(analyte == "TRS"), aes(y = 0.54, label = asterisk), size=8, color="black")+
    theme_light()+
    scale_colour_manual(values=cbPalette, breaks=c("T0","-2","-6"), labels=c("Time zero","Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation temp. (°C)", 
         y = bquote('TRS-glucose equiv. ('*mu*'Mol' ~g^-1 ~ dry ~ soil*')'))+
    labs(color='Pre-incubation') +
    ggtitle("Total reducing sugars")+
    theme_CKM5()+
    theme(legend.position = c(0.8, 0.65))
  #y = bquote('Total reducing sugars-glucose equiv. ('*mu*'Mol' ~g^-1 ~ dry ~ soil*')'))+
  
  
  gg_TRS_2 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x = Inc_temp, y = TRS, color = pre_inc, group = pre_inc, fill = pre_inc))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2, width= 0.5,
                 aes(group = interaction(Inc_temp, pre_inc)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    guides(color=guide_legend(title="Pre-incubation"),fill="none")+
    geom_vline(xintercept=2.5, linetype="dotted", color= "black", size= 1.5)+
    stat_smooth(method= "lm")+
    stat_cor(label.y=c(0.55,0.61), size=2)+
    stat_regline_equation(label.y=c(0.58,0.64), size=2)+
    theme_light()+
    scale_colour_manual(values=cbPalette, breaks=c("T0","-2","-6"), labels=c("Time zero","Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation temp. (°C)", 
         y = bquote('TRS-glucose equiv. ('*mu*'Mol' ~g^-1 ~ dry ~ soil*')'))+
    labs(color='Pre-incubation') +
    ggtitle("Total reducing sugars")+
    theme_CKM5()
  
  #Calulating P-value between lines
  lm1 = lm(TRS ~ Inc_temp,data=subset(nutrients_data2,nutrients_data2$pre_inc=="-6"))
  lm2 = lm(TRS ~ Inc_temp,data=subset(nutrients_data2,nutrients_data2$pre_inc=="-2"))
  b1 <- summary(lm1)$coefficients[2,1]
  se1 <- summary(lm1)$coefficients[2,2]
  b2 <- summary(lm2)$coefficients[2,1]
  se2 <- summary(lm2)$coefficients[2,2]
  p_value_TRS = 2*pnorm(-abs(compare.coeff(b1,se1,b2,se2)))
  p_value_TRS
  
  gg_PO4 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x = Inc_temp, y = PO4, color = pre_inc, group = pre_inc, fill = pre_inc))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2, width= 0.5,
                 aes(group = interaction(Inc_temp, pre_inc)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    guides(color=guide_legend(title="Pre-incubation"),fill="none")+
    geom_vline(xintercept=2.5, linetype="dotted", color= "black", size= 1.5)+
    geom_text(data = all_aov %>% filter(analyte == "PO4"), aes(y = 0.54, label = asterisk), size=8, color="black")+
    theme_light()+
    scale_colour_manual(values=cbPalette, breaks=c("T0","-2","-6"), labels=c("Time zero","Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation temp. (°C)", 
         y = bquote(' '*PO[4]^"3-"~-P~'('*mu*'g '~g^-1 ~ dry ~ soil*')'))+
    labs(color='Pre-incubation') +
    ggtitle("Phosphate")+
    theme_CKM4()
  #y = bquote('Phosphate ('*mu*'g '*PO[4]^"3-"~-P~g^-1 ~ dry ~ soil*')'))+
  gg_PO4_2 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x = Inc_temp, y = PO4, color = pre_inc, group = pre_inc, fill = pre_inc))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2, width= 0.5,
                 aes(group = interaction(Inc_temp, pre_inc)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    guides(color=guide_legend(title="Pre-incubation"),fill="none")+
    geom_vline(xintercept=2.5, linetype="dotted", color= "black", size= 1.5)+
    theme_light()+
    scale_colour_manual(values=cbPalette, breaks=c("T0","-2","-6"), labels=c("Time zero","Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    stat_smooth(method= "lm")+
    stat_cor(label.y=c(0.55,0.61), size=2)+
    stat_regline_equation(label.y=c(0.58,0.64), size=2)+
    labs(x = "Incubation temp. (°C)", 
         y = bquote(' '*PO[4]^"3-"~-P~'('*mu*'g '~g^-1 ~ dry ~ soil*')'))+
    labs(color='Pre-incubation') +
    ggtitle("Phosphate")+
    theme_CKM4()
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
    label_x= 0.09,
    hjust = -1,
    nrow = 2
  )
gg_N_Legend=plot_grid(gg_Ncombine,Nutrient_legend, ncol=1, rel_heights =c(1,0.1))
  
  list(#"Ammonium" = gg_NH4,
       #"Nitrate" = gg_NO3,
       #"Total free primary amines" = gg_TFPA,
       #"Phosphate" = gg_PO4,
       "Total reducing sugars" = gg_TRS,
       "Nutrient combined"=gg_N_Legend,
       gg_NH4_2=gg_NH4_2,
       gg_NO3_2=gg_NO3_2,
       gg_TFPA_2=gg_TFPA_2,
       gg_TRS_2=gg_TRS_2,
       gg_PO4_2=gg_PO4_2
       
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
    
  nutrients_data2<-nutrients_data%>%
    mutate(Inc_temp = replace(Inc_temp, Inc_temp == "Pre", "0"),
           Inc_temp = as.numeric(as.character(Inc_temp)))
  
  
  nutrients_data[nutrients_data == "none"] <- "T0"  
  
   gg_MBC =
    nutrients_data %>%
     mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
            pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
     ggplot(aes(x = Inc_temp, y = MBC, color = pre_inc, group = pre_inc, fill = pre_inc))+
     geom_boxplot(show.legend = F, 
                  outlier.colour = NULL,
                  outlier.fill = NULL,
                  position = position_dodge(width = 0.6), 
                  alpha = 0.2,
                  width=0.5,
                  aes(group = interaction(Inc_temp, pre_inc)))+
     geom_point(position = position_dodge(width = 0.6), size = 3)+
     guides(color=guide_legend(title="Pre-incubation"),fill="none")+
     geom_vline(xintercept=2.5, linetype="dotted", color= "black", size= 1.5)+
    geom_text(data = all_aov %>% filter(analyte == "MBC"), aes(y = 850, label = asterisk), size=8, color="black")+
    theme_light()+
     scale_colour_manual(values=cbPalette, breaks=c("T0","-2","-6"), labels=c("Time zero","Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation temp. (°C)", 
         y = bquote(atop('Microbial biomass', paste('('*mu*'g C'~g^-1~ dry ~ soil*')'))))+
    labs(color='Pre-incubation') +
    ggtitle("Microbial biomass C")+
     theme_CKM()
   #y = bquote(atop('Microbial biomass', paste('('*mu*'g C'~g^-1 ~ dry ~ soil*')'))))+
   
   
   
   
   
   
  gg_MBN =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x = Inc_temp, y = MBN, color = pre_inc, group = pre_inc, fill = pre_inc))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 width=0.5,
                 aes(group = interaction(Inc_temp, pre_inc)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    guides(color=guide_legend(title="Pre-incubation"),fill="none")+
    geom_vline(xintercept=2.5, linetype="dotted", color= "black", size= 1.5)+
    geom_text(data = all_aov %>% filter(analyte == "MBN"), aes(y = 125, label = asterisk), size=8, color="black")+
    theme_light()+
    scale_colour_manual(values=cbPalette, breaks=c("T0","-2","-6"), labels=c("Time zero","Mild frozen", "Moderate frozen"))+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation temp. (°C)", 
         y = bquote(atop('Microbial biomass',paste( '('*mu*'g N'~g^-1~ dry ~ soil*')'))))+
    labs(color='Pre-incubation') +
    ggtitle("Microbial biomass N")+
    theme_CKM()
  #y = bquote(atop('Microbial biomass',paste( '('*mu*'g N'~g^-1 ~ dry ~ soil*')'))))+
  
  
  
  
  
  
  
  gg_MBC_2 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x = Inc_temp, y = MBC, color = pre_inc, group = pre_inc, fill = pre_inc))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(Inc_temp, pre_inc)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    guides(color=guide_legend(title="Pre-Incubation (°C)"),fill="none")+
    stat_smooth(method= "lm")+
    stat_cor(label.y=c(810,830), size=2)+
    stat_regline_equation(label.y=c(820,840), size=2)+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation temp. (°C)", 
         y = bquote(atop('Microbial biomass', paste('('*mu*'g C'~g^-1~ dry ~ soil*')'))))+
    labs(color='Pre-incubation') +
    ggtitle("Microbial biomass C")+
    theme_CKM()
  #y = bquote(atop('Microbial biomass', paste('('*mu*'g C'~g^-1 ~ dry ~ soil*')'))))+
  
  #Calulating P-value between lines
  lm1 = lm(MBC ~ Inc_temp,data=subset(nutrients_data2,nutrients_data2$pre_inc=="-6"))
  lm2 = lm(MBC ~ Inc_temp,data=subset(nutrients_data2,nutrients_data2$pre_inc=="-2"))
  b1 <- summary(lm1)$coefficients[2,1]
  se1 <- summary(lm1)$coefficients[2,2]
  b2 <- summary(lm2)$coefficients[2,1]
  se2 <- summary(lm2)$coefficients[2,2]
  p_value_MBC = 2*pnorm(-abs(compare.coeff(b1,se1,b2,se2)))
  p_value_MBC 
  
  
  
  gg_MBN_2 =
    nutrients_data %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("T0","Pre","-2","-6","2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("T0","-2","-6"))) %>%
    ggplot(aes(x = Inc_temp, y = MBN, color = pre_inc, group = pre_inc, fill = pre_inc))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(Inc_temp, pre_inc)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    guides(color=guide_legend(title="Pre-Incubation (°C)"),fill="none")+
    stat_smooth(method= "lm")+
    stat_cor(label.y=c(130,140), size=2)+
    stat_regline_equation(label.y=c(135,145), size=2)+
    theme_light()+
    scale_colour_manual(values=cbPalette)+
    scale_fill_manual(values=cbPalette,labels=c('T0','-2 °C', '-6 °C'))+
    labs(x = "Incubation temp. (°C)", 
         y = bquote(atop('Microbial biomass',paste( '('*mu*'g N'~g^-1~ dry ~ soil*')'))))+
    labs(color='Pre-incubation') +
    ggtitle("Microbial biomass N")+
    theme_CKM()
  #y = bquote(atop('Microbial biomass',paste( '('*mu*'g N'~g^-1 ~ dry ~ soil*')'))))+
  
  #Calulating P-value between lines
  lm1 = lm(MBN ~ Inc_temp,data=subset(nutrients_data2,nutrients_data2$pre_inc=="-6"))
  lm2 = lm(MBN ~ Inc_temp,data=subset(nutrients_data2,nutrients_data2$pre_inc=="-2"))
  b1 <- summary(lm1)$coefficients[2,1]
  se1 <- summary(lm1)$coefficients[2,2]
  b2 <- summary(lm2)$coefficients[2,1]
  se2 <- summary(lm2)$coefficients[2,2]
  p_value_MBN = 2*pnorm(-abs(compare.coeff(b1,se1,b2,se2)))
  p_value_MBN 
    
    
  biomass_legend = get_legend(gg_MBC+ guides(color = guide_legend(nrow = 1)) +
                                 theme(legend.position = "bottom"))
  gg_Biomasscombine= plot_grid(
    gg_MBC + theme(legend.position="none"),
    gg_MBN + theme(legend.position="none"),
    align = 'vh',
    labels = c("A", "B", "C"),
    label_x= 0.1,
    hjust = -1,
    ncol = 1
  )
  gg_Biomass_Legend=plot_grid(gg_Biomasscombine,biomass_legend, ncol=1, rel_heights =c(1,0.05))
  
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
    knitr::kable("simple", caption = "ANOVA")
  
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
  knitr::kable("simple", caption = "Extraction ANOVA results")
  
  
 all_aov3 = 
    nutrients_data_long %>% 
    group_by(analyte) %>% 
    filter(Incubation.ID!=c("Pre","Pre-Pre"))%>%
    do(fit_aov2(.)) %>%
    filter(analyte %in% c("TRS","NH4","NO3","PO4","TFPA"))%>%
    knitr::kable("simple", caption = "Extraction ANOVA results nutrients and TRS")
  
  
  all_aov4 = 
    nutrients_data_long %>% 
    group_by(analyte) %>% 
    filter(Incubation.ID!=c("Pre","Pre-Pre"))%>%
    do(fit_aov2(.)) %>%
    filter(analyte %in% c("MBC","","MBN"))%>%
    knitr::kable("simple", caption = "Extraction ANOVA results microbial biomass")
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
       Dunnett_label_all=Dunnett_label_all,
       all_aov3=all_aov3,
       all_aov4=all_aov4
       
  )
  
}

### GC

plot_GC = function(GC_processed){
  
  
  
  
  GC_data_composite = GC_processed$metab_final$e_data %>%
    pivot_longer(cols=Wein_1_B_2_3:Wein_36_Pre_2_1, names_to= "Sample.ID")%>%
    left_join(GC_processed$metab_final$f_data, by= "Sample.ID")%>%
    left_join(GC_processed$emeta, by="Metabolites")
  
  
  
  
  
  statResAnova <- imd_anova(GC_processed$metab_final, test_method = "anova")
  
  StatsGC<-statResAnova %>%
    select(1:25,100,111,117,124,130,154,166,177,183,190,196,220)%>%
    knitr::kable()
  
  
  
  
  fit_aov = function(LASTRES){
    
    a = aov(value ~ pre, data = LASTRES)
    broom::tidy(a) %>% 
      filter(term == "pre") 
    
  }  
  fit_lm = function(LASTRES){
    
    a = lm(value ~ inc, data = LASTRES)
    broom::tidy(a)  
    
  }  
  
  GC_aov = 
    GC_data_composite %>% 
    group_by(inc,Metabolites) %>% 
    filter(pre !="none")%>%
    na.omit()%>%
    do(fit_aov(.)) %>%
    # factor the Inc_temp so they can line up in the graph
    mutate(inc = factor(inc, levels=c("pre","2","4","6","8","10")))%>%
    dplyr::select(`p.value`,'Metabolites','inc')
  
  GC_data_composite2<-GC_data_composite%>%
    mutate(inc = replace(inc, inc == "pre", "0"),
           inc = as.numeric(as.character(inc)))  
  
  
  GC_lm = 
    GC_data_composite2 %>% 
    group_by(pre,Metabolites) %>% 
    do(fit_lm(.)) %>%
    filter(term =="inc")%>%
    # factor the Inc_temp so they can line up in the graph
    dplyr::select(`p.value`,'Metabolites','pre')
  
  
  Means_all<-GC_data_composite2 %>%
    mutate( Known=case_when(grepl("Unknown", Metabolites) ~ "Unkown"))%>%
    replace_na(list(Known="Known"))%>%
    left_join(GC_lm, by= c("Metabolites","pre"))
  
  AAA<-Means_all%>%
    filter(Known== "Known")%>%
    distinct(Metabolites)%>%
    mutate(n= count(Metabolites))%>%
    summarise(S=sum(n$freq))
  
  AAA2<-Means_all%>%
    filter(Known== "Unkown")%>%
    distinct(Metabolites)%>%
    mutate(n= count(Metabolites))%>%
    summarise(S=sum(n$freq))
  
  AAA
  AAA2
  AAA/(AAA+AAA2)
  
  Means<- GC_data_composite %>%
    filter(!row_number() %in% c(2959:11390))
  Means_unknown<- GC_data_composite %>%
    filter(!row_number() %in% c(1:2958))
  
  
  
  GC_Saccharides = Means%>%
    filter(Main.class %in% c("Oligosaccharides","Monosaccharides","Disaccharides"))
  
  
    GC_all<-Means_all%>%
    mutate(inc = factor(inc, levels=c("0","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    ggplot(aes(x = inc, y = value, color = pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(inc, pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
      facet_trelliscope(~ Metabolites , nrow = 2, ncol = 7, width = 300, path = "rmarkdown_files", name = "GC compounds")+
    theme_light()+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    ggtitle("GC compounds")
  
  GC<-Means%>%
    mutate(inc = factor(inc, levels=c("pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    ggplot(aes(x = inc, y = value, color = pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(inc, pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    facet_wrap(~Metabolites, scales="free")+
    theme_light()+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    ggtitle("GC known compounds")
  
  GC_sac<-GC_Saccharides%>%
    mutate(inc = factor(inc, levels=c("pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    ggplot(aes(x = inc, y = value, color = pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(inc, pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    facet_wrap(~Metabolites, scales="free")+
    theme_light()+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    ggtitle("GC Saccharides only")
  
  
  GC_unkown<-Means_unknown%>%
    mutate(inc = factor(inc, levels=c("pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    ggplot(aes(x = inc, y = value, color = pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(inc, pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    facet_wrap(~Metabolites, scales="free")+
    theme_light()+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    ggtitle("GC unknown compounds")
  
  
  
  Stat_plot<-plot(statResAnova)
  
  
  list(Stat_plot = Stat_plot,
       GC = GC,
       GC_sac=GC_sac,
       GC_unkown=GC_unkown,
       StatsGC=StatsGC
       
  )
  
}

plot_GC_PCA = function(GC_PCA){
  
  permanova_GC_all = 
    adonis2(GC_PCA$GC_short %>% dplyr::select("Alcohols and polyols":Terpenoid) ~ pre * inc, 
            data = GC_PCA$GC_short) %>%
    knitr::kable(caption="Permanova results all by Main class")
  permanova_GC_all2 = 
    adonis2(GC_PCA$GC_short %>% dplyr::select("Oligosaccharides","Monosaccharides","Disaccharides") ~ pre * inc, 
            data = GC_PCA$GC_short, na.rm=T) %>%
    knitr::kable(caption="Permanova results saccharides")
  
  
  adonis2(GC_PCA$GC_data_composite_sig %>% dplyr::select(`2-phenylacetamide`:`Unknown 174`) ~ pre * inc, 
          data = GC_PCA$GC_data_composite_sig)
  Scale_inc= scale_color_manual(values=cbPalette2,limits=c("Pre","2","4","6","8","10"))
  
  
  gg_pca_pre_Sig=
    ggbiplot(GC_PCA$pca_GC_sig,obs.scale = 1, var.scale = 1,
             groups = as.character(GC_PCA$grp_sig$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0, varname.adjust = 1, varname.size = 4) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    labs(shape="",
         title = "GC-significant metabolites")+
    scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    guides(color=guide_legend(title="Pre-incubation"),fill="none", alpha=F)+
    theme_CKM3()
  
  
  gg_pca_inc_Sig=
    ggbiplot(GC_PCA$pca_GC_sig,obs.scale = 1, var.scale = 1,
             groups = as.character(GC_PCA$grp_sig$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(shape=as.character(GC_PCA$grp_sig$pre),
                   color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    labs(shape="",
         title = "GC-significant metabolites (ANOVA)",
         subtitle = "separation by inc")+
    guides(color=guide_legend(title="Pre-incubation"),fill="none", alpha=F)+
    scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    Scale_inc+
    theme_CKM()
  
  
  
  
  gg_pca_pre1=
    ggbiplot(GC_PCA$pca_GC,obs.scale = 1, var.scale = 1,
             groups = as.character(GC_PCA$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "GC-all samples",
         subtitle = "separation by pre")+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    guides(color=guide_legend(title="Pre-incubation"),fill="none", alpha=F)+
    Scale_inc+
    theme_CKM()
  
  gg_pca_pre2=
    ggbiplot(GC_PCA$pca_GC2,obs.scale = 1, var.scale = 1,
             groups = as.character(GC_PCA$grp2$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "GC-saccharides only",
         subtitle = "separation by pre")+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    guides(color=guide_legend(title="Pre-incubation"),fill="none", alpha=F)+
    theme_CKM()
  
  
  gg_pca_inc1=
    ggbiplot(GC_PCA$pca_GC,obs.scale = 1, var.scale = 1,
             groups = as.character(GC_PCA$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(shape=as.character(GC_PCA$grp$pre),
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "GC-all samples",
         subtitle = "separation by inc")+
    guides(color=guide_legend(title="Pre-incubation"),fill="none", alpha=F)+
    Scale_inc+
    theme_CKM()
  
  gg_pca_inc2=
    ggbiplot(GC_PCA$pca_GC2,obs.scale = 1, var.scale = 1,
             groups = as.character(GC_PCA$grp2$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(shape=as.character(GC_PCA$grp$pre),
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "GC-saccharides only",
         subtitle = "separation by inc")+
    guides(color=guide_legend(title="Pre-incubation"),fill="none", alpha=F)+
    Scale_inc+
    theme_CKM()
  
  

  
  
 
  
  list( gg_pca_pre1=gg_pca_pre1,
        gg_pca_inc1=gg_pca_inc1,
        permanova_GC_all= permanova_GC_all,
        gg_pca_pre2=gg_pca_pre2,
        gg_pca_inc2=gg_pca_inc2,
        permanova_GC_all2= permanova_GC_all2,
        gg_pca_pre_Sig=gg_pca_pre_Sig,
        gg_pca_inc_Sig=gg_pca_inc_Sig
       
  )
  
}

plot_GC_PLS= function(GC_PCA){
  library(ropls)
  ##Data reorganization
GC_PLS_DATA<- GC_PCA$GC_short%>%
  select(`Alcohols and polyols`:unknown)
  
  
  
  nameH<-c(1:34)
  GC_PLS_DATA<- GC_PCA$GC_short%>%
    select(`Alcohols and polyols`:unknown)%>%
    as.data.frame()
  rownames(GC_PLS_DATA) <- nameH
  
  GC_PLS_Meta<- GC_PCA$GC_short%>%
    select(Sample.ID:inc)%>%
    as.data.frame()%>%
    mutate(inc=as.factor(inc),pre=as.factor(pre))
  rownames(GC_PLS_DATA) <- nameH
  
  
  
  ##Polar PLS-DA
  
  PLS_DA_all_inc = opls(GC_PLS_DATA,GC_PLS_Meta[, "inc"],predI = 2)
  PLS_DA_all_pre = opls(GC_PLS_DATA,GC_PLS_Meta[, "pre"],predI = 2)
  OPLS_DA_all_pre = opls(GC_PLS_DATA,GC_PLS_Meta[, "pre"],predI = 1, orthoI = 1)
  
  plot(OPLS_DA_all_pre, typeVc = "x-score")
  
  ggplot_PLS= function(PLS_DA_P6,Meta_PLS_P6_1){
    DF<-data.frame(PLS_DA_P6@scoreMN)
    DF2<-data.frame(Meta_PLS_P6_1)
    DF$ID<-rownames(DF)
    DF2$ID<-rownames(DF2)
    DFT<-DF%>%
      left_join(DF2, by="ID")
    
    DFT%>%
      ggplot(aes(x=p1,y=p2,color=DFT[,4]))+
      stat_ellipse()+
      geom_point(aes())+
      theme_CKM()
  
  }

  ggplot_OPLS= function(OPLS_DA_all_pre,LC_PLS_Meta){
    DF<-data.frame(OPLS_DA_all_pre@scoreMN,OPLS_DA_all_pre@orthoScoreMN)
    DF2<-data.frame(LC_PLS_Meta)
    DF$ID<-rownames(DF)
    DF2$ID<-rownames(DF2)
    DFT<-DF%>%
      left_join(DF2, by="ID")
    
    DFT%>%
      ggplot(aes(x=p1,y=o1,color=DFT[,4]))+
      stat_ellipse()+
      geom_point(aes())+
      theme_CKM()
    
  }
  
  
  
  
  OPLS_pre<- ggplot_OPLS(OPLS_DA_all_pre,GC_PLS_Meta[, "pre"])
  PLS_pre<- ggplot_PLS(PLS_DA_all_pre,GC_PLS_Meta[, "pre"])
  PLS_inc<-ggplot_PLS(PLS_DA_all_inc,GC_PLS_Meta[, "inc"])
  
  
 
  
  
  list(PLS_pre=PLS_pre,
       PLS_inc=PLS_inc,
       OPLS_pre=OPLS_pre
       
  )
  
}

###LC

plot_LC = function(LC_processed){
  
  
  LC_data_composite = LC_processed$metab_final$e_data %>%
    pivot_longer(cols=Pre_6_3:E_6_2, names_to= "Sample.ID")%>%
    left_join(LC_processed$metab_final$f_data, by= "Sample.ID")%>%
    left_join(LC_processed$LC_meta, by="Name2")%>%
    select(-MODE)
  
  
  
  
  
  
  statResAnova <- imd_anova(LC_processed$metab_final, test_method = "anova")
  
  StatsLC<-statResAnova %>%
    select(1:25,92,113,130,143,152,157,158,179,196,209,218,223)%>%
    knitr::kable()
  
  
  

    
  LC_data_composite2<-LC_data_composite%>%
    mutate(inc = replace(inc, inc == "pre", "0"),
           inc = as.numeric(as.character(inc)))  
  
  
  LC_lm = 
    LC_data_composite2 %>% 
    separate_wider_delim(Name2, "_", names=c("Metabolite","MODE"))%>%
    group_by(pre,Metabolite) %>% 
    do(fit_lm(.)) %>%
    filter(term =="inc")%>%
    # factor the Inc_temp so they can line up in the graph
    dplyr::select(`p.value`,'Metabolite','pre')
    
  
  Means_all<-LC_data_composite2 %>%
    separate_wider_delim(Name2, "_", names=c("Metabolite","MODE"))%>%
    mutate( Known=case_when(grepl("Unknown", Metabolite) ~ "Unkown"))%>%
    replace_na(list(Known="Known"))%>%
    left_join(LC_lm, by= c("Metabolite","pre")) 
  
  AAA<-Means_all%>%
    filter(Known== "Known")%>%
    distinct(Metabolite)%>%
    mutate(n= count(Metabolite))%>%
    summarise(S=sum(n$freq))
  
  AAA2<-Means_all%>%
    filter(Known== "Unkown")%>%
    distinct(Metabolite)%>%
    mutate(n= count(Metabolite))%>%
    summarise(S=sum(n$freq))
  
  AAA
  AAA2
  AAA/(AAA+AAA2)
  
  
  Means<-LC_data_composite %>%
    separate_wider_delim(Name2, "_", names=c("Metabolite","MODE"))%>%
    filter(!row_number() %in% c(1226:12075,13056:19915))
  
  
  
  
  Means_unknown<-LC_data_composite %>%
    separate_wider_delim(Name2, "_", names=c("Metabolite","MODE"))%>%
    filter(!row_number() %in% c(1:1225,12076:13055))
  Means_sac<-Means%>%
    filter(Main.class %in% c("Oligosaccharides","Monosaccharides","Disaccharides"))
  

  
  
    LC_all<-Means_all%>%
    mutate(inc = factor(inc, levels=c("0","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    ggplot(aes(x = inc, y = value, color = pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(inc, pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
      facet_trelliscope(~ Metabolite + MODE, nrow = 2, ncol = 7, width = 300, path = "rmarkdown_files", name = "LC compounds")+
    theme_light()+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    ggtitle("LC")
    
    
    
    
  LC_pos<-Means%>%
    mutate(inc = factor(inc, levels=c("pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    filter(MODE=="pos")%>%
    ggplot(aes(x = inc, y = value, color = pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(inc, pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    facet_wrap(~Metabolite, scales="free")+
    theme_light()+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    ggtitle("LC_pos known compound means")
  
  LC_pos_sac<-Means_sac%>%
    mutate(inc = factor(inc, levels=c("pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    filter(MODE=="pos")%>%
    ggplot(aes(x = inc, y = value, color = pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(inc, pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    facet_wrap(~Metabolite, scales="free")+
    theme_light()+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    ggtitle("LC_pos saccharides")
  
  
  LC_pos_unknown<-Means_unknown%>%
    mutate(inc = factor(inc, levels=c("pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    filter(MODE=="pos")%>%
    ggplot(aes(x = inc, y = value, color = pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(inc, pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 1.5)+
    facet_wrap(~Metabolite, scales="free")+
    theme_light()+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    ggtitle("LC_pos unknown compounds")
  
  
  
  LC_neg<-Means%>%
    mutate(inc = factor(inc, levels=c("pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    filter(MODE=="neg")%>%
    ggplot(aes(x = inc, y = value, color = pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(inc, pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    facet_wrap(~Metabolite, scales="free")+
    theme_light()+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    ggtitle("LC_neg known compound means")
  
  LC_neg_sac<-Means_sac%>%
    mutate(inc = factor(inc, levels=c("pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    filter(MODE=="neg")%>%
    ggplot(aes(x = inc, y = value, color = pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(inc, pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 3)+
    facet_wrap(~Metabolite, scales="free")+
    theme_light()+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    ggtitle("LC_neg saccharides")
  
  
  LC_neg_unknown<-Means_unknown%>%
    mutate(inc = factor(inc, levels=c("pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    filter(MODE=="neg")%>%
    ggplot(aes(x = inc, y = value, color = pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(inc, pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 1.5)+
    facet_wrap(~Metabolite, scales="free")+
    theme_light()+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    ggtitle("LC_neg unknown compounds")
  
  
  
  Stat_plot<-plot(statResAnova)
  
  
  list(Stat_plot = Stat_plot,
       LC_pos = LC_pos,
       LC_neg = LC_neg,
       LC_pos_unknown= LC_pos_unknown,
       LC_neg_unknown=LC_neg_unknown,
       LC_pos_sac=LC_pos_sac,
       LC_neg_sac=LC_neg_sac,
       StatsLC= StatsLC
       
  )
  
}

plot_LC_PCA = function(LC_PCA){
  
  permanova_LC_all = 
    adonis2(LC_PCA$LC_short %>% dplyr::select(Amines:Pyrimidines) ~ pre * inc, 
            data = LC_PCA$LC_short) %>%
    knitr::kable(caption="Permanova results all by Main class")
  permanova_LC_all2 = 
    adonis2(LC_PCA$LC_short %>% dplyr::select("Oligosaccharides","Monosaccharides","Disaccharides") ~ pre * inc, 
            data = LC_PCA$LC_short, na.rm=T) %>%
    knitr::kable(caption="Permanova results saccharides")
  
  Scale_inc= scale_color_manual(values=cbPalette2,limits=c("Pre","2","4","6","8","10"))
  
  permanova_LC_sig = 
    adonis2(LC_PCA$LC_data_composite_sig %>% dplyr::select(`13-HODE_neg`:`Unknown 131_neg`) ~ pre * inc, 
            data = LC_PCA$LC_data_composite_sig, na.rm=T) %>%
    knitr::kable(caption="Permanova results significant compounds only")
  
  
  gg_pca_pre_Sig=
    ggbiplot(LC_PCA$pca_LC_sig,obs.scale = 1, var.scale = 1,
             groups = as.character(LC_PCA$grp_sig$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0, varname.adjust = 1, varname.size = 4) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    labs(shape="",
         title = "LC-significant metabolites")+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    guides(color=guide_legend(title="Pre-incubation"),fill="none", alpha=F)+
    theme_CKM3()
  
  
  gg_pca_inc_Sig=
    ggbiplot(LC_PCA$pca_LC_sig,obs.scale = 1, var.scale = 1,
             groups = as.character(LC_PCA$grp_sig$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(shape=as.character(LC_PCA$grp_sig$pre),
                   color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    labs(shape="",
         title = "LC-significant metabolites (ANOVA)",
         subtitle = "separation by inc")+
    guides(color=guide_legend(title="Pre-incubation"),fill="none", alpha=F)+
    Scale_inc+
    theme_CKM()
  
  
  
  
  
  gg_pca_pre1=
    ggbiplot(LC_PCA$pca_LC,obs.scale = 1, var.scale = 1,
             groups = as.character(LC_PCA$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "LC-all samples",
         subtitle = "separation by pre")+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    guides(color=guide_legend(title="Pre-incubation"),fill="none", alpha=F)+
    theme_CKM()
  
  gg_pca_pre2=
    ggbiplot(LC_PCA$pca_LC2,obs.scale = 1, var.scale = 1,
             groups = as.character(LC_PCA$grp2$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "LC-saccharides only",
         subtitle = "separation by pre")+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    guides(color=guide_legend(title="Pre-incubation"),fill="none", alpha=F)+
    theme_CKM()
  
  
  gg_pca_inc1=
    ggbiplot(LC_PCA$pca_LC,obs.scale = 1, var.scale = 1,
             groups = as.character(LC_PCA$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(shape=as.character(LC_PCA$grp$pre),
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "LC-all samples",
         subtitle = "separation by pre inc")+
    guides(color=guide_legend(title="Pre-incubation"),fill="none", alpha=F)+
    Scale_inc+
    theme_CKM()
  
  gg_pca_inc2=
    ggbiplot(LC_PCA$pca_LC2,obs.scale = 1, var.scale = 1,
             groups = as.character(LC_PCA$grp2$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(shape=as.character(LC_PCA$grp$pre),
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "LC-saccharides only",
         subtitle = "separation by inc")+
    guides(color=guide_legend(title="Pre-incubation"),fill="none", alpha=F)+
    Scale_inc+
    theme_CKM()
  
  
  
  
  
  
  
  list( gg_pca_pre1=gg_pca_pre1,
        gg_pca_inc1=gg_pca_inc1,
        permanova_LC_all= permanova_LC_all,
        gg_pca_pre2=gg_pca_pre2,
        gg_pca_inc2=gg_pca_inc2,
        permanova_LC_all2= permanova_LC_all2,
        gg_pca_pre_Sig=gg_pca_pre_Sig,
        gg_pca_inc_Sig=gg_pca_inc_Sig,
        permanova_LC_sig=permanova_LC_sig
        
  )
  
}

plot_LC_PLS= function(LC_PCA){
  library(ropls)
  ##Data reorganization
  nameH<-c(1:34)
  
  LC_PLS_DATA<- LC_PCA$LC_short%>%
    select(Amines:unknown)%>%
    as.data.frame()
  rownames(LC_PLS_DATA) <- nameH
  
  LC_PLS_Meta<- LC_PCA$LC_short%>%
    select(Sample.ID:inc)%>%
    as.data.frame()%>%
    mutate(inc=as.factor(inc),pre=as.factor(pre))
  rownames(LC_PLS_DATA) <- nameH
  
  
  
  ##Polar PLS-DA
  
  PLS_DA_all_inc = opls(LC_PLS_DATA,LC_PLS_Meta[, "inc"],predI = 2)
  
  
  PLS_DA_all_pre = opls(LC_PLS_DATA,LC_PLS_Meta[, "pre"],predI = 2)
  OPLS_DA_all_pre = opls(LC_PLS_DATA,LC_PLS_Meta[, "pre"],predI = 1, orthoI = NA)
  
  plot(OPLS_DA_all_pre, typeVc = "x-score")
  
  plot(OPLS_DA_all_pre@scoreMN,OPLS_DA_all_pre@orthoScoreMN)
  
  
  ggplot_OPLS= function(OPLS_DA_all_pre,LC_PLS_Meta){
    DF<-data.frame(OPLS_DA_all_pre@scoreMN,OPLS_DA_all_pre@orthoScoreMN)
    DF2<-data.frame(LC_PLS_Meta)
    DF$ID<-rownames(DF)
    DF2$ID<-rownames(DF2)
    DFT<-DF%>%
      left_join(DF2, by="ID")
    
    DFT%>%
      ggplot(aes(x=p1,y=o1,color=DFT[,4]))+
      stat_ellipse()+
      geom_point(aes())+
      theme_CKM()
    
  }
  
  
  
  ggplot_PLS= function(PLS_DA_P6,Meta_PLS_P6_1){
    DF<-data.frame(PLS_DA_P6@scoreMN)
    DF2<-data.frame(Meta_PLS_P6_1)
    DF$ID<-rownames(DF)
    DF2$ID<-rownames(DF2)
    DFT<-DF%>%
      left_join(DF2, by="ID")
    
    DFT%>%
      ggplot(aes(x=p1,y=p2,color=DFT[,4]))+
      stat_ellipse()+
      geom_point(aes())+
      theme_CKM()
    
  }
  
  
  PLS_pre<- ggplot_PLS(PLS_DA_all_pre,LC_PLS_Meta[, "pre"])
  PLS_inc<-ggplot_PLS(PLS_DA_all_inc,LC_PLS_Meta[, "inc"])
  OPLS_pre<- ggplot_OPLS(OPLS_DA_all_pre,LC_PLS_Meta[, "pre"])
  
  
  
  
  
  list(PLS_pre=PLS_pre,
       PLS_inc=PLS_inc,
       OPLS_pre=OPLS_pre
       
  )
  
}

plot_LC_GC_PCA = function(gg_LC_PCA,gg_GC_PCA){
  
  
  gg_LC_PCA$gg_pca_pre_Sig
  gg_GC_PCA$gg_pca_pre_Sig
  
  Nutrient_legend = get_legend(gg_GC_PCA$gg_pca_pre_Sig+  theme(legend.position = "bottom"))
  gg_Ncombine= plot_grid(
    gg_GC_PCA$gg_pca_pre_Sig + theme(legend.position="none"),
    gg_LC_PCA$gg_pca_pre_Sig + theme(legend.position="none"),
    align = 'vh',
    labels = c("A", "B"),
    label_y= 0.93,
    hjust = -1,
    vjust=10,
    nrow = 1
  )
  gg_PCA_Legend=plot_grid(gg_Ncombine,NULL,Nutrient_legend, ncol=1, rel_heights =c(1,-0.25,0.1))
  ggsave("Graphs/GC_LC_PCA.png", gg_PCA_Legend, width=12, height=8)
  

list(gg_PCA_Legend=gg_PCA_Legend
        
  )
  
}

###Lipid

plot_Lipid = function(Lipid_processed,Lipid_PCA){

  permanova_Lipid_all = 
    adonis2(Lipid_PCA$Lipid_short %>% dplyr::select(Glycerolipid:Sphingolipid) ~ Pre * Inc, 
            data = Lipid_PCA$Lipid_short) %>%
    knitr::kable(caption="Permanova results all")
  permanova_Lipid_all2 = 
    adonis2(Lipid_PCA$Lipid_short2 %>% dplyr::select(Glycerolipid:Sphingolipid) ~ Pre * Inc, 
            data = Lipid_PCA$Lipid_short2, na.rm=T) %>%
    knitr::kable(caption="Permanova results pos")
  permanova_Lipid_all3 = 
    adonis2(Lipid_PCA$Lipid_short3 %>% dplyr::select(Glycerolipid:Sphingolipid) ~ Pre * Inc, 
            data = Lipid_PCA$Lipid_short3, na.rm=T) %>%
    knitr::kable(caption="Permanova results neg")
  
  
  
  
  
  
  gg_pca_pre=
    ggbiplot(Lipid_PCA$pca_Lip,obs.scale = 1, var.scale = 1,
             groups = as.character(Lipid_PCA$grp$Pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "Lipid-all samples",
         subtitle = "separation by pre inc")+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    theme_CKM()
  
  gg_pca_inc=
    ggbiplot(Lipid_PCA$pca_Lip,obs.scale = 1, var.scale = 1,
             groups = as.character(Lipid_PCA$grp$Inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(shape=as.character(Lipid_PCA$grp$Pre),
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "Lipid-all samples",
         subtitle = "separation by inc")+
    Scale_inc+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    theme_CKM()
  
  
  gg_pca_pre_pos=
    ggbiplot(Lipid_PCA$pca_Lip_pos,obs.scale = 1, var.scale = 1,
             groups = as.character(Lipid_PCA$grp2$Pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "Lipid-positive mode",
         subtitle = "separation by pre inc")+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    theme_CKM()
  
  gg_pca_inc_pos=
    ggbiplot(Lipid_PCA$pca_Lip_pos,obs.scale = 1, var.scale = 1,
             groups = as.character(Lipid_PCA$grp2$Inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(shape=as.character(Lipid_PCA$grp2$Pre),
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "Lipid-positive mode",
         subtitle = "separation by inc pos")+
    Scale_inc+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    theme_CKM()
  
  
  
  
  gg_pca_pre_neg=
    ggbiplot(Lipid_PCA$pca_Lip_neg,obs.scale = 1, var.scale = 1,
             groups = as.character(Lipid_PCA$grp3$Pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "Lipid-negative mode",
         subtitle = "separation by pre inc")+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    theme_CKM()
  
  gg_pca_inc_neg=
    ggbiplot(Lipid_PCA$pca_Lip_neg,obs.scale = 1, var.scale = 1,
             groups = as.character(Lipid_PCA$grp3$Inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 1,
               aes(shape = as.character(Lipid_PCA$grp3$Pre),
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "Lipid-negative mode",
         subtitle = "separation by inc neg")+
    Scale_inc+
    theme_CKM()
  
  statResAnova <- imd_anova(Lipid_processed$metab_final, test_method = "anova")
  
  StatsLC<-statResAnova %>%
    select(1:25,98,111,113,136,137,152,164,177,179,202,203,218)%>%
    knitr::kable()
  StatsLipid<-statResAnova %>%
    knitr::kable()
  
  
  fit_lm2 = function(LASTRES){
    
    a = lm(value ~ Inc, data = LASTRES)
    broom::tidy(a)  
    
  }    

  Means_all<-Lipid_PCA$Lipid_data_composite %>%
    separate_wider_delim(Name2, "__", names=c("Lipid","MODE"))%>%
    mutate(Inc = replace(Inc, Inc == "T0", "0"),
           Inc = as.numeric(as.character(Inc)))
  
  Lipid_lm = 
    Means_all %>% 
    group_by(Pre,Lipid) %>% 
    do(fit_lm2(.)) %>%
    filter(term =="Inc")%>%
    # factor the Inc_temp so they can line up in the graph
    dplyr::select(`p.value`,"Lipid",'Pre')
  
  Means_all2<- Means_all%>%
    left_join(Lipid_lm, by= c("Lipid","Pre"))
  
  
  Means<-Lipid_PCA$Lipid_data_composite %>%
    separate_wider_delim(Name2, "__", names=c("Lipid","MODE"))%>%
    mutate(Inc = replace(Inc, Inc == "T0", "Pre"))
  
  Lipid_all<-Means_all2%>%
    mutate(Inc = factor(Inc, levels=c("0","2","4","6","8","10")),
           Pre = factor(Pre,levels=c("-2","-6"))) %>%
    ggplot(aes(x = Inc, y = value, color = Pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(Inc, Pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 1.5)+
    facet_trelliscope(~ Lipid + MODE, nrow = 2, ncol = 7, width = 300, path = "rmarkdown_files", name = "Lipids")+
    theme_light()+
     scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    ggtitle("Lipids")
  
  Lipid_pos<-Means%>%
    mutate(Inc = factor(Inc, levels=c("Pre","2","4","6","8","10")),
           Pre = factor(Pre,levels=c("-2","-6"))) %>%
    filter(MODE=="pos")%>%
    ggplot(aes(x = Inc, y = value, color = Pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(Inc, Pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 1.5)+
    facet_wrap(~Lipid, scales="free")+
    theme_light()+
    scale_colour_manual(values=cbPalette2)+
    ggtitle("Lipid_pos")
  
  
  
  Lipid_neg<-Means%>%
    mutate(Inc = factor(Inc, levels=c("Pre","2","4","6","8","10")),
           Pre = factor(Pre,levels=c("-2","-6"))) %>%
    filter(MODE=="neg")%>%
    ggplot(aes(x = Inc, y = value, color = Pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(Inc, Pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 1.5)+
    facet_wrap(~Lipid, scales="free")+
    theme_light()+
    scale_colour_manual(values=cbPalette2)+
    ggtitle("Lipid_neg")
  
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
    mutate(Inc = factor(Inc, levels=c("Pre","2","4","6","8","10")),
           Pre = factor(Pre,levels=c("-2","-6"))) %>%
    filter(MODE=="neg")%>%
    ggplot(aes(x = Inc, y = value, color = Pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(Inc, Pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 1.5)+
    facet_wrap(~Lipid, scales="free")+
    theme_light()+
    scale_colour_manual(values=cbPalette2)+
    ggtitle("Lipid_neg significant compound means")

  
  Lipid_pos2<-Means2%>%
    mutate(Inc = factor(Inc, levels=c("Pre","2","4","6","8","10")),
           Pre = factor(Pre,levels=c("-2","-6"))) %>%
    filter(MODE=="pos")%>%
    ggplot(aes(x = Inc, y = value, color = Pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(Inc, Pre)))+
    geom_point(position = position_dodge(width = 0.6), size = 1.5)+
    facet_wrap(~Lipid, scales="free")+
    theme_light()+
    scale_colour_manual(values=cbPalette2)+
    ggtitle("Lipid_pos significant compound means")
  
  
  Stat_plot<-plot(statResAnova)
  

  Lipid_heat_map <- Means%>%
    mutate(Inc = factor(Inc, levels=c("Pre","2","4","6","8","10")),
           Pre = factor(Pre,levels=c("-2","-6")),
           class= factor(class, levels=c("Sphingolipid","Prenol Lipid","Glycerophospholipid","Glycerolipid"))) %>%
    group_by(class)%>%
    ggplot(aes( Pre,Lipid)) +                           # Create heatmap with ggplot2
    geom_tile(aes(fill = value))+
    scale_fill_gradient(low = "#00FFFF", high = "#FF1493")+
    facet_grid(class~ Inc, scales="free")+
    ggtitle("Heat map for each lipid")
  
  class_heat_map <- Means%>%
    mutate(Inc = factor(Inc, levels=c("Pre","2","4","6","8","10")),
           Pre = factor(Pre,levels=c("-2","-6"))) %>%
    ggplot(aes( Pre,class)) +                           # Create heatmap with ggplot2
    geom_tile(aes(fill = value))+
    scale_fill_gradient(low = "#00FFFF", high = "#FF1493")+
    facet_grid(~Inc)+
    ggtitle("Heat map of Lipids by class")
  
  
  list(Stat_plot = Stat_plot,
       #Lipid_all = Lipid_all,
       Lipid_pos = Lipid_pos,
       Lipid_neg = Lipid_neg,
       Lipid_pos2=Lipid_pos2,
       Lipid_neg2=Lipid_neg2,
       gg_pca_pre=gg_pca_pre,
       gg_pca_inc=gg_pca_inc,
       gg_pca_pre_pos=gg_pca_pre_pos,
       gg_pca_inc_pos=gg_pca_inc_pos,
       gg_pca_pre_neg=gg_pca_pre_neg,
       gg_pca_inc_neg=gg_pca_inc_neg,
       permanova_Lipid_all=permanova_Lipid_all,
       permanova_Lipid_all2=permanova_Lipid_all2,
       permanova_Lipid_all3=permanova_Lipid_all3,
       StatsLipid=StatsLipid,
       Lipid_heat_map=Lipid_heat_map,
       class_heat_map=class_heat_map
       
       
  )
  
}

plot_Lipid_PLS= function(Lipid_PCA){
  library(ropls)
  ##Data reorganization
  nameH<-c(1:35)
  Lipid_PLS_DATA<- Lipid_PCA$Lipid_short%>%
    select(Glycerolipid:Sphingolipid)%>%
    as.data.frame()
  rownames(Lipid_PLS_DATA) <- nameH
  
  Lipid_PLS_DATA2<- Lipid_PCA$Lipid_short2%>%
    select(Glycerolipid:Sphingolipid)%>%
    as.data.frame()
  rownames(Lipid_PLS_DATA2) <- nameH
  
  Lipid_PLS_DATA3<- Lipid_PCA$Lipid_short3%>%
    select(Glycerophospholipid,Sphingolipid)%>%
    as.data.frame()
  rownames(Lipid_PLS_DATA3) <- nameH
  
  Lipid_PLS_Meta<- Lipid_PCA$Lipid_short%>%
    select(Sample.ID:Inc)%>%
    as.data.frame()%>%
    mutate(inc=as.factor(Inc),pre=as.factor(Pre))
  rownames(Lipid_PLS_DATA) <- nameH
  
  
  
  ##Polar PLS-DA
  
  PLS_DA_all_inc = opls(Lipid_PLS_DATA,Lipid_PLS_Meta[, "inc"],predI = 2)
  PLS_DA_all_pre = opls(Lipid_PLS_DATA,Lipid_PLS_Meta[, "pre"],predI = 2)
  PLS_DA_all_inc2 = opls(Lipid_PLS_DATA2,Lipid_PLS_Meta[, "inc"],predI = 2)
  PLS_DA_all_pre2 = opls(Lipid_PLS_DATA2,Lipid_PLS_Meta[, "pre"],predI = 2)
  PLS_DA_all_inc3 = opls(Lipid_PLS_DATA3,Lipid_PLS_Meta[, "inc"],predI = 2)
  PLS_DA_all_pre3 = opls(Lipid_PLS_DATA3,Lipid_PLS_Meta[, "pre"],predI = 2)
  
  ggplot_PLS= function(PLS_DA_P6,Meta_PLS_P6_1){
    DF<-data.frame(PLS_DA_P6@scoreMN)
    DF2<-data.frame(Meta_PLS_P6_1)
    DF$ID<-rownames(DF)
    DF2$ID<-rownames(DF2)
    DFT<-DF%>%
      left_join(DF2, by="ID")
    
    DFT%>%
      ggplot(aes(x=p1,y=p2,color=DFT[,4]))+
      stat_ellipse()+
      geom_point(aes())+
      theme_CKM()
    
  }
  
  
  PLS_pre<- ggplot_PLS(PLS_DA_all_pre,Lipid_PLS_Meta[, "pre"])
  PLS_inc<-ggplot_PLS(PLS_DA_all_inc,Lipid_PLS_Meta[, "inc"])
  PLS_pre2<- ggplot_PLS(PLS_DA_all_pre2,Lipid_PLS_Meta[, "pre"])
  PLS_inc2<-ggplot_PLS(PLS_DA_all_inc2,Lipid_PLS_Meta[, "inc"])
  PLS_pre3<- ggplot_PLS(PLS_DA_all_pre3,Lipid_PLS_Meta[, "pre"])
  PLS_inc3<-ggplot_PLS(PLS_DA_all_inc3,Lipid_PLS_Meta[, "inc"])
  
  
  
  
  
  list(PLS_pre=PLS_pre,
       PLS_inc=PLS_inc,
       PLS_pre2=PLS_pre2,
       PLS_inc2=PLS_inc2,
       PLS_pre3=PLS_pre3,
       PLS_inc3=PLS_inc3
       
  )
  
}

###FTICR

plot_FTICR = function(FTICR_processed){
  
  source("code/fticr/b-functions_analysis.R")
  fticr_meta  = FTICR_processed$fticr_meta_combined
  fticr_data_longform = FTICR_processed$fticr_data_longform_combined
  fticr_data_trt = FTICR_processed$fticr_data_trt_combined
  TREATMENTS = dplyr::quos(pre,inc, Polar)
  
  
  
  # 2. van krevelen plots ---------------------------------------------------
  ## 2a. domains ----
  gg_vk_domains = 
    gg_vankrev(fticr_meta, aes(x = OC, y = HC, color = Class))+
    scale_color_manual(values = PNWColors::pnw_palette("Sunset2"))+
    theme_CKM()+
    ggtitle("van krevelen diagram domains")
  
  gg_vk_domains_nosc = 
    gg_vankrev(fticr_meta, aes(x = OC, y = HC, color = as.numeric(NOSC)))+
    scale_color_gradientn(colors = PNWColors::pnw_palette("Bay"))+
    theme_CKM()+
    ggtitle("van krevelen diagram domains")
  ## 2b. treatments ----
  
  fticr_hcoc = 
    fticr_data_trt %>% 
    left_join(dplyr::select(fticr_meta, formula, HC, OC), by = "formula")%>%
    mutate(inc=factor(inc,levels=c("Pre",'2','4','6','8','10')))
  
  gg_vk_polar_nonpolar = 
    (fticr_hcoc %>%
       distinct(formula, HC, OC, Polar) %>% 
       gg_vankrev(aes(x = OC, y = HC, color = Polar))+
       stat_ellipse(level = 0.90, show.legend = FALSE)+
       theme(legend.position = c(0.8, 0.8))+
    NULL) 
  
  gg_vk_all = 
    gg_vankrev(fticr_hcoc, aes(x = OC, y = HC, color = pre))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_grid(inc ~ Polar)+
    theme_CKM()+
    ggtitle("van krevelen diagram separated by incubation and colored by pre-incubation")
  
  gg_vk_all_pre = 
    gg_vankrev(fticr_hcoc, aes(x = OC, y = HC, color = inc))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_grid(Polar ~ pre)+
    theme_CKM()+
    ggtitle("van krevelen diagram colored by incubation and separated by pre-incubation")

  
  
  
  ## Unique peaks  by pre
  
  fticr_unique_pre = 
    fticr_hcoc %>% 
    distinct(formula, HC,pre, OC) %>% 
    group_by(formula) %>% 
    dplyr::mutate(n = n())
  
  gg_unique_pre =
    fticr_unique_pre %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = pre))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~pre)+
    labs(title = "Unique peaks by pre")+
    theme_CKM()
  
  gg_common = 
    fticr_unique_pre %>% filter(n == 2) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "common peaks")+
    theme_CKM()
  
  gg_common_unique = 
    fticr_unique_pre %>% filter(n == 2) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    geom_point(data = fticr_unique_pre %>% filter(n == 1),
               aes(color = pre), alpha = 0.7)+
    facet_wrap(~pre)+
    labs(title = "Unique peaks by pre",
         subtitle = "black/grey = peaks common to all")+
    theme_CKM()
  
  fticr_unique_summary = 
    fticr_unique_pre %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(pre, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = pre, values_from = counts)%>%
    knitr::kable()
  
  
  
  ## Unique peaks  by inc
  
  
  fticr_unique_inc = 
    fticr_hcoc %>% 
    distinct(formula, HC,inc, OC) %>% 
    group_by(formula) %>% 
    dplyr::mutate(n = n())%>%
    filter(inc != 'NA')
  
  gg_unique_inc =
    fticr_unique_inc %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = inc))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks at each inc")+
    theme_CKM()
  
  gg_common_inc = 
    fticr_unique_inc %>% filter(n == 7) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "common peaks")+
    theme_CKM()
  
  gg_common_unique_inc = 
    fticr_unique_inc %>% filter(n == 7) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    geom_point(data = fticr_unique_inc %>% filter(n == 1),
               aes(color = inc), alpha = 0.7)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks by inc",
         subtitle = "black/grey = peaks common to all")+
    theme_CKM()
  
  fticr_unique_summary_inc = 
    fticr_unique_inc %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(inc, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = inc, values_from = counts)%>%
    select(c( Class,  Pre  ,`2` ,  `4` ,  `6`,   `8`, `10` )) %>%
    knitr::kable()
  
  
  
  ## Unique peaks  by inc and pre
  
  
  fticr_unique_inc_pre = 
    fticr_hcoc %>% 
    distinct(formula, HC,inc,pre, OC) %>% 
    group_by(formula) %>% 
    dplyr::mutate(n = n())%>%
    filter(inc != 'NA')
  
  gg_unique_inc_pre =
    fticr_unique_inc_pre %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = pre))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks at each inc")+
    theme_CKM()
  
  gg_common_inc_pre = 
    fticr_unique_inc_pre %>% filter(n == 14) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "common peaks")+
    theme_CKM()
  
  gg_common_unique_inc_pre = 
    fticr_unique_inc_pre %>% filter(n == 14) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    geom_point(data = fticr_unique_inc_pre %>% filter(n == 1),
               aes(color = pre), alpha = 0.7)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks by inc and pre",
         subtitle = "black/grey = peaks common to all")+
    theme_CKM()
  
  fticr_unique_summary_inc_pre = 
    fticr_unique_inc_pre %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(inc,pre, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = c(pre,inc), values_from = counts)%>%
    select(c(Class, `-2_Pre`, `-6_Pre`,`-2_2`, `-6_2`, `-2_4`, `-6_4`, `-2_6`, `-6_6`, `-2_8`, `-6_8`, `-2_10`, `-6_10`))%>%
    knitr::kable()
  
 
  
  # 3. relative abundance ---------------------------------------------------
  # calculate relative abundance for each core/sample
  # make sure totals add up to 100 % for each sample 
  # use this for stats, including PERMANOVA, PCA
  relabund_cores = 
    fticr_data_longform %>% 
    compute_relabund_cores(fticr_meta, TREATMENTS)%>%
    filter(inc!='NA')
  
  
  relabund_trt = 
    relabund_cores %>% 
    group_by(!!!TREATMENTS, Class) %>% 
    dplyr::summarize(rel_abund = round(mean(relabund),2),
                     se  = round((sd(relabund/sqrt(n()))),2),
                     relative_abundance = paste(rel_abund, "\u00b1",se)) %>% 
    ungroup()  %>% 
    mutate(Class = factor(Class, levels = c("aliphatic", "unsaturated/lignin", "aromatic", "condensed aromatic")))
  
  relabund<-relabund_trt %>% 
    ggplot(aes(x = pre, y = rel_abund, fill = Class))+
    geom_bar(stat = "identity")+
    facet_grid(~inc)+
    theme_CKM()+
    ggtitle("relative abundance")
  
  
  # 4. statistics -----------------------------------------------------------
  
  relabund_wide = 
    relabund_cores %>% 
    ungroup() %>% 
    #filter(Polar == "polar") %>% 
    mutate(Class = factor(Class, 
                          levels = c("aliphatic", "unsaturated/lignin", 
                                     "aromatic", "condensed aromatic"))) %>% 
    dplyr::select(-c(abund, total)) %>% 
    spread(Class, relabund) %>% 
    replace(is.na(.), 0)
  relabund_wide_p = 
    relabund_cores %>% 
    ungroup() %>% 
    #filter(Polar == "polar") %>% 
    mutate(Class = factor(Class, 
                          levels = c("aliphatic", "unsaturated/lignin", 
                                     "aromatic", "condensed aromatic"))) %>% 
    dplyr::select(-c(abund, total)) %>% 
    spread(Class, relabund) %>% 
    replace(is.na(.), 0)%>%
    filter(Polar=='polar')
  relabund_wide_np = 
    relabund_cores %>% 
    ungroup() %>% 
    #filter(Polar == "polar") %>% 
    mutate(Class = factor(Class, 
                          levels = c("aliphatic", "unsaturated/lignin", 
                                     "aromatic", "condensed aromatic"))) %>% 
    dplyr::select(-c(abund, total)) %>% 
    spread(Class, relabund) %>% 
    replace(is.na(.), 0)%>%
    filter(Polar=='nonpolar')
  
  permanova_fticr_all = 
    adonis2(relabund_wide %>% dplyr::select(aliphatic:`condensed aromatic`) ~ pre * inc, 
           data = relabund_wide) %>%
    knitr::kable(caption = "Permanova results: All")
  permanova_fticr_polar = 
    adonis2(relabund_wide_p %>% dplyr::select(aliphatic:`condensed aromatic`) ~ pre * inc, 
            data = relabund_wide_p) %>%
    knitr::kable(caption = "Permanova results: Polar only")
  permanova_fticr_nonpolar = 
    adonis2(relabund_wide_np %>% dplyr::select(aliphatic:`condensed aromatic`) ~ pre * inc, 
            data = relabund_wide_np) %>%
    knitr::kable(caption = "Permanova results: Non-Polar only")
  
  ## 4b. PCA ----
  pca_all = fit_pca_function(relabund_cores)
  pca_polar = fit_pca_function(relabund_cores %>% filter(Polar == "polar")) 
  pca_nonpolar = fit_pca_function(relabund_cores %>% filter(Polar == "nonpolar"))
  
  
  gg_pca_polar_nonpolar = 
    ggbiplot(pca_all$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "all samples",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre = 
    ggbiplot(pca_all$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "all samples",
         subtitle = "separation by pre")+
    theme_CKM()
  
  gg_pca_polar_nonpolar_inc = 
    ggbiplot(pca_all$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "all samples",
         subtitle = "separation by inc")+
    theme_CKM()
  
  gg_pca_by_pre_polar = 
  ggbiplot(pca_polar$pca_int, obs.scale = 1, var.scale = 1,
           groups = as.character(pca_polar$grp$pre), 
           ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
  geom_point(size=3,stroke=1, alpha = 0.5,
             aes(#shape = groups,
                 color = groups))+
  #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
  xlim(-4,4)+
  ylim(-3.5,3.5)+
  labs(shape="",
       title = "Polar",
       subtitle = "separation by pre")+
  theme_CKM()+
  NULL
  
  gg_pca_by_pre_nonpolar = 
    ggbiplot(pca_nonpolar$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "Non-Polar",
         subtitle = "separation by pre")+
    theme_CKM()+
    NULL
  
  
  
  gg_pca_by_inc_polar = 
    ggbiplot(pca_polar$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "Polar",
         subtitle = "separation by inc")+
    theme_CKM()+
    NULL
  
  gg_pca_by_inc_nonpolar = 
    ggbiplot(pca_nonpolar$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "Non-Polar",
         subtitle = "separation by inc")+
    theme_CKM()+
    NULL
  
  
 
  
  
  
  list(gg_vk_domains = gg_vk_domains,
       gg_vk_domains_nosc = gg_vk_domains_nosc,
       gg_vk_polar_nonpolar= gg_vk_polar_nonpolar,
       gg_vk_all=gg_vk_all,
       gg_vk_all_pre=gg_vk_all_pre,
       gg_unique_pre= gg_unique_pre,
       gg_common_unique=gg_common_unique,
       fticr_unique_summary=fticr_unique_summary,
       gg_common_unique_inc=gg_common_unique_inc,
       fticr_unique_summary_inc=fticr_unique_summary_inc,
       gg_common_unique_inc_pre=gg_common_unique_inc_pre,
       fticr_unique_summary_inc_pre=fticr_unique_summary_inc_pre,
       relabund=relabund,
       permanova_fticr_all=permanova_fticr_all,
       permanova_fticr_polar=permanova_fticr_polar,
       permanova_fticr_nonpolar=permanova_fticr_nonpolar,
       gg_pca_polar_nonpolar= gg_pca_polar_nonpolar,
       gg_pca_by_pre_polar=gg_pca_by_pre_polar,
       gg_pca_by_pre_nonpolar=gg_pca_by_pre_nonpolar,
       gg_pca_by_inc_polar=gg_pca_by_inc_polar,
       gg_pca_by_inc_nonpolar=gg_pca_by_inc_nonpolar,
       gg_pca_polar_nonpolar_pre=gg_pca_polar_nonpolar_pre,
       gg_pca_polar_nonpolar_inc=gg_pca_polar_nonpolar_inc
       
       
       
       
  )
  
}

plot_FTICR_vk = function(FTICR_processed){
  
  fticr_meta  = FTICR_processed$fticr_meta_combined
  fticr_data_longform = FTICR_processed$fticr_data_longform_combined
  fticr_data_trt = FTICR_processed$fticr_data_trt_combined
  TREATMENTS = dplyr::quos(pre,inc, Polar)
  
  
  
  # 2. van krevelen plots ---------------------------------------------------
  ## 2a. domains ----
  gg_vk_domains = 
    gg_vankrev(fticr_meta, aes(x = OC, y = HC, color = Class))+
    scale_color_manual(values = PNWColors::pnw_palette("Sunset2"))+
    theme_CKM()+
    ggtitle("van krevelen diagram domains")
  
  gg_vk_domains_nosc = 
    gg_vankrev(fticr_meta, aes(x = OC, y = HC, color = as.numeric(NOSC)))+
    scale_color_gradientn(colors = PNWColors::pnw_palette("Bay"))+
    theme_CKM()+
    ggtitle("van krevelen diagram domains")
  ## 2b. treatments ----
  
  fticr_hcoc = 
    fticr_data_trt %>% 
    left_join(dplyr::select(fticr_meta, formula, HC, OC), by = "formula")%>%
    mutate(inc=factor(inc,levels=c("Pre",'2','4','6','8','10')))
  
  gg_vk_polar_nonpolar = 
    (fticr_hcoc %>%
       distinct(formula, HC, OC, Polar) %>% 
       gg_vankrev(aes(x = OC, y = HC, color = Polar))+
       stat_ellipse(level = 0.90, show.legend = FALSE)+
       theme(legend.position = c(0.8, 0.8))+
       NULL) 
  
  gg_vk_all = 
    gg_vankrev(fticr_hcoc, aes(x = OC, y = HC, color = pre))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_grid(inc ~ Polar)+
    theme_CKM()+
    ggtitle("van krevelen diagram separated by incubation and colored by pre-incubation")
  
  gg_vk_all_pre = 
    gg_vankrev(fticr_hcoc, aes(x = OC, y = HC, color = inc))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_grid(Polar ~ pre)+
    theme_CKM()+
    ggtitle("van krevelen diagram colored by incubation and separated by pre-incubation")
  
  
  
  
 
  
  
  
  
  
  list(gg_vk_domains = gg_vk_domains,
       gg_vk_domains_nosc = gg_vk_domains_nosc,
       gg_vk_polar_nonpolar= gg_vk_polar_nonpolar,
       gg_vk_all=gg_vk_all,
       gg_vk_all_pre=gg_vk_all_pre
       
       
       
  )
  
}

plot_FTICR_NOSC = function(FTICR_processed){
  
  fticr_meta  = FTICR_processed$fticr_meta_combined
  fticr_data_longform = FTICR_processed$fticr_data_longform_combined
  fticr_data_trt = FTICR_processed$fticr_data_trt_combined
  fticr_Nosc = fticr_data_trt%>%
    left_join(fticr_meta, by= 'formula')%>%
    filter(inc != 'NA')
 
  
  gg_nosc<- fticr_Nosc%>%
    ggplot(aes(x=inc,y=NOSC, color=pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(inc, pre)))+
    ggtitle("All NOSC")
    #geom_point(position = position_dodge(width = 0.6), size = 3)
  gg_nosc_polar<- fticr_Nosc%>%
    filter(Polar=='polar')%>%
    ggplot(aes(x=inc,y=NOSC, color=pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(inc, pre)))+
    ggtitle("polar NOSC")
  #geom_point(position = position_dodge(width = 0.6), size = 3)
  gg_nosc_nonpolar<- fticr_Nosc%>%
    filter(Polar=='nonpolar')%>%
    ggplot(aes(x=inc,y=NOSC, color=pre))+
    geom_boxplot(show.legend = F, 
                 outlier.colour = NULL,
                 outlier.fill = NULL,
                 position = position_dodge(width = 0.6), 
                 alpha = 0.2,
                 aes(group = interaction(inc, pre)))+
    ggtitle("nonpolar NOSC")
  #geom_point(position = position_dodge(width = 0.6), size = 3)
  
  
  list(gg_nosc=gg_nosc,
       gg_nosc_polar=gg_nosc_polar,
       gg_nosc_nonpolar=gg_nosc_nonpolar
       
       
       
  )
  
}

plot_FTICR_unique_all = function(FTICR_processed){
  fticr_meta  = FTICR_processed$fticr_meta_combined
  fticr_data_longform = FTICR_processed$fticr_data_longform_combined
  fticr_data_trt = FTICR_processed$fticr_data_trt_combined
  TREATMENTS = dplyr::quos(pre,inc, Polar)
  fticr_hcoc = 
    fticr_data_trt %>% 
    left_join(dplyr::select(fticr_meta, formula, HC, OC), by = "formula")%>%
    mutate(inc=factor(inc,levels=c("Pre",'2','4','6','8','10')))
  
  #All 
  
  ## Unique and common by Polar vs non polar
  fticr_unique_polar = 
    fticr_hcoc %>% 
    distinct(formula, HC,Polar, OC) %>% 
    group_by(formula) %>% 
    dplyr::mutate(n = n())
  gg_common = 
    fticr_unique_polar %>% filter(n == 2) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "common peaks")+
    theme_CKM()
  fticr_common_summary = 
    fticr_unique_polar %>% 
    filter(n == 2) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(Class) %>% 
    dplyr::summarise(counts = n()/2)%>%
    knitr::kable(caption = "Common peaks between polar and non polar")
  
  gg_unique_polar =
    fticr_unique_polar %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = Polar))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "Unique peaks by Polar")+
    theme_CKM()
  
  
  
  gg_common_unique = 
    fticr_unique_polar %>%
    filter(n == 2) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    geom_point(data = fticr_unique_polar %>% filter(n == 1),
               aes(color = Polar), alpha = 0.7)+
    facet_wrap(~Polar)+
    labs(title = "Unique peaks by Polar",
         subtitle = "black/grey = peaks common to all")+
    theme_CKM()
  
  
  
  fticr_unique_summary = 
    fticr_unique_polar %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(Polar, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = Polar, values_from = counts)%>%
    knitr::kable()
  
  ## Unique peaks  by pre
  
  fticr_unique_pre = 
    fticr_hcoc %>% 
    distinct(formula, HC,pre, OC) %>% 
    group_by(formula) %>% 
    dplyr::mutate(n = n())
  
  gg_unique_pre =
    fticr_unique_pre %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = pre))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~pre)+
    labs(title = "Unique peaks by pre")+
    theme_CKM()
  
  gg_common = 
    fticr_unique_pre %>% filter(n == 2) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "common peaks")+
    theme_CKM()
  
  gg_common_unique = 
    fticr_unique_pre %>%
    filter(n == 2) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    geom_point(data = fticr_unique_pre %>% filter(n == 1),
               aes(color = pre), alpha = 0.7)+
    facet_wrap(~pre)+
    labs(title = "Unique peaks by pre",
         subtitle = "black/grey = peaks common to all")+
    theme_CKM()
  
  fticr_unique_summary = 
    fticr_unique_pre %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(pre, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = pre, values_from = counts)%>%
    knitr::kable()
  
  
  
  ## Unique peaks  by inc
  
  
  fticr_unique_inc = 
    fticr_hcoc %>% 
    distinct(formula, HC,inc, OC) %>% 
    group_by(formula) %>% 
    dplyr::mutate(n = n())%>%
    filter(inc != 'NA')
  
  gg_unique_inc =
    fticr_unique_inc %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = inc))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks at each inc")+
    theme_CKM()
  
  gg_common_inc = 
    fticr_unique_inc %>% filter(n == 7) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "common peaks")+
    theme_CKM()
  
  gg_common_unique_inc = 
    fticr_unique_inc %>% 
    filter(n == 7) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    geom_point(data = fticr_unique_inc %>% filter(n == 1),
               aes(color = inc), alpha = 0.7)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks by inc",
         subtitle = "black/grey = peaks common to all")+
    theme_CKM()
  
  fticr_unique_summary_inc = 
    fticr_unique_inc %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(inc, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = inc, values_from = counts)%>%
    select(c( Class,  Pre  ,`2` ,  `4` ,  `6`,   `8`, `10` )) %>%
    knitr::kable()
  
  
  
  ## Unique peaks  by inc and pre
  
  
  fticr_unique_inc_pre = 
    fticr_hcoc %>% 
    distinct(formula, HC,inc,pre, OC) %>% 
    group_by(formula) %>% 
    dplyr::mutate(n = n())%>%
    filter(inc != 'NA')
  
  gg_unique_inc_pre =
    fticr_unique_inc_pre %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = pre))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks at each inc")+
    theme_CKM()
  
  gg_common_inc_pre = 
    fticr_unique_inc_pre %>% filter(n == 14) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "common peaks")+
    theme_CKM()
  
  gg_common_unique_inc_pre = 
    fticr_unique_inc_pre %>% 
    mutate(inc = factor(inc, levels=c("T0","2","4","6","8","10")),
                                    pre = factor(pre,levels=c("-2","-6"))) %>%
    filter(n == 14) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    geom_point(data = fticr_unique_inc_pre %>% filter(n == 1),
               aes(color = pre), alpha = 0.7)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks by inc and pre",
         subtitle = "black/grey = peaks common to all")+
    theme_CKM()
  
  fticr_unique_summary_inc_pre = 
    fticr_unique_inc_pre %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(inc,pre, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = c(pre,inc), values_from = counts)%>%
    select(c(Class, `-2_Pre`, `-6_Pre`,`-2_2`, `-6_2`, `-2_4`, `-6_4`, `-2_6`, `-6_6`, `-2_8`, `-6_8`, `-2_10`, `-6_10`))%>%
    knitr::kable()
  
  
  
  
  
  
  
  
  
  
  #Unique by each inc temp
  Filter_unique_FTICR = function(TEMP){
    fticr_hcoc %>% 
    filter(inc== TEMP)%>%
    distinct(formula, HC,inc,pre, OC) %>% 
    group_by(formula) %>% 
    dplyr::mutate(n = n())%>%
    filter(inc != 'NA')
  }
FTICRpre<- Filter_unique_FTICR("Pre")
 FTICR2<- Filter_unique_FTICR(2)
 FTICR4<- Filter_unique_FTICR(4)
 FTICR6<- Filter_unique_FTICR(6)
 FTICR8<- Filter_unique_FTICR(8)
 FTICR10<- Filter_unique_FTICR(10)
 
  FTICR_inc_unique_by_pre<- rbind(FTICR2,FTICR4,FTICR6,FTICR8,FTICR10,FTICRpre)
  
  gg_unique_sep_inc_pre =
    FTICR_inc_unique_by_pre %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = pre))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks at each inc")+
    scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    theme_CKM()
  
  gg_common_sep_inc_pre = 
    FTICR_inc_unique_by_pre %>% filter(n == 2) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "common peaks")+
    theme_CKM()
  
  
  
  
  
  
  
  
  
    inc.lab<-c("Pre","2 °C","4 °C","6 °C","8 °C","10 °C")
    names(inc.lab) <- c("Pre","2","4","6","8","10")
    
  gg_common_unique_sep_inc_pre_separated = 
    FTICR_inc_unique_by_pre %>%
    mutate(inc = factor(inc, levels=c("Pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    filter(n == 1)%>%
    gg_vankrev(aes(x = OC, y = HC, color=pre, alpha=0.7))+
    stat_ellipse(level = 0.75, show.legend = FALSE)+
    facet_wrap(~inc+pre,labeller = labeller(inc =inc.lab ))+
    labs(title = "Unique peaks by pre separated by incubation temp first")+
    scale_colour_manual(values=cbPalette, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    guides(color=guide_legend(title="Pre-incubation"),fill="none")+
    theme_CKM2()+
    theme(legend.position="top")
  
  gg_common_unique_sep_inc_pre = 
    FTICR_inc_unique_by_pre %>%
    mutate(inc = factor(inc, levels=c("Pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    filter(n == 1)%>%
    gg_vankrev(aes(x = OC, y = HC, color=pre, alpha=0.7))+
    stat_ellipse(level = 0.75, show.legend = FALSE)+
    facet_wrap(~inc,labeller = labeller(inc =inc.lab ))+
    labs(title = "Unique peaks by pre separated by incubation temp first")+
    scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    guides(color=guide_legend(title="Pre-incubation", override.aes = list(size = 3, alpha=1)),fill="none", alpha=F)+
    theme_CKM2()+
    theme(legend.position="top")
  
  fticr_unique_summary_sep_inc_pre = 
    FTICR_inc_unique_by_pre %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(inc,pre, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = c(pre,inc), values_from = counts)%>%
    select(c(Class, `-2_Pre`, `-6_Pre`,`-2_2`, `-6_2`, `-2_4`, `-6_4`, `-2_6`, `-6_6`, `-2_8`, `-6_8`, `-2_10`, `-6_10`))%>%
    knitr::kable(caption = "Unique between preincubation temperatures at each incubation temperature")
    #kableExtra::column_spec(c(3,5,7,9,11,13), italic = T,border_right = T,width = "4em")%>%
    #kableExtra::column_spec(c(2,4,6,8,10,12), width = "3em",background = "lightgrey")
  
  
    
  
  
  
  

  
  
  
  
  
  
  list(
       gg_unique_pre= gg_unique_pre,
       gg_common_unique=gg_common_unique,
       fticr_unique_summary=fticr_unique_summary,
       gg_common_unique_inc=gg_common_unique_inc,
       fticr_unique_summary_inc=fticr_unique_summary_inc,
       gg_common_unique_inc_pre=gg_common_unique_inc_pre,
       fticr_unique_summary_inc_pre=fticr_unique_summary_inc_pre,
       gg_common_unique_sep_inc_pre=gg_common_unique_sep_inc_pre,
       fticr_unique_summary_sep_inc_pre=fticr_unique_summary_sep_inc_pre,
       gg_common_unique_sep_inc_pre_separated=gg_common_unique_sep_inc_pre_separated
       
       
       
       
       
       
  )
  
}

plot_FTICR_unique_polar = function(FTICR_processed){
  

  fticr_meta  = FTICR_processed$fticr_meta_combined
  fticr_data_trt = FTICR_processed$fticr_data_trt_combined
  TREATMENTS = dplyr::quos(pre,inc, Polar)
  fticr_hcoc = 
    fticr_data_trt %>% 
    filter(Polar=="polar")%>%
    left_join(dplyr::select(fticr_meta, formula, HC, OC), by = "formula")%>%
    mutate(inc=factor(inc,levels=c("Pre",'2','4','6','8','10')))
  
  
  
  ## Unique peaks  by pre
  
  fticr_unique_pre = 
    fticr_hcoc %>% 
    distinct(formula, HC,pre, OC) %>% 
    group_by(formula) %>% 
    dplyr::mutate(n = n())
  
  gg_unique_pre =
    fticr_unique_pre %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = pre))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~pre)+
    labs(title = "Unique peaks by pre polar")+
    theme_CKM()
  
  gg_common = 
    fticr_unique_pre %>% filter(n == 2) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "common peaks polar")+
    theme_CKM()
  
  gg_common_unique = 
    fticr_unique_pre %>%
    filter(n == 2) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    geom_point(data = fticr_unique_pre %>% filter(n == 1),
               aes(color = pre), alpha = 0.7)+
    facet_wrap(~pre)+
    labs(title = "Unique peaks by pre",
         subtitle = "black/grey = peaks common to all polar")+
    theme_CKM()
  
  fticr_unique_summary = 
    fticr_unique_pre %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(pre, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = pre, values_from = counts)%>%
    knitr::kable()
  
  
  
  ## Unique peaks  by inc
  
  
  fticr_unique_inc = 
    fticr_hcoc %>% 
    distinct(formula, HC,inc, OC) %>% 
    group_by(formula) %>% 
    dplyr::mutate(n = n())%>%
    filter(inc != 'NA')
  
  gg_unique_inc =
    fticr_unique_inc %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = inc))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks at each inc polar")+
    theme_CKM()
  
  gg_common_inc = 
    fticr_unique_inc %>% filter(n == 7) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "common peaks polar")+
    theme_CKM()
  
  gg_common_unique_inc = 
    fticr_unique_inc %>% 
    filter(n == 7) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    geom_point(data = fticr_unique_inc %>% filter(n == 1),
               aes(color = inc), alpha = 0.7)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks by inc",
         subtitle = "black/grey = peaks common to all polar")+
    theme_CKM()
  
  fticr_unique_summary_inc = 
    fticr_unique_inc %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(inc, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = inc, values_from = counts)%>%
    select(c( Class,  Pre  ,`2` ,  `4` ,  `6`,   `8`, `10` )) %>%
    knitr::kable()
  
  
  
  ## Unique peaks  by inc and pre
  
  
  fticr_unique_inc_pre = 
    fticr_hcoc %>% 
    distinct(formula, HC,inc,pre, OC) %>% 
    group_by(formula) %>% 
    dplyr::mutate(n = n())%>%
    filter(inc != 'NA')
  
  gg_unique_inc_pre =
    fticr_unique_inc_pre %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = pre))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks at each inc polar")+
    theme_CKM()
  
  gg_common_inc_pre = 
    fticr_unique_inc_pre %>% filter(n == 14) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "common peaks polar")+
    theme_CKM()
  
  gg_common_unique_inc_pre = 
    fticr_unique_inc_pre %>% 
    filter(n == 14) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    geom_point(data = fticr_unique_inc_pre %>% filter(n == 1),
               aes(color = pre), alpha = 0.7)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks by inc and pre",
         subtitle = "black/grey = peaks common to all polar")+
    theme_CKM()
  
  fticr_unique_summary_inc_pre = 
    fticr_unique_inc_pre %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(inc,pre, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = c(pre,inc), values_from = counts)%>%
    select(c(Class, `-2_Pre`, `-6_Pre`,`-2_2`, `-6_2`, `-2_4`, `-6_4`, `-2_6`, `-6_6`, `-2_8`, `-6_8`, `-6_10`))%>%
    knitr::kable()
  
  
  
  
  
  
  
  
  
  
  #Unique by each inc temp
  Filter_unique_FTICR = function(TEMP){
    fticr_hcoc %>% 
      filter(inc== TEMP)%>%
      distinct(formula, HC,inc,pre, OC) %>% 
      group_by(formula) %>% 
      dplyr::mutate(n = n())%>%
      filter(inc != 'NA')
  }
  FTICRpre<- Filter_unique_FTICR("Pre")
  FTICR2<- Filter_unique_FTICR(2)
  FTICR4<- Filter_unique_FTICR(4)
  FTICR6<- Filter_unique_FTICR(6)
  FTICR8<- Filter_unique_FTICR(8)
  FTICR10<- Filter_unique_FTICR(10)
  
  FTICR_inc_unique_by_pre<- rbind(FTICR2,FTICR4,FTICR6,FTICR8,FTICR10,FTICRpre)
  
  FTICR_inc_unique_by_pre%>%
    filter(n == 1) %>%
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(Class) %>% 
    dplyr::summarise(counts = n())
  
  1088/(216+103+663+1088)
  
  
  
  gg_unique_sep_inc_pre =
    FTICR_inc_unique_by_pre %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = pre))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks at each inc polar")+
    theme_CKM()
  
  gg_common_sep_inc_pre = 
    FTICR_inc_unique_by_pre %>% filter(n == 2) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "common peaks polar")+
    theme_CKM()
  
  gg_common_unique_sep_inc_pre_separated = 
    FTICR_inc_unique_by_pre %>%
    mutate(inc = factor(inc, levels=c("Pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    filter(n == 1)%>%
    gg_vankrev(aes(x = OC, y = HC, color=pre, alpha=0.7))+
    stat_ellipse(level = 0.75, show.legend = FALSE)+
    facet_wrap(~inc+pre)+
    labs(title = "Unique peaks by pre separated by inc first")+
    guides(alpha= FALSE)+
    theme_CKM()
  
  gg_common_unique_sep_inc_pre = 
    FTICR_inc_unique_by_pre %>%
    mutate(inc = factor(inc, levels=c("Pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    filter(n == 1)%>%
    gg_vankrev(aes(x = OC, y = HC, color=pre, alpha=0.7))+
    stat_ellipse(level = 0.75, show.legend = FALSE)+
    facet_wrap(~inc)+
    labs(title = "Polar: Unique peaks by pre separated by inc first")+
    guides(alpha= FALSE)+
    theme_CKM()
  
  fticr_unique_summary_sep_inc_pre = 
    FTICR_inc_unique_by_pre %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(inc,pre, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = c(pre,inc), values_from = counts)%>%
    select(c(Class, `-2_Pre`, `-6_Pre`,`-2_2`, `-6_2`, `-2_4`, `-6_4`, `-2_6`, `-6_6`, `-2_8`, `-6_8`, `-2_10`, `-6_10`))%>%
    knitr::kable(caption = "Unique between preincubation temperatures at each incubation temperature polar")
    #kableExtra::column_spec(c(3,5,7,9,11,13), italic = T,border_right = T,width = "4em")
    #kableExtra::column_spec(c(2,4,6,8,10,12), width = "3em",background = "lightgrey")
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  list(
    gg_unique_pre= gg_unique_pre,
    gg_common_unique=gg_common_unique,
    fticr_unique_summary=fticr_unique_summary,
    gg_common_unique_inc=gg_common_unique_inc,
    fticr_unique_summary_inc=fticr_unique_summary_inc,
    gg_common_unique_inc_pre=gg_common_unique_inc_pre,
    fticr_unique_summary_inc_pre=fticr_unique_summary_inc_pre,
    gg_common_unique_sep_inc_pre=gg_common_unique_sep_inc_pre,
    fticr_unique_summary_sep_inc_pre=fticr_unique_summary_sep_inc_pre,
    gg_common_unique_sep_inc_pre_separated=gg_common_unique_sep_inc_pre_separated
     )
  
}

plot_FTICR_unique_nonpolar = function(FTICR_processed){
  

  fticr_meta  = FTICR_processed$fticr_meta_combined
  fticr_data_trt = FTICR_processed$fticr_data_trt_combined
  TREATMENTS = dplyr::quos(pre,inc, Polar)
  fticr_hcoc = 
    fticr_data_trt %>% 
    filter(Polar=="nonpolar")%>%
  left_join(dplyr::select(fticr_meta, formula, HC, OC), by = "formula")%>%
    mutate(inc=factor(inc,levels=c("Pre",'2','4','6','8','10')))
  
  
  
  ## Unique peaks  by pre
  
  fticr_unique_pre = 
    fticr_hcoc %>% 
    distinct(formula, HC,pre, OC) %>% 
    group_by(formula) %>% 
    dplyr::mutate(n = n())
  
  gg_unique_pre =
    fticr_unique_pre %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = pre))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~pre)+
    labs(title = "Unique peaks by pre nonpolar")+
    theme_CKM()
  
  gg_common = 
    fticr_unique_pre %>% filter(n == 2) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "common peaks nonpolar")+
    theme_CKM()
  
  gg_common_unique = 
    fticr_unique_pre %>%
    filter(n == 2) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    geom_point(data = fticr_unique_pre %>% filter(n == 1),
               aes(color = pre), alpha = 0.7)+
    facet_wrap(~pre)+
    labs(title = "Unique peaks by pre",
         subtitle = "black/grey = peaks common to all nonpolar")+
    theme_CKM()
  
  fticr_unique_summary = 
    fticr_unique_pre %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(pre, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = pre, values_from = counts)%>%
    knitr::kable()
  
  
  
  ## Unique peaks  by inc
  
  
  fticr_unique_inc = 
    fticr_hcoc %>% 
    distinct(formula, HC,inc, OC) %>% 
    group_by(formula) %>% 
    dplyr::mutate(n = n())%>%
    filter(inc != 'NA')
  
  gg_unique_inc =
    fticr_unique_inc %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = inc))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks at each inc nonpolar")+
    theme_CKM()
  
  gg_common_inc = 
    fticr_unique_inc %>% filter(n == 7) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.75, show.legend = FALSE)+
    labs(title = "common peaks nonpolar")+
    theme_CKM()
  
  gg_common_unique_inc = 
    fticr_unique_inc %>% 
    filter(n == 7) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    geom_point(data = fticr_unique_inc %>% filter(n == 1),
               aes(color = inc), alpha = 0.7)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks by inc",
         subtitle = "black/grey = peaks common to all nonpolar")+
    theme_CKM()
  
  fticr_unique_summary_inc = 
    fticr_unique_inc %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(inc, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = inc, values_from = counts)%>%
    select(c( Class,  Pre  ,`2` ,  `4` ,  `6`,   `8`, `10` )) %>%
    knitr::kable()
  
  
  
  ## Unique peaks  by inc and pre
  
  
  fticr_unique_inc_pre = 
    fticr_hcoc %>% 
    distinct(formula, HC,inc,pre, OC) %>% 
    group_by(formula) %>% 
    dplyr::mutate(n = n())%>%
    filter(inc != 'NA')
  
  gg_unique_inc_pre =
    fticr_unique_inc_pre %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = pre))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks at each inc nonpolar")+
    theme_CKM()
  
  gg_common_inc_pre = 
    fticr_unique_inc_pre %>% filter(n == 14) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.75, show.legend = FALSE)+
    labs(title = "common peaks nonpolar")+
    theme_CKM()
  
  gg_common_unique_inc_pre = 
    fticr_unique_inc_pre %>% 
    filter(n == 14) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    geom_point(data = fticr_unique_inc_pre %>% filter(n == 1),
               aes(color = pre), alpha = 0.7)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks by inc and pre",
         subtitle = "black/grey = peaks common to all nonpolar")+
    theme_CKM()
  
  fticr_unique_summary_inc_pre = 
    fticr_unique_inc_pre %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(inc,pre, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = c(pre,inc), values_from = counts)%>%
    select(c(Class, `-2_Pre`, `-6_Pre`,`-2_2`, `-6_2`, `-2_4`, `-6_4`, `-2_6`, `-2_8`, `-2_10`))%>%
    knitr::kable()
  
  
  
  
  
  
  
  
  
  
  #Unique by each inc temp
  Filter_unique_FTICR = function(TEMP){
    fticr_hcoc %>% 
      filter(inc== TEMP)%>%
      distinct(formula, HC,inc,pre, OC) %>% 
      group_by(formula) %>% 
      dplyr::mutate(n = n())%>%
      filter(inc != 'NA')
  }
  FTICRpre<- Filter_unique_FTICR("Pre")
  FTICR2<- Filter_unique_FTICR(2)
  FTICR4<- Filter_unique_FTICR(4)
  FTICR6<- Filter_unique_FTICR(6)
  FTICR8<- Filter_unique_FTICR(8)
  FTICR10<- Filter_unique_FTICR(10)
  
  FTICR_inc_unique_by_pre<- rbind(FTICR2,FTICR4,FTICR6,FTICR8,FTICR10,FTICRpre)
  
  FTICR_inc_unique_by_pre%>%
    filter(n == 1) %>%
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(Class) %>% 
    dplyr::summarise(counts = n())
  
  2742/(84+29+555+2742)
  
  
  
  
  gg_unique_sep_inc_pre =
    FTICR_inc_unique_by_pre %>% filter(n == 1) %>% 
    gg_vankrev(aes(x = OC, y = HC, color = pre))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    facet_wrap(~inc)+
    labs(title = "Unique peaks at each inc nonpolar")+
    theme_CKM()
  
  gg_common_sep_inc_pre = 
    FTICR_inc_unique_by_pre %>% filter(n == 2) %>% 
    gg_vankrev(aes(x = OC, y = HC))+
    stat_ellipse(level = 0.90, show.legend = FALSE)+
    labs(title = "common peaks nonpolar")+
    theme_CKM()
  
  gg_common_unique_sep_inc_pre_separated = 
    FTICR_inc_unique_by_pre %>%
    mutate(inc = factor(inc, levels=c("Pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    filter(n == 1)%>%
    gg_vankrev(aes(x = OC, y = HC, color=pre, alpha=0.7))+
    stat_ellipse(level = 0.75, show.legend = FALSE)+
    facet_wrap(~inc+pre)+
    labs(title = "Unique peaks by pre separated by inc first")+
    guides(alpha= FALSE)+
    theme_CKM()
  
  gg_common_unique_sep_inc_pre = 
    FTICR_inc_unique_by_pre %>%
    mutate(inc = factor(inc, levels=c("Pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    filter(n == 1)%>%
    gg_vankrev(aes(x = OC, y = HC, color=pre, alpha=0.7))+
    stat_ellipse(level = 0.75, show.legend = FALSE)+
    facet_wrap(~inc)+
    labs(title = "Non Polar: Unique peaks by pre separated by inc first")+
    guides(alpha= FALSE)+
    theme_CKM()
  
  fticr_unique_summary_sep_inc_pre = 
    FTICR_inc_unique_by_pre %>% 
    filter(n == 1) %>% 
    left_join(fticr_meta %>% dplyr::select(formula, Class)) %>% 
    group_by(inc,pre, Class) %>% 
    dplyr::summarise(counts = n())%>%
    pivot_wider(names_from = c(pre,inc), values_from = counts)%>%
    select(c(Class, `-2_Pre`, `-6_Pre`,`-2_2`, `-6_2`, `-2_4`, `-6_4`, `-2_6`, `-6_6`, `-2_8`, `-6_8`, `-2_10`, `-6_10`))%>%
    knitr::kable(caption = "Unique between preincubation temperatures at each incubation temperature nonpolar")
    #kableExtra::column_spec(c(3,5,7,9,11,13), italic = T,border_right = T,width = "4em")
    #kableExtra::column_spec(c(2,4,6,8,10,12), width = "3em",background = "lightgrey")
  
  
  
  
  
  
  
  
  
  
  
  
  list(
    gg_unique_pre= gg_unique_pre,
    gg_common_unique=gg_common_unique,
    fticr_unique_summary=fticr_unique_summary,
    gg_common_unique_inc=gg_common_unique_inc,
    fticr_unique_summary_inc=fticr_unique_summary_inc,
    gg_common_unique_inc_pre=gg_common_unique_inc_pre,
    fticr_unique_summary_inc_pre=fticr_unique_summary_inc_pre,
    gg_common_unique_sep_inc_pre=gg_common_unique_sep_inc_pre,
    fticr_unique_summary_sep_inc_pre=fticr_unique_summary_sep_inc_pre,
    gg_common_unique_sep_inc_pre_separated=gg_common_unique_sep_inc_pre_separated
  )
  
}

plot_FTICR_relabund = function(FTICR_relabund){
  
  
  inc.lab<-c("Pre","2 °C","4 °C","6 °C","8 °C","10 °C")
  names(inc.lab) <- c("Pre","2","4","6","8","10")
    
  
  
    
  relabund<-FTICR_relabund$relabund_trt2 %>% 
    mutate(inc = factor(inc, levels=c("Pre","2","4","6","8","10"))) %>%
    ggplot(aes(x = pre, y = rel_abund, fill = Class))+
    geom_bar(stat = "identity")+
    facet_grid(~inc,labeller = labeller(inc =inc.lab ))+
    theme_CKM()+
    ggtitle("relative abundance all")+
      xlab("Pre incubation temp (°C)")+
    scale_fill_manual(values=cbPalette2)
  
  relabund_p<-FTICR_relabund$relabund_trt_p %>% 
    mutate(inc = factor(inc, levels=c("Pre","2","4","6","8","10"))) %>%
    ggplot(aes(x = pre, y = rel_abund, fill = Class))+
    geom_bar(stat = "identity")+
    facet_grid(~inc,labeller = labeller(inc =inc.lab ))+
    theme_CKM()+
    ggtitle("relative abundance polar")+
    xlab("Pre incubation temp (°C)")+
    scale_fill_manual(values=cbPalette2)
  
  
  relabund_np<-FTICR_relabund$relabund_trt_np %>% 
    mutate(inc = factor(inc, levels=c("Pre","2","4","6","8","10"))) %>%
    ggplot(aes(x = pre, y = rel_abund, fill = Class))+
    geom_bar(stat = "identity")+
    facet_grid(~inc,labeller = labeller(inc =inc.lab ))+
    theme_CKM()+
    ggtitle("relative abundance non-polar")+
    xlab("Pre incubation temp (°C)")+
    scale_fill_manual(values=cbPalette2)
  
  
  

  
  
  
  
  
  list(
       relabund=relabund,
       relabund_p= relabund_p,
       relabund_np= relabund_np
       
       
       
       
       
  )
  
}

plot_FTICR_permanova = function(FTICR_relabund){
  
 
  
  permanova_fticr_all = 
    adonis2(FTICR_relabund$relabund_wide %>% dplyr::select(aliphatic:`condensed aromatic`) ~ pre * inc, 
            data = FTICR_relabund$relabund_wide) %>%
    knitr::kable(caption = "Permanova results: axis class all")
  permanova_fticr_polar = 
    adonis2(FTICR_relabund$relabund_wide_p %>% dplyr::select(aliphatic:`condensed aromatic`) ~ pre * inc, 
            data = FTICR_relabund$relabund_wide_p, na.rm=T) %>%
   knitr::kable(caption = "Permanova results: Axis class Polar only")
  permanova_fticr_nonpolar = 
    adonis2(FTICR_relabund$relabund_wide_np %>% dplyr::select(aliphatic:`condensed aromatic`) ~ pre * inc, 
            data = FTICR_relabund$relabund_wide_np, na.rm=T)%>%
    knitr::kable(caption = "Permanova results: Axis class Non-Polar only")

  permanova_fticr_all_with_polar = 
    adonis2(FTICR_relabund$relabund_wide %>% dplyr::select(aliphatic:`condensed aromatic`) ~ pre * inc *Polar, 
            data = FTICR_relabund$relabund_wide) %>%
    knitr::kable(caption = "Permanova results: Axis Class with Polar comparison")
  
  permanova_fticr_PolarSeperations = 
    adonis2(FTICR_relabund$relabund_wide_PolarVnonPolar %>% dplyr::select(polar:nonpolar) ~ pre * inc, 
            data = FTICR_relabund$relabund_wide_PolarVnonPolar) %>%
    knitr::kable(caption = "Permanova results: Axis Polar")
  


 
  
  
  
  
  list(
       permanova_fticr_all=permanova_fticr_all,
       permanova_fticr_polar=permanova_fticr_polar,
       permanova_fticr_nonpolar=permanova_fticr_nonpolar,
       permanova_fticr_PolarSeperations=permanova_fticr_PolarSeperations,
       permanova_fticr_all_with_polar=permanova_fticr_all_with_polar
       
       
       
       
       
  )
  
}

plot_FTICR_PCA = function(FTICR_relabund){

  ## 4b. PCA ----
  pca_all = fit_pca_function(FTICR_relabund$relabund_cores)
  pca_polar = fit_pca_function(FTICR_relabund$relabund_cores_p)
  pca_nonpolar = fit_pca_function(FTICR_relabund$relabund_cores_np)
  pca_PolarVsnonPolar = fit_pca_function2(FTICR_relabund$relabund_cores)

  

  
  gg_pca_polarVnonpolar_inc = 
    ggbiplot(pca_PolarVsnonPolar$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_PolarVsnonPolar$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(shape = as.character(pca_PolarVsnonPolar$grp$pre),
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  gg_pca_polarVnonpolar_pre = 
    ggbiplot(pca_PolarVsnonPolar$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_PolarVsnonPolar$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar = 
    ggbiplot(pca_all$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre = 
    ggbiplot(pca_all$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples")+
    theme_CKM()
  
  gg_pca_polar_nonpolar_inc = 
    ggbiplot(pca_all$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(shape = as.character(pca_all$grp$pre),
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples",
         subtitle = "separation by inc")+
    Scale_inc+
    theme_CKM()
  
  gg_pca_by_pre_polar = 
    ggbiplot(pca_polar$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0, varname.adjust = 1, varname.size = 5) +
    geom_point(size=2,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-5,5)+
    ylim(-4,4)+
    labs(shape="",
         title = "FTICR-Polar")+
    guides(color=guide_legend(title="Pre-incubation"),fill="none", alpha=F)+
    scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    theme_CKM3()+
  NULL
  
  gg_pca_by_pre_nonpolar = 
    ggbiplot(pca_nonpolar$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0, varname.adjust = 1, varname.size = 5) +
    geom_point(size=2,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-5,5)+
    ylim(-4,4)+
    labs(shape="",
         title = "FTICR-Non-Polar")+
    guides(color=guide_legend(title="Pre-incubation"),fill="none", alpha=F)+
    scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    theme_CKM3()+
    NULL
  
  
  
  gg_pca_by_inc_polar = 
    ggbiplot(pca_polar$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(shape = as.character(pca_polar$grp$pre),
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar",
         subtitle = "separation by inc")+
    Scale_inc+
    theme_CKM()+
    NULL
  
  gg_pca_by_inc_nonpolar = 
    ggbiplot(pca_nonpolar$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(shape = as.character(pca_nonpolar$grp$pre),
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar",
         subtitle = "separation by inc")+
    Scale_inc+
    theme_CKM()+
    NULL
  
  Nutrient_legend = get_legend(gg_pca_by_pre_polar + theme(legend.position = "bottom"))
  gg_Ncombine= plot_grid(
    gg_pca_by_pre_polar + theme(legend.position="none"),
    gg_pca_by_pre_nonpolar + theme(legend.position="none"),
    align = 'vh',
    labels = c("A", "B"),
    label_y= 0.93,
    hjust = -1,
    vjust= 12,
    nrow = 1
  )
  gg_PCA_Legend=plot_grid(gg_Ncombine,NULL,Nutrient_legend, ncol=1, rel_heights =c(1,-0.25,0.1), rel_widths = c(1,1))
  
  ggsave("Graphs/FTICR_PCA.png",gg_PCA_Legend, width=12, height=8)
  
  list(
       gg_pca_polar_nonpolar= gg_pca_polar_nonpolar,
       gg_pca_by_pre_polar=gg_pca_by_pre_polar,
       gg_pca_by_pre_nonpolar=gg_pca_by_pre_nonpolar,
       gg_pca_by_inc_polar=gg_pca_by_inc_polar,
       gg_pca_by_inc_nonpolar=gg_pca_by_inc_nonpolar,
       gg_pca_polar_nonpolar_pre=gg_pca_polar_nonpolar_pre,
       gg_pca_polar_nonpolar_inc=gg_pca_polar_nonpolar_inc,
       gg_pca_polarVnonpolar_pre=gg_pca_polarVnonpolar_pre,
       gg_pca_polarVnonpolar_inc=gg_pca_polarVnonpolar_inc,
       gg_PCA_Legend=gg_PCA_Legend
       
       
       
       
  )
  
}

plot_FTICR_PCA_DetailedClass = function(FTICR_relabund2){
  
  ## 4b. PCA ----
  pca_all = fit_pca_function3(FTICR_relabund2$relabund_cores)
  pca_polar = fit_pca_function3(FTICR_relabund2$relabund_cores_p)
  pca_nonpolar = fit_pca_function3(FTICR_relabund2$relabund_cores_np)

  gg_pca_polar_nonpolar = 
    ggbiplot(pca_all$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples Detailed Class",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre = 
    ggbiplot(pca_all$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()
  
  gg_pca_polar_nonpolar_inc = 
    ggbiplot(pca_all$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(shape = as.character(pca_all$grp$pre),
                   color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples Detailed Class",
         subtitle = "separation by inc")+
    Scale_inc+
    theme_CKM()
  
  gg_pca_by_pre_polar = 
    ggbiplot(pca_polar$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar = 
    ggbiplot(pca_nonpolar$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()+
    NULL
  
  
  
  gg_pca_by_inc_polar = 
    ggbiplot(pca_polar$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(shape = as.character(pca_polar$grp$pre),
                   color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar Detailed Class",
         subtitle = "separation by inc")+
    Scale_inc+
    theme_CKM()+
    NULL
  
  gg_pca_by_inc_nonpolar = 
    ggbiplot(pca_nonpolar$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(shape = as.character(pca_nonpolar$grp$pre),
                   color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar Detailed Class",
         subtitle = "separation by inc")+
    Scale_inc+
    theme_CKM()+
    NULL
  
  Nutrient_legend = get_legend(gg_pca_by_pre_polar+ guides(color = guide_legend(nrow = 1)) +
                                 theme(legend.position = "bottom"))
  gg_Ncombine= plot_grid(
    gg_pca_by_pre_polar + theme(legend.position="none"),
    gg_pca_by_pre_nonpolar + theme(legend.position="none"),
    align = 'vh',
    labels = c("A", "B"),
    label_y= 0.93,
    hjust = -1,
    nrow = 1
  )
  gg_PCA_Legend=plot_grid(gg_Ncombine,Nutrient_legend, ncol=1, rel_heights =c(1,0.03))
  
  
  
  list(
    gg_pca_polar_nonpolar= gg_pca_polar_nonpolar,
    gg_pca_by_pre_polar=gg_pca_by_pre_polar,
    gg_pca_by_pre_nonpolar=gg_pca_by_pre_nonpolar,
    gg_pca_by_inc_polar=gg_pca_by_inc_polar,
    gg_pca_by_inc_nonpolar=gg_pca_by_inc_nonpolar,
    gg_pca_polar_nonpolar_pre=gg_pca_polar_nonpolar_pre,
    gg_pca_polar_nonpolar_inc=gg_pca_polar_nonpolar_inc,
    gg_PCA_Legend=gg_PCA_Legend
    
    
    
    
  )
  
}

plot_FTICR_PCA_filter = function(FTICR_relabund_filter){
  
  ## 4b. PCA ----
  pca_all_Pre = fit_pca_function(FTICR_relabund_filter$relabund_cores_Pre)
  pca_polar_Pre = fit_pca_function(FTICR_relabund_filter$relabund_cores_p_Pre)
  pca_nonpolar_Pre = fit_pca_function(FTICR_relabund_filter$relabund_cores_np_Pre)
  pca_all_2 = fit_pca_function(FTICR_relabund_filter$relabund_cores_2)
  pca_polar_2 = fit_pca_function(FTICR_relabund_filter$relabund_cores_p_2)
  pca_nonpolar_2 = fit_pca_function(FTICR_relabund_filter$relabund_cores_np_2)
  pca_all_4 = fit_pca_function(FTICR_relabund_filter$relabund_cores_4)
  pca_polar_4 = fit_pca_function(FTICR_relabund_filter$relabund_cores_p_4)
  pca_nonpolar_4 = fit_pca_function(FTICR_relabund_filter$relabund_cores_np_4)
  pca_all_6 = fit_pca_function(FTICR_relabund_filter$relabund_cores_6)
  pca_polar_6 = fit_pca_function(FTICR_relabund_filter$relabund_cores_p_6)
  pca_nonpolar_6 = fit_pca_function(FTICR_relabund_filter$relabund_cores_np_6)
  pca_all_8 = fit_pca_function(FTICR_relabund_filter$relabund_cores_8)
  pca_polar_8 = fit_pca_function(FTICR_relabund_filter$relabund_cores_p_8)
  pca_nonpolar_8 = fit_pca_function(FTICR_relabund_filter$relabund_cores_np_8)
  pca_all_10 = fit_pca_function(FTICR_relabund_filter$relabund_cores_10)
  pca_polar_10 = fit_pca_function(FTICR_relabund_filter$relabund_cores_p_10)
  pca_nonpolar_10 = fit_pca_function(FTICR_relabund_filter$relabund_cores_np_10)
  
  
  
  ####PRE
  gg_pca_polar_nonpolar_Pre = 
    ggbiplot(pca_all_Pre$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_Pre$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_PRE only",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_Pre = 
    ggbiplot(pca_all_Pre$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_Pre$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_PRE only",
         subtitle = "separation by pre")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_Pre = 
    ggbiplot(pca_polar_Pre$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_Pre$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_PRE only",
         subtitle = "separation by pre")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_Pre = 
    ggbiplot(pca_nonpolar_Pre$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_Pre$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_PRE only",
         subtitle = "separation by pre")+
    theme_CKM()+
    NULL
  
  ####2
  gg_pca_polar_nonpolar_2 = 
    ggbiplot(pca_all_2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_2$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_2 only",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_2 = 
    ggbiplot(pca_all_2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_2$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_2 only",
         subtitle = "separation by pre")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_2 = 
    ggbiplot(pca_polar_2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_2$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_2 only",
         subtitle = "separation by pre")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_2 = 
    ggbiplot(pca_nonpolar_2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_2$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_2 only",
         subtitle = "separation by pre")+
    theme_CKM()+
    NULL
  
  ####4
  gg_pca_polar_nonpolar_4 = 
    ggbiplot(pca_all_4$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_4$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(41, 44, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_4 only",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_4 = 
    ggbiplot(pca_all_4$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_4$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(41, 44, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_4 only",
         subtitle = "separation by pre")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_4 = 
    ggbiplot(pca_polar_4$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_4$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(41, 44, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_4 only",
         subtitle = "separation by pre")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_4 = 
    ggbiplot(pca_nonpolar_4$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_4$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(41, 44, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_4 only",
         subtitle = "separation by pre")+
    theme_CKM()+
    NULL
  
  ####6
  gg_pca_polar_nonpolar_6 = 
    ggbiplot(pca_all_6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_6$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(61, 66, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_6 only",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_6 = 
    ggbiplot(pca_all_6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_6$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(61, 66, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_6 only",
         subtitle = "separation by pre")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_6 = 
    ggbiplot(pca_polar_6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_6$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(61, 66, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_6 only",
         subtitle = "separation by pre")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_6 = 
    ggbiplot(pca_nonpolar_6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_6$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(61, 66, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_6 only",
         subtitle = "separation by pre")+
    theme_CKM()+
    NULL
  
  ####8
  gg_pca_polar_nonpolar_8 = 
    ggbiplot(pca_all_8$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_8$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(81, 88, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_8 only",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_8 = 
    ggbiplot(pca_all_8$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_8$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(81, 88, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_8 only",
         subtitle = "separation by pre")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_8 = 
    ggbiplot(pca_polar_8$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_8$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(81, 88, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_8 only",
         subtitle = "separation by pre")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_8 = 
    ggbiplot(pca_nonpolar_8$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_8$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(81, 88, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_8 only",
         subtitle = "separation by pre")+
    theme_CKM()+
    NULL
  ####10
  gg_pca_polar_nonpolar_10 = 
    ggbiplot(pca_all_10$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_10$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(101, 1010, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_10 only",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_10 = 
    ggbiplot(pca_all_10$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_10$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(101, 1010, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_10 only",
         subtitle = "separation by pre")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_10 = 
    ggbiplot(pca_polar_10$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_10$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(101, 1010, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_10 only",
         subtitle = "separation by pre")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_10 = 
    ggbiplot(pca_nonpolar_10$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_10$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(101, 1010, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_10 only",
         subtitle = "separation by pre")+
    theme_CKM()+
    NULL
  
  list(
    gg_pca_polar_nonpolar_Pre= gg_pca_polar_nonpolar_Pre,
    gg_pca_by_pre_polar_Pre=gg_pca_by_pre_polar_Pre,
    gg_pca_by_pre_nonpolar_Pre=gg_pca_by_pre_nonpolar_Pre,
    gg_pca_polar_nonpolar_pre_Pre=gg_pca_polar_nonpolar_pre_Pre,
    gg_pca_polar_nonpolar_2= gg_pca_polar_nonpolar_2,
    gg_pca_by_pre_polar_2=gg_pca_by_pre_polar_2,
    gg_pca_by_pre_nonpolar_2=gg_pca_by_pre_nonpolar_2,
    gg_pca_polar_nonpolar_pre_2=gg_pca_polar_nonpolar_pre_2,
    gg_pca_polar_nonpolar_4= gg_pca_polar_nonpolar_4,
    gg_pca_by_pre_polar_4=gg_pca_by_pre_polar_4,
    gg_pca_by_pre_nonpolar_4=gg_pca_by_pre_nonpolar_4,
    gg_pca_polar_nonpolar_pre_4=gg_pca_polar_nonpolar_pre_4,
    gg_pca_polar_nonpolar_6= gg_pca_polar_nonpolar_6,
    gg_pca_by_pre_polar_6=gg_pca_by_pre_polar_6,
    gg_pca_by_pre_nonpolar_6=gg_pca_by_pre_nonpolar_6,
    gg_pca_polar_nonpolar_pre_6=gg_pca_polar_nonpolar_pre_6,
    gg_pca_polar_nonpolar_8= gg_pca_polar_nonpolar_8,
    gg_pca_by_pre_polar_8=gg_pca_by_pre_polar_8,
    gg_pca_by_pre_nonpolar_8=gg_pca_by_pre_nonpolar_8,
    gg_pca_polar_nonpolar_pre_8=gg_pca_polar_nonpolar_pre_8,
    gg_pca_polar_nonpolar_10= gg_pca_polar_nonpolar_10,
    gg_pca_by_pre_polar_10=gg_pca_by_pre_polar_10,
    gg_pca_by_pre_nonpolar_10=gg_pca_by_pre_nonpolar_10,
    gg_pca_polar_nonpolar_pre_10=gg_pca_polar_nonpolar_pre_10
    
    
    
    
    
  )
  
}

plot_FTICR_PCA_filter_DetailedClass = function(FTICR_relabund_filter2){
  
  ## 4b. PCA ----
  pca_all_Pre = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_Pre)
  pca_polar_Pre = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_p_Pre)
  pca_nonpolar_Pre = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_np_Pre)
  pca_all_2 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_2)
  pca_polar_2 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_p_2)
  pca_nonpolar_2 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_np_2)
  pca_all_4 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_4)
  pca_polar_4 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_p_4)
  pca_nonpolar_4 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_np_4)
  pca_all_6 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_6)
  pca_polar_6 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_p_6)
  pca_nonpolar_6 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_np_6)
  pca_all_8 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_8)
  pca_polar_8 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_p_8)
  pca_nonpolar_8 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_np_8)
  pca_all_10 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_10)
  pca_polar_10 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_p_10)
  pca_nonpolar_10 = fit_pca_function3(FTICR_relabund_filter2$relabund_cores_np_10)
  
  
  
  ####PRE
  gg_pca_polar_nonpolar_Pre = 
    ggbiplot(pca_all_Pre$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_Pre$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_PRE only Detailed Class",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_Pre = 
    ggbiplot(pca_all_Pre$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_Pre$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_PRE only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_Pre = 
    ggbiplot(pca_polar_Pre$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_Pre$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_PRE only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_Pre = 
    ggbiplot(pca_nonpolar_Pre$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_Pre$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_PRE only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()+
    NULL
  
  ####2
  gg_pca_polar_nonpolar_2 = 
    ggbiplot(pca_all_2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_2$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_2 only Detailed Class",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_2 = 
    ggbiplot(pca_all_2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_2$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_2 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_2 = 
    ggbiplot(pca_polar_2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_2$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_2 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_2 = 
    ggbiplot(pca_nonpolar_2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_2$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_2 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()+
    NULL
  
  ####4
  gg_pca_polar_nonpolar_4 = 
    ggbiplot(pca_all_4$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_4$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(41, 44, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_4 only Detailed Class",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_4 = 
    ggbiplot(pca_all_4$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_4$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(41, 44, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_4 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_4 = 
    ggbiplot(pca_polar_4$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_4$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(41, 44, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_4 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_4 = 
    ggbiplot(pca_nonpolar_4$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_4$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(41, 44, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_4 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()+
    NULL
  
  ####6
  gg_pca_polar_nonpolar_6 = 
    ggbiplot(pca_all_6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_6$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(61, 66, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_6 only Detailed Class",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_6 = 
    ggbiplot(pca_all_6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_6$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(61, 66, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_6 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_6 = 
    ggbiplot(pca_polar_6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_6$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(61, 66, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_6 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_6 = 
    ggbiplot(pca_nonpolar_6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_6$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(61, 66, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_6 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()+
    NULL
  
  ####8
  gg_pca_polar_nonpolar_8 = 
    ggbiplot(pca_all_8$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_8$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(81, 88, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_8 only Detailed Class",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_8 = 
    ggbiplot(pca_all_8$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_8$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(81, 88, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_8 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_8 = 
    ggbiplot(pca_polar_8$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_8$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(81, 88, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_8 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_8 = 
    ggbiplot(pca_nonpolar_8$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_8$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(81, 88, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_8 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()+
    NULL
  ####10
  gg_pca_polar_nonpolar_10 = 
    ggbiplot(pca_all_10$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_10$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(101, 1010, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_10 only Detailed Class",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_10 = 
    ggbiplot(pca_all_10$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_10$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(101, 1010, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_10 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_10 = 
    ggbiplot(pca_polar_10$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_10$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(101, 1010, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_10 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_10 = 
    ggbiplot(pca_nonpolar_10$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_10$grp$pre), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(101, 1010, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_10 only Detailed Class",
         subtitle = "separation by pre")+
    theme_CKM()+
    NULL
  
  list(
    gg_pca_polar_nonpolar_Pre= gg_pca_polar_nonpolar_Pre,
    gg_pca_by_pre_polar_Pre=gg_pca_by_pre_polar_Pre,
    gg_pca_by_pre_nonpolar_Pre=gg_pca_by_pre_nonpolar_Pre,
    gg_pca_polar_nonpolar_pre_Pre=gg_pca_polar_nonpolar_pre_Pre,
    gg_pca_polar_nonpolar_2= gg_pca_polar_nonpolar_2,
    gg_pca_by_pre_polar_2=gg_pca_by_pre_polar_2,
    gg_pca_by_pre_nonpolar_2=gg_pca_by_pre_nonpolar_2,
    gg_pca_polar_nonpolar_pre_2=gg_pca_polar_nonpolar_pre_2,
    gg_pca_polar_nonpolar_4= gg_pca_polar_nonpolar_4,
    gg_pca_by_pre_polar_4=gg_pca_by_pre_polar_4,
    gg_pca_by_pre_nonpolar_4=gg_pca_by_pre_nonpolar_4,
    gg_pca_polar_nonpolar_pre_4=gg_pca_polar_nonpolar_pre_4,
    gg_pca_polar_nonpolar_6= gg_pca_polar_nonpolar_6,
    gg_pca_by_pre_polar_6=gg_pca_by_pre_polar_6,
    gg_pca_by_pre_nonpolar_6=gg_pca_by_pre_nonpolar_6,
    gg_pca_polar_nonpolar_pre_6=gg_pca_polar_nonpolar_pre_6,
    gg_pca_polar_nonpolar_8= gg_pca_polar_nonpolar_8,
    gg_pca_by_pre_polar_8=gg_pca_by_pre_polar_8,
    gg_pca_by_pre_nonpolar_8=gg_pca_by_pre_nonpolar_8,
    gg_pca_polar_nonpolar_pre_8=gg_pca_polar_nonpolar_pre_8,
    gg_pca_polar_nonpolar_10= gg_pca_polar_nonpolar_10,
    gg_pca_by_pre_polar_10=gg_pca_by_pre_polar_10,
    gg_pca_by_pre_nonpolar_10=gg_pca_by_pre_nonpolar_10,
    gg_pca_polar_nonpolar_pre_10=gg_pca_polar_nonpolar_pre_10
    
    
    
    
    
  )
  
}

plot_FTICR_PCA_filter_N2N6 = function(FTICR_relabund_filter_N2N6){
  
  ## 4b. PCA ----
  pca_all_N2 = fit_pca_function(FTICR_relabund_filter_N2N6$relabund_cores_N2)
  pca_polar_N2 = fit_pca_function(FTICR_relabund_filter_N2N6$relabund_cores_p_N2)
  pca_nonpolar_N2 = fit_pca_function(FTICR_relabund_filter_N2N6$relabund_cores_np_N2)
  pca_all_N6 = fit_pca_function(FTICR_relabund_filter_N2N6$relabund_cores_N6)
  pca_polar_N6 = fit_pca_function(FTICR_relabund_filter_N2N6$relabund_cores_p_N6)
  pca_nonpolar_N6 = fit_pca_function(FTICR_relabund_filter_N2N6$relabund_cores_np_N6)
  
  
  
  
  ####PRE
  gg_pca_polar_nonpolar_N2 = 
    ggbiplot(pca_all_N2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_N2$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_N2 only",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_N2 = 
    ggbiplot(pca_all_N2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_N2$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_N2 only",
         subtitle = " ")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_N2 = 
    ggbiplot(pca_polar_N2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_N2$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_N2 only",
         subtitle = " ")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_N2 = 
    ggbiplot(pca_nonpolar_N2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_N2$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_N2 only",
         subtitle = " ")+
    theme_CKM()+
    NULL
  
  ####2
  gg_pca_polar_nonpolar_N6 = 
    ggbiplot(pca_all_N6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_N6$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_N6 only",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_N6 = 
    ggbiplot(pca_all_N6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_N6$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_N6 only",
         subtitle = " ")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_N6 = 
    ggbiplot(pca_polar_N6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_N6$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_N6 only",
         subtitle = " ")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_N6 = 
    ggbiplot(pca_nonpolar_N6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_N6$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_N6 only",
         subtitle = " ")+
    theme_CKM()+
    NULL
  
 
  
  list(
    gg_pca_polar_nonpolar_N2= gg_pca_polar_nonpolar_N2,
    gg_pca_by_pre_polar_N2=gg_pca_by_pre_polar_N2,
    gg_pca_by_pre_nonpolar_N2=gg_pca_by_pre_nonpolar_N2,
    gg_pca_polar_nonpolar_pre_N2=gg_pca_polar_nonpolar_pre_N2,
    gg_pca_polar_nonpolar_N6= gg_pca_polar_nonpolar_N6,
    gg_pca_by_pre_polar_N6=gg_pca_by_pre_polar_N6,
    gg_pca_by_pre_nonpolar_N6=gg_pca_by_pre_nonpolar_N6,
    gg_pca_polar_nonpolar_pre_N6=gg_pca_polar_nonpolar_pre_N6
    
    
    
    
    
  )
  
}

plot_FTICR_PCA_filter_N2N6_2 = function(FTICR_relabund_filter_N2N6_2){
  
  ## 4b. PCA ----
  pca_all_N2 = fit_pca_function3(FTICR_relabund_filter_N2N6_2$relabund_cores_N2)
  pca_polar_N2 = fit_pca_function3(FTICR_relabund_filter_N2N6_2$relabund_cores_p_N2)
  pca_nonpolar_N2 = fit_pca_function3(FTICR_relabund_filter_N2N6_2$relabund_cores_np_N2)
  pca_all_N6 = fit_pca_function3(FTICR_relabund_filter_N2N6_2$relabund_cores_N6)
  pca_polar_N6 = fit_pca_function3(FTICR_relabund_filter_N2N6_2$relabund_cores_p_N6)
  pca_nonpolar_N6 = fit_pca_function3(FTICR_relabund_filter_N2N6_2$relabund_cores_np_N6)
  
  
  
  
  ####PRE
  gg_pca_polar_nonpolar_N2 = 
    ggbiplot(pca_all_N2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_N2$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_N2 only Detailed Class",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_N2 = 
    ggbiplot(pca_all_N2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_N2$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_N2 only Detailed Class",
         subtitle = " ")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_N2 = 
    ggbiplot(pca_polar_N2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_N2$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_N2 only Detailed Class",
         subtitle = " ")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_N2 = 
    ggbiplot(pca_nonpolar_N2$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_N2$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_N2 only Detailed Class",
         subtitle = " ")+
    theme_CKM()+
    NULL
  
  ####2
  gg_pca_polar_nonpolar_N6 = 
    ggbiplot(pca_all_N6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_N6$grp$Polar), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_N6 only Detailed Class",
         subtitle = "polar vs. nonpolar")+
    theme_CKM()
  
  
  
  gg_pca_polar_nonpolar_pre_N6 = 
    ggbiplot(pca_all_N6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_all_N6$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-all samples_N6 only Detailed Class",
         subtitle = " ")+
    theme_CKM()
  
  
  gg_pca_by_pre_polar_N6 = 
    ggbiplot(pca_polar_N6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_polar_N6$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Polar_N6 only Detailed Class",
         subtitle = " ")+
    theme_CKM()+
    theme(legend.background = element_rect(fill = "white"),
          legend.margin=margin(t=-55))
  NULL
  
  gg_pca_by_pre_nonpolar_N6 = 
    ggbiplot(pca_nonpolar_N6$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_nonpolar_N6$grp$inc), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=3,stroke=1, alpha = 0.5,
               aes(#shape = groups,
                 color = groups))+
    #scale_shape_manual(values = c(21, 22, 19), name = "", guide = "none")+
    xlim(-4,4)+
    ylim(-3.5,3.5)+
    labs(shape="",
         title = "FTICR-Non-Polar_N6 only Detailed Class",
         subtitle = " ")+
    theme_CKM()+
    NULL
  
  
  
  list(
    gg_pca_polar_nonpolar_N2= gg_pca_polar_nonpolar_N2,
    gg_pca_by_pre_polar_N2=gg_pca_by_pre_polar_N2,
    gg_pca_by_pre_nonpolar_N2=gg_pca_by_pre_nonpolar_N2,
    gg_pca_polar_nonpolar_pre_N2=gg_pca_polar_nonpolar_pre_N2,
    gg_pca_polar_nonpolar_N6= gg_pca_polar_nonpolar_N6,
    gg_pca_by_pre_polar_N6=gg_pca_by_pre_polar_N6,
    gg_pca_by_pre_nonpolar_N6=gg_pca_by_pre_nonpolar_N6,
    gg_pca_polar_nonpolar_pre_N6=gg_pca_polar_nonpolar_pre_N6
    
    
    
    
    
  )
  
}

plot_FTICR_PLS= function(FTICR_relabund){
  library(ropls)
  ##Data reorganization
  nameH<-c(1:215)
  nameP<-c(1:108)
  namePN2<-c(1:44)
  namePN6<-c(1:64)
  nameNP6<-c(1:83)
  nameNP2<-c(1:24)
  Data_PLS_P6<- FTICR_relabund$relabund_wide %>%
    filter(Polar=='polar', pre=='-6')%>%
    select(CoreID,aliphatic,`unsaturated/lignin`,aromatic,`condensed aromatic`)
  Data_PLS_P6<-as.data.frame(Data_PLS_P6)
  Data_PLS_P6_1 <- as.matrix(Data_PLS_P6[, colnames(Data_PLS_P6) != "CoreID"])
  rownames(Data_PLS_P6_1) <- namePN6
  
  Meta_PLS_P6<-FTICR_relabund$relabund_wide %>%
    filter(Polar=='polar', pre=='-6')%>%
    select(-c(aliphatic,`unsaturated/lignin`,aromatic,`condensed aromatic`))
  Meta_PLS_P6<-as.data.frame(Meta_PLS_P6)
  Meta_PLS_P6_1 <- as.matrix(Meta_PLS_P6[, colnames(Meta_PLS_P6) != "CoreID"])
  rownames(Meta_PLS_P6_1) <- namePN6
  
  
  Data_PLS_P2<- FTICR_relabund$relabund_wide %>%
    filter(Polar=='polar', pre=='-2')%>%
    select(CoreID,aliphatic,`unsaturated/lignin`,aromatic,`condensed aromatic`)
  Data_PLS_P2<-as.data.frame(Data_PLS_P2)
  Data_PLS_P2_1 <- as.matrix(Data_PLS_P2[, colnames(Data_PLS_P2) != "CoreID"])
  rownames(Data_PLS_P2_1) <- namePN2
  
  Meta_PLS_P2<-FTICR_relabund$relabund_wide %>%
    filter(Polar=='polar', pre=='-2')%>%
    select(-c(aliphatic,`unsaturated/lignin`,aromatic,`condensed aromatic`))
  Meta_PLS_P2<-as.data.frame(Meta_PLS_P2)
  Meta_PLS_P2_1 <- as.matrix(Meta_PLS_P2[, colnames(Meta_PLS_P2) != "CoreID"])
  rownames(Meta_PLS_P2_1) <- namePN2
  
  

  ##Polar PLS-DA
  
  PLS_DA_P6 = opls(Data_PLS_P6_1,Meta_PLS_P6_1[, "inc"],predI = 2)
  PLS_DA_P2 = opls(Data_PLS_P2_1,Meta_PLS_P2_1[, "inc"],predI = 2)
  
  ggplot_FTICR_PLS= function(PLS_DA_P6,Meta_PLS_P6_1){
    DF<-data.frame(PLS_DA_P6@scoreMN)
    DF2<-data.frame(Meta_PLS_P6_1)
    DF$ID<-rownames(DF)
    DF2$ID<-rownames(DF2)
    DFT<-DF%>%
      left_join(DF2, by="ID")
    
    DFT%>%
      ggplot(aes(x=p1,y=p2, color=inc))+
      geom_point()+
      stat_ellipse()+
      theme_CKM()
    
    
    
    
    
    
    
    
    
  }
  
  
  
  
  PolarPLS6<- ggplot_FTICR_PLS(PLS_DA_P6, Meta_PLS_P6_1)
  PolarPLS2<-ggplot_FTICR_PLS(PLS_DA_P2, Meta_PLS_P2_1)
 
  
  #### Non polar PLS-DA
  Data_PLS_NP6<- FTICR_relabund$relabund_wide %>%
    filter(Polar=='nonpolar', pre=='-6')%>%
    select(CoreID,aliphatic,`unsaturated/lignin`,aromatic,`condensed aromatic`)
  Data_PLS_NP6<-as.data.frame(Data_PLS_NP6)
  Data_PLS_NP6_1 <- as.matrix(Data_PLS_NP6[, colnames(Data_PLS_NP6) != "CoreID"])
  rownames(Data_PLS_NP6_1) <- nameNP6
  
  Meta_PLS_NP6<-FTICR_relabund$relabund_wide %>%
    filter(Polar=='nonpolar', pre=='-6')%>%
    select(-c(aliphatic,`unsaturated/lignin`,aromatic,`condensed aromatic`))
  Meta_PLS_NP6<-as.data.frame(Meta_PLS_NP6)
  Meta_PLS_NP6_1 <- as.matrix(Meta_PLS_NP6[, colnames(Meta_PLS_NP6) != "CoreID"])
  rownames(Meta_PLS_NP6_1) <- nameNP6
  
  
  Data_PLS_NP2<- FTICR_relabund$relabund_wide %>%
    filter(Polar=='nonpolar', pre=='-2')%>%
    select(CoreID,aliphatic,`unsaturated/lignin`,aromatic,`condensed aromatic`)
  Data_PLS_NP2<-as.data.frame(Data_PLS_NP2)
  Data_PLS_NP2_1 <- as.matrix(Data_PLS_NP2[, colnames(Data_PLS_NP2) != "CoreID"])
  rownames(Data_PLS_NP2_1) <- nameNP2
  
  Meta_PLS_NP2<-FTICR_relabund$relabund_wide %>%
    filter(Polar=='nonpolar', pre=='-2')%>%
    select(-c(aliphatic,`unsaturated/lignin`,aromatic,`condensed aromatic`))
  Meta_PLS_NP2<-as.data.frame(Meta_PLS_NP2)
  Meta_PLS_NP2_1 <- as.matrix(Meta_PLS_NP2[, colnames(Meta_PLS_NP2) != "CoreID"])
  rownames(Meta_PLS_NP2_1) <- nameNP2
  ##nonPolar PLS-DA
  
  PLS_DA_NP6 = opls(Data_PLS_NP6_1,Meta_PLS_NP6_1[, "inc"],predI = 2)
  PLS_DA_NP2 = opls(Data_PLS_NP2_1,Meta_PLS_NP2_1[, "inc"],predI = 2)
  nonPolarPLS6<-ggplot_FTICR_PLS(PLS_DA_NP6, Meta_PLS_NP6_1)
  nonPolarPLS2<-ggplot_FTICR_PLS(PLS_DA_NP2, Meta_PLS_NP2_1)
  
  
  list(PolarPLS6=PolarPLS6,
       PolarPLS2=PolarPLS2,
       nonPolarPLS6=nonPolarPLS6,
       nonPolarPLS2=nonPolarPLS2
    
  )
  
}


