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

Data_OPLS<- relabund_wide %>%
  select(CoreID,aliphatic,`unsaturated/lignin`,aromatic,`condensed aromatic`)
Data_OPLS<-as.data.frame(Data_OPLS)
Data_OPLS_1 <- as.matrix(Data_OPLS[, colnames(Data_OPLS) != "CoreID"])
rownames(Data_OPLS_1) <- nameH

Meta_OPLS<-relabund_wide %>%
  select(-c(aliphatic,`unsaturated/lignin`,aromatic,`condensed aromatic`))
Meta_OPLS<-as.data.frame(Meta_OPLS)
Meta_OPLS_1 <- as.matrix(Meta_OPLS[, colnames(Meta_OPLS) != "CoreID"])
rownames(Meta_OPLS_1) <- nameH

##PLS-DA
PLS_DA_all = opls(Data_OPLS_1,Meta_OPLS[, "pre"])

plot(PLS_DA_all, typeVc = "x-score")

PLS_DA_all2 = opls(Data_OPLS_1,Meta_OPLS[, "inc"]) #Does not work

plot(PLS_DA_all2, typeVc = "x-score")

PLS_DA_all@scoreMN #I think these are the coords for the PLS-DA plot? where is class data stored...Also I cant seem to call an individual vector from this object...  


##OPLS-DA "OPLS-DA only available for binary classification (use PLS-DA for multiple classes)"
OPLS_DA_all = opls(Data_OPLS_1,Meta_OPLS[, "pre"],predI = 1, orthoI = NA)

plot(OPLS_DA_all, typeVc = "x-score")
#Not sure where the coordinates are for this OPLS-DA within the object
