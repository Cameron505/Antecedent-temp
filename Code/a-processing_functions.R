
import_respiration= function(FILEPATH){
  # import data file
  filePaths_respiration <- list.files(FILEPATH, pattern = "csv", full.names = TRUE, recursive = TRUE)
  respiration_data <- read.csv(FILEPATH, header = TRUE) %>% mutate(Date = lubridate::mdy(Date), pre.inc = as.factor(pre.inc) ,
    Inc.temp = as.factor(Inc.temp)) %>% janitor::clean_names()
  respiration_data = respiration_data %>% mutate(source = basename(FILEPATH))
  respiration_data
  list(respiration_data = respiration_data)
}

process_respiration = function(respiration_data){
  respiration_processed = respiration_data %>%
    mutate(Datemdy = lubridate::mdy(Date),
           JD = strftime(Datemdy, format = "%j"),
           JD2 = (as.numeric(JD)-317),
           Res2=Res*24) %>%
    group_by(Sample_ID,Inc_temp,pre_inc) %>%
    dplyr::summarise(val=cumtrapz(JD2,Res),Res, JD2)
  

}

import_nutrients= function(FILEPATH){
  # import data file
  filePaths_nutrients <- list.files(FILEPATH, pattern = "csv", full.names = TRUE, recursive = TRUE)
  nutrients_data <- read.csv(FILEPATH, header = TRUE) %>% mutate(Date = lubridate::mdy(Date)) %>% janitor::clean_names()
  nutrients_data = nutrients_data %>% mutate(source = basename(FILEPATH))
  nutrients_data
  list(nutrient_data = nutrient_data)
}

process_GC= function(GC_data,GC_fdata){
  edata <- GC_data
  fdata <- GC_fdata
  
  colnames(fdata)[1] <- "Sample.ID"
  colnames(edata)[1] <- "Metabolites"
  
  edata2<-edata%>%
    select(-Tags,-RefMet.Nomenclature,-Main.class,-Sub.class,-Alternative.Identifications
    )
  emeta<-edata%>%
    select(Metabolites,Tags,RefMet.Nomenclature,Main.class,Sub.class,Alternative.Identifications
    )
  
  
  # Create metabolite object --> make sure 0 is NA
  metab_data <- as.metabData(edata2, fdata, edata_cname = "Metabolites", fdata_cname = "Sample.ID")
  
  # Log transform data 
  metab_data <- edata_transform(metab_data, "log2")
  
  # Add group designation
  metab_data <- group_designation(metab_data, main_effects = c("pre","inc"))
  plot(metab_data,order_by = colnames(fdata) [2], color_by = colnames(fdata)[2])
  plot(metab_data,order_by = colnames(fdata) [3], color_by = colnames(fdata)[3])
  #################
  ## FILTER DATA ##
  #################
  
  # Add biomolecule filter
  plot(molecule_filter(metab_data))
  metab_filter <- applyFilt(molecule_filter(metab_data), metab_data,min_num=4)
  plot(metab_filter,order_by = colnames(fdata) [2], color_by = colnames(fdata)[2])
  plot(metab_filter,order_by = colnames(fdata) [3], color_by = colnames(fdata)[3])
  # Add imd anova
  metab_filter <- applyFilt(imdanova_filter(metab_data), metab_filter, 
                            min_nonmiss_anova = 3, min_nonmiss_gtest = 3)
  
  # Add rmd filter
  
  plot(rmd_filter(metab_data,ignore_singleton_groups = TRUE, metrics = NULL), pvalue_threshold = 0.0001)
  metab_filter <- applyFilt(rmd_filter(metab_data,ignore_singleton_groups = TRUE,metrics=NULL), metab_filter, pvalue_threshold = 0.000001)
  
  ###################
  ## NORMALIZATION ##
  ###################
  
  normal_test <- normalize_global(metab_filter, subset_fn = "all", norm_fn = "mean")
  pmartR::normRes_tests(normal_test) # Bad option! We want it to be > 0.05 at least. 
  
  metab_final <- normalize_global(metab_filter, subset_fn = "all", norm_fn = "mean", apply_norm = TRUE, 
                                  backtransform = TRUE)

  list(metab_final = metab_final)
}

