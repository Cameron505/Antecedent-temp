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

Data_OPLS<- relabund_wide %>%
  select(CoreID,aliphatic,`unsaturated/lignin`,aromatic,`condensed aromatic`)
Data_OPLS<-as.data.frame(Data_OPLS)
Data_OPLS_1 <- as.matrix(Data_OPLS[, colnames(Data_OPLS) != "CoreID"])
rownames(Data_OPLS_1) <- Data_OPLS[ ,"CoreID"]

Meta_OPLS<-relabund_wide %>%
  select(-c(aliphatic,`unsaturated/lignin`,aromatic,`condensed aromatic`))
Meta_OPLS<-as.data.frame(Meta_OPLS)
Meta_OPLS_1 <- as.matrix(Meta_OPLS[, colnames(Meta_OPLS) != "CoreID"])
rownames(Meta_OPLS_1) <- Meta_OPLS[ ,"CoreID"]

OPLS_1<-opls(Data_OPLS_1, Meta_OPLS[, "pre"])


VIP<-getVipVn(OPLS_1)

is.numeric(Data_OPLS)
class(Data_OPLS)

pca_all = opls(Data_OPLS_1,Meta_OPLS[, "pre"])

plot(OPLS_1, typeVc = "x-score")
