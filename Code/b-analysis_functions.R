plot_respiration = function(respiration_processed){
  
  gg_res =
    respiration_processed %>%
    mutate(Inc_temp = factor(Inc_temp, levels=c("2","4","6","8","10")),
           pre_inc = factor(pre_inc,levels=c("-2","-6")),
           JD3=JD2-317) %>%
    ggplot(aes(x = JD3, y = Res, color = pre_inc))+
    geom_point(position = position_dodge(width = 0.4),
               size = 2)+
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
           pre_inc = factor(pre_inc,levels=c("-2","-6")),
           JD3=JD2-317) %>%
    ggplot(aes(x = JD3, y = val, color =  pre_inc))+
    geom_point(position = position_dodge(width = 0.4),
               size = 2)+
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
           pre_inc = factor(pre_inc,levels=c("-2","-6")),
           JD3=JD2-317) %>%
    ggplot(aes(x=JD3, y=Res, color=pre_inc))+
    stat_summary(fun = mean,geom = "point",size = 2) +
    stat_summary(fun.data = mean_se, geom = "errorbar")+
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
           pre_inc = factor(pre_inc,levels=c("-2","-6")),
           JD3=JD2-317) %>%
  ggplot(aes(x=JD3, y=val, color=pre_inc))+
    stat_summary(fun = mean,geom = "point",size = 2) +
    stat_summary(fun.data = mean_se, geom = "errorbar")+
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

plot_nutrients = function(nutrients_processed){
  
}