process_LC= function(LC_POS_data,LC_fdata,LC_neg_data,LC_neg_fdata){
  edata <- LC_POS_data
  edata1 <- LC_neg_data %>%
    mutate(Name = if_else(grepl("HODE", Name), "13-HODE", Name))
  fdata1 <- LC_fdata
  
  
  edata2<-edata1%>%
    select(-m.z,-RT..min.,-Tags,-RefMet.Nomenclature,-Main.class,-Sub.class,-Formula,-Annot..DeltaMass..ppm.,-Calc..MW,-Reference.Ion
    )  
  
  edata_pos<- edata%>%
    pivot_longer(cols= c(Wein_Blank.01:E_6_2))%>%
    mutate(MODE= "pos")
  
  edata_neg<- edata1%>%
    pivot_longer(cols=c(Wein_Blank.01:E_6_3))%>%
    mutate(MODE="neg")
  
  
  LC_data_all<-rbind(edata_pos, edata_neg)%>%
    pivot_wider(names_from = name, values_from = value)%>%
    unite('Name2',c(Name,MODE),remove=FALSE)
  
  colnames(fdata1)[1] <- "Sample.ID"
  
  LC_data_all1<-LC_data_all%>%
    select(-m.z,-RT..min.,-Tags,-RefMet.Nomenclature,-Main.class,-Sub.class,-Formula,-Annot..DeltaMass..ppm.,-Calc..MW,-Reference.Ion,-MODE,-Name
    )  
  
  LC_meta<-LC_data_all%>%
    select(m.z,RT..min.,Name,Tags,RefMet.Nomenclature,Main.class,Sub.class,Formula,Annot..DeltaMass..ppm.,Calc..MW,Reference.Ion,MODE,Name
    )
  
  
  # Create metabolite object --> make sure 0 is NA
  metab_data <- as.metabData(LC_data_all1, fdata1, edata_cname = "Name2", fdata_cname = "Sample.ID")
  
  # Log transform data 
  metab_data <- edata_transform(metab_data, "log2")
  
  
  # Add group designation
  metab_data <- group_designation(metab_data, main_effects = c("pre","inc"))
  
  
  #################
  ## FILTER DATA ##
  #################
  
  # Add biomolecule filter
  
  metab_filter2 <- applyFilt(molecule_filter(metab_data), metab_data,min_num=4)
  
  # Add imd anova
  metab_filter <- applyFilt(imdanova_filter(metab_data), metab_filter2, 
                            min_nonmiss_anova = 3, min_nonmiss_gtest = 3)
  
  # Add rmd filter
  
  metab_filter <- applyFilt(rmd_filter(metab_data,ignore_singleton_groups = TRUE,metrics=NULL), metab_filter, pvalue_threshold = 0.000001)
  
  ###################
  ## NORMALIZATION ##
  ###################
  
  normal_test <- normalize_global(metab_filter, subset_fn = "all", norm_fn = "mean")
  pmartR::normRes_tests(normal_test) # Bad option! We want it to be > 0.05 at least. 
  
  metab_final <- normalize_global(metab_filter, subset_fn = "all", norm_fn = "mean", apply_norm = TRUE, 
                                  backtransform = TRUE)
  
  list(metab_final = metab_final)
  
}


