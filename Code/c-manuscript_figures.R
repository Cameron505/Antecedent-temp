plot_respiration_MS = function(respiration_processed){
  
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
  
  LASTRES<- respiration_processed %>%
    filter(JD2==5)
  
  
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
  
  list(gg_N_Legend=gg_N_Legend

  )
  
}

plot_nutrients_MS = function(nutrients_data){
  
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
  
  

  #Graphs commented out geom_text is for abc labels
  
  nutrients_data[nutrients_data == "none"] <- "T0"
  
  
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
  
  list("Total reducing sugars" = gg_TRS,
    "Nutrient combined"=gg_N_Legend
    
    
  )
  
}

plot_MicrobialBiomass_MS = function(nutrients_data){
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
  
  list(gg_Biomass_Legend=gg_Biomass_Legend
       
  )
  
}

plot_FTICR_PCA_MS = function(FTICR_relabund){
  
  ## 4b. PCA ----
  pca_all = fit_pca_function(FTICR_relabund$relabund_cores)
  pca_polar = fit_pca_function(FTICR_relabund$relabund_cores_p)
  pca_nonpolar = fit_pca_function(FTICR_relabund$relabund_cores_np)
  pca_PolarVsnonPolar = fit_pca_function2(FTICR_relabund$relabund_cores)
  

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
  
  list(gg_PCA_Legend=gg_PCA_Legend
    
    
    
    
  )
  
}

plot_LC_GC_PCA_MS = function(gg_LC_PCA,gg_GC_PCA){
  
  
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

plot_FTICR_unique_all_MS = function(FTICR_processed){
  
  fticr_meta  = FTICR_processed$fticr_meta_combined
  fticr_data_longform = FTICR_processed$fticr_data_longform_combined
  fticr_data_trt = FTICR_processed$fticr_data_trt_combined
  TREATMENTS = dplyr::quos(pre,inc, Polar)
  fticr_hcoc = 
    fticr_data_trt %>% 
    left_join(dplyr::select(fticr_meta, formula, HC, OC), by = "formula")%>%
    mutate(inc=factor(inc,levels=c("Pre",'2','4','6','8','10')))
  

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
  

  inc.lab<-c("Pre","2 °C","4 °C","6 °C","8 °C","10 °C")
  names(inc.lab) <- c("Pre","2","4","6","8","10")
  
  gg_common_unique_sep_inc_pre = 
    FTICR_inc_unique_by_pre %>%
    mutate(inc = factor(inc, levels=c("Pre","2","4","6","8","10")),
           pre = factor(pre,levels=c("-2","-6"))) %>%
    filter(n == 1)%>%
    gg_vankrev(aes(x = OC, y = HC, color=pre, alpha=0.7))+
    stat_ellipse(level = 0.75, show.legend = FALSE)+
    facet_wrap(~inc,labeller = labeller(inc =inc.lab ))+
    labs(title = "Unique peaks")+
    scale_colour_manual(values=cbPalette2, breaks=c("-2","-6"), labels=c("Mild frozen", "Moderate frozen"))+
    guides(color=guide_legend(title="Pre-incubation", override.aes = list(size = 3, alpha=1)),fill="none", alpha=F)+
    theme_CKM2()+
    theme(legend.position="top")
  
  
  list(gg_common_unique_sep_inc_pre=gg_common_unique_sep_inc_pre
    
    
    
    
    
  )
  
}
