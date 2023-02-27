library(tidyverse) #for tidy processing and plotting
library(vegan) # for PERMANOVA analysis
library(ggbiplot) #for PCA biplots
library(reshape2)
library(pracma)
library(janitor)
library(ggpubr)
library(cowplot)
library(kableExtra)
library(nlme)


# to install {ggbiplot}:
# library(devtools)
# install_github("vqv/ggbiplot")
#install_github("haozhu233/kableExtra")



# custom ggplot theme
cbPalette <- c("#888888","#88CCEE", "#999933" , "#117733", "#332288", "#AA4499", 
                        "#44AA99", "#882255", "#661100", "#6699CC","#DDCC77")
cbPalette2 <- c("#88CCEE", "#999933", "#117733", "#332288", "#AA4499", 
                         "#44AA99", "#882255", "#661100", "#6699CC", "#DDCC77", "#888888")
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
