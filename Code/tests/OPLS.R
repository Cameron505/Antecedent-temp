library(ropls)

#practice data provided
data(foods) ## see Eriksson et al. (2001); presence of 3 missing values (NA)
head(foods)
foodMN <- as.matrix(foods[, colnames(foods) != "Country"])
rownames(foodMN) <- foods[, "Country"]
head(foodMN)
foo.pca <- opls(foodMN)



data(cornell) ## see Tenenhaus, 1998
head(cornell)
cornell.pls <- opls(as.matrix(cornell[, grep("x", colnames(cornell))]),
                    cornell[, "y"])


plot(cornell.pls, typeVc = c("outlier", "predict-train", "xy-score", "xy-weight"))



data(lowarp) ## see Eriksson et al. (2001); presence of NAs
head(lowarp)
lowarp.pls <- opls(as.matrix(lowarp[, c("glas", "crtp", "mica", "amtp")]),
                   as.matrix(lowarp[, grepl("^wrp", colnames(lowarp)) |
                                      grepl("^st", colnames(lowarp))]))



data(sacurine)
attach(sacurine)
sacurine.plsda <- opls(dataMatrix, sampleMetadata[, "gender"])
plot(sacurine.plsda, parPaletteVc = c("green4", "magenta"))
sacurine.oplsda <- opls(dataMatrix, sampleMetadata[, "gender"], predI = 1, orthoI = NA)
sacSet <- Biobase::ExpressionSet(assayData = t(dataMatrix), 
                                 phenoData = new("AnnotatedDataFrame", 
                                                 data = sampleMetadata), 
                                 featureData = new("AnnotatedDataFrame", 
                                                   data = variableMetadata),
                                 experimentData = new("MIAME", 
                                                      title = "sacurine"))

sacPlsda <- opls(sacSet, "gender")
sacSet <- getEset(sacPlsda)
head(Biobase::pData(sacSet))
head(Biobase::fData(sacSet))

####MY DATA (Need to tarload)
fticr_data_longform = FTICR_processed$fticr_data_longform_combined
fticr_meta  = FTICR_processed$fticr_meta_combined
TREATMENTS = dplyr::quos(pre,inc,Polar)
TREATMENTS2 = dplyr::quos(pre,inc)
relabund_cores = 
  fticr_data_longform %>%
  compute_relabund_cores(fticr_meta, TREATMENTS)%>%
  filter(inc!='NA')
relabund_wide = 
  relabund_cores %>% 
  ungroup() %>% 
  mutate(Class = factor(Class, 
                        levels = c("aliphatic", "unsaturated/lignin", 
                                   "aromatic", "condensed aromatic"))) %>% 
  dplyr::select(-c(abund, total)) %>% 
  spread(Class, relabund) %>% 
  replace(is.na(.), 0)



##Data reorganization
nameH<-c(1:215)
nameP<-c(1:108)
namePN2<-c(1:44)
namePN6<-c(1:64)
Data_OPLS<- relabund_wide %>%
  filter(Polar=='polar', pre=='-6')%>%
  select(CoreID,aliphatic,`unsaturated/lignin`,aromatic,`condensed aromatic`)
Data_OPLS<-as.data.frame(Data_OPLS)
Data_OPLS_1 <- as.matrix(Data_OPLS[, colnames(Data_OPLS) != "CoreID"])
rownames(Data_OPLS_1) <- namePN6

Meta_OPLS<-relabund_wide %>%
  filter(Polar=='polar', pre=='-6')%>%
  select(-c(aliphatic,`unsaturated/lignin`,aromatic,`condensed aromatic`))
Meta_OPLS<-as.data.frame(Meta_OPLS)
Meta_OPLS_1 <- as.matrix(Meta_OPLS[, colnames(Meta_OPLS) != "CoreID"])
rownames(Meta_OPLS_1) <- namePN6

##PLS-DA
PLS_DA_all = opls(Data_OPLS_1,Meta_OPLS[, "pre"])

plot(PLS_DA_all, typeVc = "x-score")

PLS_DA_all2 = opls(Data_OPLS_1,Meta_OPLS[, "inc"],predI = 2)

plot(PLS_DA_all2, typeVc = "x-score")

PLS_DA_all@scoreMN #I think these are the coords (x,y) for the PLS-DA plot? where is class data stored...  
DF1<-data.frame(PLS_DA_all@scoreMN) # have to dump this object into a data frame before I can call it? 
plot(DF1$p1,DF1$p2) #Confirmed that these are the points the PLS-DA is plotting. Still not sure how to get the class data to draw the vectors. Should be able to left join metadata to DF1 to get color separation and elipse drawing. 


##OPLS-DA "OPLS-DA only available for binary classification (use PLS-DA for multiple classes)"
OPLS_DA_all = opls(Data_OPLS_1,Meta_OPLS[, "pre"],predI = 1, orthoI = NA)

plot(OPLS_DA_all, typeVc = "x-score")
#Not sure where the coordinates are for this OPLS-DA within the object
