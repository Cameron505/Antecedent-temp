library(tidyverse) #for tidy processing and plotting
library(vegan) # for PERMANOVA analysis
library(ggbiplot) #for PCA biplots
library(reshape2)
library(pracma)
library(janitor)
library(ggpubr)
library(cowplot)
library(nlme)
library(knitr)
library(agricolae)
library(pmartR)

# to install {ggbiplot}:
# library(devtools)
# install_github("vqv/ggbiplot")
#install_github("haozhu233/kableExtra")

# custom ggplot theme

cbPalette <- c("#888888","#FF1493","#00FFFF" , "#117733", "#332288", "#AA4499", 
                        "#44AA99", "#882255", "#661100", "#6699CC","#DDCC77")
cbPalette2 <- c("#FF1493","#00FFFF", "#117733", "#332288", "#AA4499", 
                         "#44AA99", "#882255", "#661100", "#6699CC", "#DDCC77", "#888888")

Scale_inc= scale_color_manual(values=cbPalette2,limits=c("Pre","2","4","6","8","10"))




theme_CKM <- function() {  # this for all the elements common across plots
  theme_bw() %+replace%
    theme(legend.text = element_text(size = 12),
          legend.key.size = unit(1.5, 'lines'),
          legend.background = element_rect(colour = NA),
          panel.border = element_rect(color="black",size=1.5, fill = NA),
          
          plot.title = element_text(hjust = 0, size = 14),
          axis.text = element_text(size = 14, color = "black"),
          axis.title = element_text(size = 14, face = "bold", color = "black"),
          
          # formatting for facets
          panel.background = element_blank(),
          strip.background = element_rect(colour="white", fill="white"), #facet formatting
          panel.spacing.x = unit(1.5, "lines"), #facet spacing for x axis
          panel.spacing.y = unit(1.5, "lines"), #facet spacing for x axis
          strip.text.x = element_text(size=12, face="bold"), #facet labels
          strip.text.y = element_text(size=12, face="bold", angle = 270) #facet labels
    )
}


ggplotRegression <- function (fit) {
       
       require(ggplot2)
       
        ggplot(fit$model, aes_string(x = names(fit$model)[2], y = names(fit$model)[1])) + 
             geom_point() +
             stat_smooth(method = "lm", col = "#AA4499") +
             labs(title = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                                          "Intercept =",signif(fit$coef[[1]],5 ),
                                          " Slope =",signif(fit$coef[[2]], 5),
                                    " P =",signif(summary(fit)$coef[2,4], 5)))
   }