process_Lipid= function(Lipid_POS_data,Lipid_NEG_data,Lipid_fdata){
  edata <- Lipid_POS_data
  fdata <- Lipid_fdata
  edata1 <- Lipid_NEG_data
  
  fdata$Sample<-gsub("_Pos","",as.character(fdata$Sample))
  
  
  edata_pos<- edata%>%
    pivot_longer(cols= c(Wein_51407_22_Pre_2_2_L_Pos:Wein_51407_19_A_2_1_L_Pos))%>%
    mutate(MODE= "pos")
    
    
    edata_pos$name<-gsub("_Pos","",as.character(edata_pos$name))
  

  edata_neg<- edata1%>%
    pivot_longer(cols=c(Wein_51407_22_Pre_2_2_L_Neg:Wein_51407_16_A_6_2_L_Neg))%>%
    mutate(MODE="neg")
  
  edata_neg$name<-gsub("_Neg","",as.character(edata_neg$name))
  colnames(edata_neg)[1] <- "Sample"
  
  Lipid_data_all<-rbind(edata_pos, edata_neg)%>%
    pivot_wider(names_from = name, values_from = value)%>%
    unite('Name2',c(Sample,MODE),sep="__",remove=FALSE)
  
  colnames(fdata)[1] <- "Sample.ID"
  
  Lipid_data_all2<-Lipid_data_all%>%
    select(-MODE,-Sample
    )  

  
  
  # Create metabolite object --> make sure 0 is NA
  metab_data <- as.metabData(Lipid_data_all2, fdata, edata_cname = "Name2", fdata_cname = "Sample.ID")
  
  # Log transform data 
  metab_data <- edata_transform(metab_data, "log2")
  
  
  # Add group designation
  metab_data <- group_designation(metab_data, main_effects = c("Pre","Inc"))
  
  
  #################
  ## FILTER DATA ##
  #################
  
  # Add biomolecule filter
  
  metab_filter2 <- applyFilt(molecule_filter(metab_data), metab_data,min_num=4)
  
  # Add imd anova
  metab_filter <- applyFilt(imdanova_filter(metab_data), metab_filter2, 
                            min_nonmiss_anova = 3, min_nonmiss_gtest = 3)
  
  # Add rmd filter
  
  metab_filter <- applyFilt(rmd_filter(metab_data,ignore_singleton_groups = TRUE,metrics=NULL), metab_filter, pvalue_threshold = 0.000001)
  
  ###################
  ## NORMALIZATION ##
  ###################
  
  normal_test <- normalize_global(metab_filter, subset_fn = "all", norm_fn = "mean")
  pmartR::normRes_tests(normal_test) # Bad option! We want it to be > 0.05 at least. 
  
  metab_final <- normalize_global(metab_filter, subset_fn = "all", norm_fn = "mean", apply_norm = TRUE, 
                                  backtransform = TRUE)
  
  list(metab_final = metab_final)
  
}


Lipid_process_PCA= function(Lipid_processed){
  Lipid_data_composite = Lipid_processed$metab_final$e_data %>%
    pivot_longer(cols=Wein_51407_22_Pre_2_2_L:Wein_51407_19_A_2_1_L, names_to= "Sample.ID")%>%
    left_join(Lipid_processed$metab_final$f_data, by= "Sample.ID")%>%
    mutate(class = case_when(grepl("Cer", Name2) ~ "Sphingolipid",
                             grepl("CoQ", Name2) ~ "Prenol Lipid",
                             grepl("PC", Name2) ~ "Glycerophospholipid",
                             grepl("PE", Name2) ~ "Glycerophospholipid",
                             grepl("PG", Name2) ~ "Glycerophospholipid",
                             grepl("PI", Name2) ~ "Glycerophospholipid",
                             grepl("DG", Name2) ~ "Glycerolipid",
                             grepl("TG", Name2) ~ "Glycerolipid"))
  
  
  Lipid_short<-Lipid_data_composite %>%
    group_by(Sample.ID,class,Pre,Inc)%>%
    dplyr::summarise(abund=sum(value,na.rm=TRUE))%>%
    ungroup %>%
    dplyr::mutate(total = sum(abund,na.rm=TRUE),
                  relabund  = (abund/total)*100)%>%
    dplyr::select(-c(relabund, total)) %>% 
    pivot_wider(names_from = class,values_from = abund)
  
  
  
  
  
  
  
  
  
  num= Lipid_short%>%
    dplyr::select(c(Sphingolipid,'Prenol Lipid',Glycerophospholipid,Glycerolipid))
  
  grp=Lipid_short%>%
    dplyr::select(-c(Sphingolipid,'Prenol Lipid',Glycerophospholipid,Glycerolipid))%>%
    dplyr::mutate(row = row_number())
  
  pca_Lip = prcomp(num, scale.=T)
  
  list(num=num,
       grp=grp,
       pca_Lip=pca_Lip,
       Lipid_data_composite=Lipid_data_composite)
  
}





