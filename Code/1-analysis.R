plot_respiration = function(respiration_processed){

  gg_res =
  respiration_processed %>%
    ggplot(aes(x = Day, y = Res, color = pre_inc, shape = Inc_temp))+
    geom_point(position = position_dodge(width = 0.4),
               size = 2)+
    labs(y = "respiration, %")+
    scale_color_manual(values = cbPalette)
  
  gg_cumres =
    respiration_processed %>%
    ggplot(aes(x = Day, y = val, color =  pre_inc, shape = Inc_temp))+
    geom_point(position = position_dodge(width = 0.4),
               size = 2)+
    labs(y = "Cumulative Respiration, %")+
    scale_color_manual(values = cbPalette)
  
}