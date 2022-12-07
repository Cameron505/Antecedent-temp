
source("code/0-packages.R")
A = read.csv("Data/Respiration_Antecedent_temp.csv")
A <- na.omit(A)
A$Date<- as.Date(A$Date, format="%m/%d/%Y")
cbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
A$pre.inc<- as.factor(A$pre.inc)
A$Inc.temp<- as.factor(A$Inc.temp)


PRes<-ggplot(A, aes(x=Inc.temp, y=Res, color=pre.inc))+
  stat_summary(fun = mean,geom = "point",lwd=4) +
  stat_summary(fun.data = mean_se, geom = "errorbar", lwd=1, width = 0.5)+
  facet_wrap(~Day)+
  theme_light()+
  scale_colour_manual(values=cbPalette)+
  scale_fill_manual(values=cbPalette)+
  ylab(expression(paste( "Respiration (",mu,"g-C",Hr^-1, ")")))+
  xlab("incubation temperature")+
  labs(color='pre.inc temp') +
  theme(legend.direction = 'vertical', 
        legend.key = element_rect(size=2),
        legend.key.size = unit(3, 'lines'),
        panel.grid.major = element_blank(), 
        legend.title=element_text(size=30,colour='black'),
        panel.grid.minor = element_blank(),
        legend.text=element_text(size=25),
        axis.title.y= element_text(size=30, colour='black'),
        axis.text.y = element_text(size=20, colour='black'),
        axis.ticks = element_line(colour = "black", size=2),
        axis.ticks.length = unit(0.3, "cm"),
        axis.title.x=element_text(size=30, colour='black'),
        axis.text.x = element_text(size=20, colour='black'),
        panel.border = element_rect(colour = "black", fill=NA, size=2),
        plot.title = element_text( size=30, face="bold.italic"),
        plot.margin=unit(c(1,1,1,1), "cm"))+
  ggtitle("Soil Respiration")

ggsave('Graphs/Respiration each day_Antecedent Temp.png', plot=PRes, width= 20, height= 12)


PRes2<-ggplot(A, aes(x=Date, y=Res, color=pre.inc))+
  stat_summary(fun = mean,geom = "point",lwd=4) +
  stat_summary(fun.data = mean_se, geom = "errorbar", lwd=1, width = 0.5)+
  facet_wrap(~Inc.temp)+
  theme_light()+
  scale_colour_manual(values=cbPalette)+
  scale_fill_manual(values=cbPalette)+
  ylab(expression(paste( "Respiration (",mu,"g-C",Hr^-1, ")")))+
  xlab("incubation temperature")+
  labs(color='pre.inc temp') +
  theme_CKM()+
  ggtitle("Soil Respiration")

ggsave('Graphs/Respiration each temperature Temp.png', plot=PRes2, width= 20, height= 12)



theme(legend.direction = 'vertical', 
      legend.key = element_rect(size=2),
      legend.key.size = unit(3, 'lines'),
      panel.grid.major = element_blank(), 
      legend.title=element_text(size=30,colour='black'),
      panel.grid.minor = element_blank(),
      legend.text=element_text(size=25),
      axis.title.y= element_text(size=30, colour='black'),
      axis.text.y = element_text(size=20, colour='black'),
      axis.ticks = element_line(colour = "black", size=2),
      axis.ticks.length = unit(0.3, "cm"),
      axis.title.x=element_text(size=30, colour='black'),
      axis.text.x = element_text(size=20, colour='black'),
      panel.border = element_rect(colour = "black", fill=NA, size=2),
      plot.title = element_text( size=30, face="bold.italic"),
      plot.margin=unit(c(1,1,1,1), "cm"))