Process_FTICR= function(FTICR_Lipid,FTICR_Metabolite){
  source("code/fticr/a-functions_processing.R")
  
  Lipid_Key<- FTICR_Lipid %>%
    pivot_longer(cols=out_Wein_51407_PBlank1_FTICR_Lipid_r1_13Feb23_Fir_300SA_P01_9650.XML:out_Wein_51407_36_Pre.2.1_FTICR_Lipid_r3_13Feb23_Fir_300SA_P01_9740.XML, names_to= "CoreID")%>%
    select(CoreID)%>%
    mutate(pre = case_when(grepl(".6", CoreID)~ "-6",
                           grepl(".2", CoreID)~ "-2"),
           inc = case_when(grepl("_Pre", CoreID)~ "Pre",
                           grepl("_A", CoreID)~ "2",
                           grepl("_B", CoreID)~ "4",
                           grepl("_C", CoreID)~ "6",
                           grepl("_D", CoreID)~ "8",
                           grepl("_E", CoreID)~ "10"))
  
  Metab_Key<-FTICR_Metabolite%>%
    pivot_longer(cols=out_Wein_51407_PBlank1_FTICR_r2_09Feb23_Fir_300SA_P01_9444:out_Wein_51407_PBlank1_FTICR_r1_08Feb23_Fir_300SA_P01_9394,names_to= "CoreID")%>%
    select(CoreID)%>%
    mutate(pre = case_when(grepl(".6", CoreID)~ "-6",
                           grepl(".2", CoreID)~ "-2"),
           inc = case_when(grepl("_Pre", CoreID)~ "Pre",
                           grepl("_A", CoreID)~ "2",
                           grepl("_B", CoreID)~ "4",
                           grepl("_C", CoreID)~ "6",
                           grepl("_D", CoreID)~ "8",
                           grepl("_E", CoreID)~ "10"))
  
  
  TREATMENTS = dplyr::quos(pre,inc)
  
  report_polar = FTICR_Metabolite
  corekey_polar = Metab_Key
  
  report_nonpolar = FTICR_Lipid
  corekey_nonpolar = Lipid_Key
  
  fticr_meta_polar = make_fticr_meta(report_polar)$meta2
  
  fticr_meta_nonpolar = make_fticr_meta(report_nonpolar)$meta2
  
  fticr_data_longform_polar = make_fticr_data(report_polar, corekey_polar, TREATMENTS)$data_long_key_repfiltered %>% 
    mutate(Polar = "polar")
  
  fticr_data_longform_nonpolar = make_fticr_data(report_nonpolar, corekey_nonpolar, TREATMENTS)$data_long_key_repfiltered %>% 
    mutate(Polar = "nonpolar")
  
 
  fticr_data_trt_polar = make_fticr_data(report_polar, corekey_polar, TREATMENTS)$data_long_trt %>% 
    mutate(Polar = "polar")
  
  fticr_data_trt_nonpolar = make_fticr_data(report_nonpolar, corekey_nonpolar, TREATMENTS)$data_long_trt %>% 
    mutate(Polar = "nonpolar")
  
  fticr_meta_combined = 
    rbind(fticr_meta_polar, fticr_meta_nonpolar) %>% 
    distinct()
  
  fticr_data_longform_combined = 
    rbind(fticr_data_longform_polar, fticr_data_longform_nonpolar)
  
  fticr_data_trt_combined = 
    rbind(fticr_data_trt_polar, fticr_data_trt_nonpolar)
  
  
  
  
  
  
  
  
  
  list(fticr_meta_polar=fticr_meta_polar,
       fticr_data_longform_polar=fticr_data_longform_polar,
       fticr_data_trt_polar=fticr_data_trt_polar,
       fticr_meta_nonpolar=fticr_meta_nonpolar,
       fticr_data_longform_nonpolar=fticr_data_longform_nonpolar,
       fticr_data_trt_nonpolar=fticr_data_trt_nonpolar,
       fticr_meta_combined=fticr_meta_combined,
       fticr_data_longform_combined=fticr_data_longform_combined,
       fticr_data_trt_combined=fticr_data_trt_combined)
  
  
}

