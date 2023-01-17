plot_respiration = function(respiration_processed){

  gg_res =
  respiration_processed %>%
    mutate(Inc_temp = as.character(Inc_temp),
           pre_inc = as.character(pre_inc)) %>%
    ggplot(aes(x = Day, y = Res, color = pre_inc, shape = Inc_temp))+
    geom_point(position = position_dodge(width = 0.4),
               size = 2)+
    labs(y = "respiration, %")+
    scale_color_manual(values = cbPalette)
  
  gg_cumres =
    respiration_processed %>%
    mutate(Inc_temp = as.character(Inc_temp),
           pre_inc = as.character(pre_inc)) %>%
    ggplot(aes(x = JD2, y = val, color =  pre_inc, shape = Inc_temp))+
    geom_point(position = position_dodge(width = 0.4),
               size = 2)+
    labs(y = "Cumulative Respiration, %")+
    scale_color_manual(values = cbPalette)
  
  list(gg_res = gg_res,
       gg_cumres=gg_cumres)
  
}