SCGSR final report
================
2023-06-21

## Sample Summary

Soils from northwest Alaska were homogenized and pre-incubated at -2 and
-6 degrees Celsius for three months after which they were incubated at
2,4,6,8,10 degrees Celsius for one week. After the week long incubation
soils were extracted using 0.5M K2SO4, and chloroform extracted to
measure microbial biomass and nutrient concentrations. Sub-samples were
also sent to PNNL for MPLEx (Methanol chloroform extraction) to provide
more comprehensive analysis of the molecular composition of organic
matter using FT-ICR, NMR, GC-MS and LC-MS techniques. Lipidomics were
also performed to ascertain if there were any significant shifts in
microbial biomass.

------------------------------------------------------------------------

## Respiration Results

Respiration measurements were taken daily during the incubation using a
Li-850 bench top respiration unit. Below are the respiration rates for
each sample, as well as the calculates total C respired. Linear mixed
effects model showed significant respiration variation by incubation and
pre incubation temperatures. An asterisks indicates a significant (p\<=
0.05, ANOVA) difference in pre-incubation temperature.

![](SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

------------------------------------------------------------------------

## Soil Nutrients

Soil K2SO4 extracts were utilized to measure ammonium, Nitrate, Total
free primary amines, phosphate, Total reducing sugars. Below are the
concentration data. An asterisks indicates a significant (p\<= 0.05,
ANOVA) difference in pre-incubation temperature.

![](SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->
![](SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

------------------------------------------------------------------------

## Microbial Biomass

Soil K2SO4 extracts were utilized to measure ammonium, Nitrate, Total
free primary amines, phosphate, Total reducing sugars. Below is the
concentration data.An asterisks indicates a significant (p\<=
0.05,ANOVA) difference in pre-incubation temperature.

![](SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

------------------------------------------------------------------------

## GC-MS

Below is the relative quantification of compounds identified by gas
chromatography within the MPLEx extracts.Little to no variation was
identified that corresponds to the more broad metrics above in the soil
nutrient section. The majority of compounds measured were unidentified.
Volcano plot can be used to identify the compounds that are
significantly greater between pre incubation temperature (p\<0.05,
ANOVA). After which we used a PCA to visualize separation between the
pre incubation temperatures across significantly different compounds.
PERMANOVA results are displayed in the table below the PCAs to show
variation between treatments.

<img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-5-1.png" width="100%" />

<img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-6-1.png" width="50%" /><img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-6-2.png" width="50%" />

    ## NULL

------------------------------------------------------------------------

## LC-MS

Below is the relative quantification of compounds identified by liquid
chromatography within the MPLEx extracts.Little to no variation was
identified that corresponds to the more broad metrics above in the soil
nutrient section. The majority of compounds measured were unidentified.
Volcano plot can be used to identify the compounds that are
significantly greater between pre incubation temperature (p\<0.05,
ANOVA). After which we used a PCA to visualize separation between the
pre incubation temperatures across significantly different compounds.
PERMANOVA results are displayed in the table below the PCAs to show
variation between treatments.

<img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-8-1.png" width="100%" />

<img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-9-1.png" width="50%" /><img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-9-2.png" width="50%" />

|          |  Df |  SumOfSqs |        R2 |        F | Pr(\>F) |
|:---------|----:|----------:|----------:|---------:|--------:|
| pre      |   1 | 0.0025136 | 0.1534787 | 7.235920 |   0.001 |
| inc      |   5 | 0.0032903 | 0.2009044 | 1.894371 |   0.015 |
| pre:inc  |   5 | 0.0025839 | 0.1577713 | 1.487660 |   0.098 |
| Residual |  23 | 0.0079896 | 0.4878455 |       NA |      NA |
| Total    |  34 | 0.0163774 | 1.0000000 |       NA |      NA |

Permanova results significant compounds only

------------------------------------------------------------------------

## Lipids

Lipid analysis was done via liquid chrometography on MEPLEx extracts.
Some variation was identified between pre-incubation temperatures,
though little was biologically significant. Conclusion that small
changes in biomass were present but not significant. A big missing piece
to this analysis would be community composition.Little no no variation
was observed within this data set. PCAs below show little to no
separation between incubation and pre incubation temperatures.

<img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-11-1.png" width="50%" /><img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-11-2.png" width="50%" />

|          |  Df |  SumOfSqs |        R2 |        F | Pr(\>F) |
|:---------|----:|----------:|----------:|---------:|--------:|
| Pre      |   1 | 0.0000127 | 0.0312988 | 1.259669 |   0.302 |
| Inc      |   5 | 0.0000742 | 0.1823599 | 1.467871 |   0.175 |
| Pre:Inc  |   5 | 0.0000773 | 0.1900165 | 1.529501 |   0.168 |
| Residual |  24 | 0.0002427 | 0.5963247 |       NA |      NA |
| Total    |  35 | 0.0004071 | 1.0000000 |       NA |      NA |

Permanova results all

<img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-13-1.png" width="50%" /><img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-13-2.png" width="50%" />

|          |  Df |  SumOfSqs |        R2 |         F | Pr(\>F) |
|:---------|----:|----------:|----------:|----------:|--------:|
| Pre      |   1 | 0.0000064 | 0.0153686 | 0.5551514 |   0.594 |
| Inc      |   5 | 0.0000636 | 0.1537306 | 1.1106287 |   0.366 |
| Pre:Inc  |   5 | 0.0000689 | 0.1664960 | 1.2028526 |   0.328 |
| Residual |  24 | 0.0002749 | 0.6644048 |        NA |      NA |
| Total    |  35 | 0.0004138 | 1.0000000 |        NA |      NA |

Permanova results pos

<img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-15-1.png" width="50%" /><img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-15-2.png" width="50%" />

|          |  Df |  SumOfSqs |        R2 |        F | Pr(\>F) |
|:---------|----:|----------:|----------:|---------:|--------:|
| Pre      |   1 | 0.0000268 | 0.0346902 | 1.933659 |   0.170 |
| Inc      |   5 | 0.0002308 | 0.2982330 | 3.324750 |   0.009 |
| Pre:Inc  |   5 | 0.0001830 | 0.2365126 | 2.636681 |   0.035 |
| Residual |  24 | 0.0003332 | 0.4305642 |       NA |      NA |
| Total    |  35 | 0.0007739 | 1.0000000 |       NA |      NA |

Permanova results neg

------------------------------------------------------------------------

## FT-MS (FT-ICR)

FTICR was performed on MEPLEx extracts to gain a qualitative
understanding of the changes in organic matter composition after the
incubation. There appear to be differences between pre-incubation
temperatures, particularly in terms of the number of unique compounds,
which could be indicative of microbial processing of organic matter and
production of new organic compounds.

### FTICR Van krevelen diagrams:

![](SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

![](SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

### FTICR Common vs unique peaks by treatment:

#### All

    ## NULL

![](SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

    ## NULL

| Class              | -2_Pre | -6_Pre | -2_2 | -6_2 | -2_4 | -6_4 | -2_6 | -6_6 | -2_8 | -6_8 | -2_10 | -6_10 |
|:-------------------|-------:|-------:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|------:|------:|
| aliphatic          |    313 |    114 |  465 |   49 |  402 |   56 |  408 |   46 |  520 |   14 |   566 |    60 |
| aromatic           |     34 |     13 |   18 |   16 |   21 |   14 |   13 |   18 |   48 |    3 |    21 |    35 |
| condensed aromatic |     15 |      2 |   27 |    3 |   NA |   18 |    9 |    3 |   25 |   NA |     7 |     9 |
| unsaturated/lignin |     85 |     79 |   86 |   54 |   69 |   42 |   57 |   27 |  166 |    9 |    69 |    75 |

Unique between preincubation temperatures at each incubation temperature

#### Polar

    ## NULL

![](SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

    ## NULL

| Class              | -2_Pre | -6_Pre | -2_2 | -6_2 | -2_4 | -6_4 | -2_6 | -6_6 | -2_8 | -6_8 | -2_10 | -6_10 |
|:-------------------|-------:|-------:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|------:|------:|
| aliphatic          |    100 |    126 |  122 |   50 |   67 |   74 |   57 |   63 |  265 |   13 |    46 |   105 |
| aromatic           |     28 |     14 |   10 |   17 |   12 |   14 |    8 |   20 |   42 |    3 |    10 |    38 |
| condensed aromatic |     13 |      3 |   18 |    3 |   NA |   18 |    7 |    3 |   24 |   NA |     4 |    10 |
| unsaturated/lignin |     67 |     84 |   42 |   60 |   45 |   43 |   31 |   28 |  142 |    9 |    28 |    84 |

Unique between preincubation temperatures at each incubation temperature
polar

#### Non-Polar

    ## NULL

![](SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

    ## NULL

| Class              | -2_Pre | -6_Pre | -2_2 | -6_2 | -2_4 | -6_4 | -2_6 | -6_6 | -2_8 | -6_8 | -2_10 | -6_10 |
|:-------------------|-------:|-------:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|------:|------:|
| aliphatic          |    272 |     34 |  456 |   15 |  445 |   13 |  449 |    3 |  411 |    8 |   633 |     3 |
| aromatic           |     13 |      1 |   13 |    1 |   14 |   NA |   10 |   NA |   11 |    1 |    20 |    NA |
| condensed aromatic |      5 |     NA |   11 |   NA |    2 |   NA |    3 |   NA |    4 |   NA |     4 |    NA |
| unsaturated/lignin |     49 |     20 |  111 |    3 |   77 |    6 |  102 |   NA |   68 |    2 |   116 |     1 |

Unique between preincubation temperatures at each incubation temperature
nonpolar

### FTICR relative abundance and PCAs:

#### Relative Abundance

![](SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->![](SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-22-2.png)<!-- -->![](SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-22-3.png)<!-- -->

<img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-24-1.png" width="50%" /><img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-24-2.png" width="50%" />

|          |  Df |  SumOfSqs |        R2 |        F | Pr(\>F) |
|:---------|----:|----------:|----------:|---------:|--------:|
| pre      |   1 | 0.0004596 | 0.0321579 | 10.58298 |   0.001 |
| inc      |   5 | 0.0066832 | 0.4676090 | 30.77754 |   0.001 |
| pre:inc  |   5 | 0.0029803 | 0.2085238 | 13.72482 |   0.001 |
| Residual |  96 | 0.0041692 | 0.2917093 |       NA |      NA |
| Total    | 107 | 0.0142922 | 1.0000000 |       NA |      NA |

Permanova results: Axis class Polar only

<img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-26-1.png" width="50%" /><img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-26-2.png" width="50%" />

|          |  Df |  SumOfSqs |        R2 |          F | Pr(\>F) |
|:---------|----:|----------:|----------:|-----------:|--------:|
| pre      |   1 | 0.0050061 | 0.1717359 | 26.4653827 |   0.001 |
| inc      |   5 | 0.0052433 | 0.1798715 |  5.5438239 |   0.001 |
| pre:inc  |   5 | 0.0009308 | 0.0319305 |  0.9841303 |   0.429 |
| Residual |  95 | 0.0179699 | 0.6164622 |         NA |      NA |
| Total    | 106 | 0.0291500 | 1.0000000 |         NA |      NA |

Permanova results: Axis class Non-Polar only

------------------------------------------------------------------------

## Session Info

Date run: 2023-09-19

    ## R version 4.2.3 (2023-03-15 ucrt)
    ## Platform: x86_64-w64-mingw32/x64 (64-bit)
    ## Running under: Windows 10 x64 (build 19045)
    ## 
    ## Matrix products: default
    ## 
    ## locale:
    ## [1] LC_COLLATE=English_United States.utf8 
    ## [2] LC_CTYPE=English_United States.utf8   
    ## [3] LC_MONETARY=English_United States.utf8
    ## [4] LC_NUMERIC=C                          
    ## [5] LC_TIME=English_United States.utf8    
    ## 
    ## attached base packages:
    ## [1] grid      stats     graphics  grDevices utils     datasets  methods  
    ## [8] base     
    ## 
    ## other attached packages:
    ##  [1] ropls_1.30.0        trelliscopejs_0.2.6 pmartR_2.4.0       
    ##  [4] agricolae_1.3-6     knitr_1.43          nlme_3.1-162       
    ##  [7] cowplot_1.1.1       ggpubr_0.6.0        janitor_2.2.0      
    ## [10] pracma_2.4.2        reshape2_1.4.4      ggbiplot_0.55      
    ## [13] scales_1.2.1        plyr_1.8.8          vegan_2.6-4        
    ## [16] lattice_0.20-45     permute_0.9-7       lubridate_1.9.2    
    ## [19] forcats_1.0.0       stringr_1.5.0       dplyr_1.1.2        
    ## [22] purrr_1.0.1         readr_2.1.4         tidyr_1.3.0        
    ## [25] tibble_3.2.1        ggplot2_3.4.1       tidyverse_2.0.0    
    ## [28] tarchetypes_0.7.7   targets_1.2.0      
    ## 
    ## loaded via a namespace (and not attached):
    ##   [1] readxl_1.4.3                backports_1.4.1            
    ##   [3] qqman_0.1.8                 igraph_1.5.0               
    ##   [5] lazyeval_0.2.2              splines_4.2.3              
    ##   [7] AlgDesign_1.2.1             listenv_0.9.0              
    ##   [9] GenomeInfoDb_1.34.9         digest_0.6.33              
    ##  [11] foreach_1.5.2               htmltools_0.5.5            
    ##  [13] fansi_1.0.4                 magrittr_2.0.3             
    ##  [15] checkmate_2.2.0             base64url_1.4              
    ##  [17] cluster_2.1.4               tzdb_0.4.0                 
    ##  [19] limma_3.54.2                globals_0.16.2             
    ##  [21] matrixStats_1.0.0           timechange_0.2.0           
    ##  [23] prettyunits_1.1.1           colorspace_2.1-0           
    ##  [25] haven_2.5.3                 xfun_0.39                  
    ##  [27] callr_3.7.3                 crayon_1.5.2               
    ##  [29] RCurl_1.98-1.12             jsonlite_1.8.7             
    ##  [31] Exact_3.2                   iterators_1.0.14           
    ##  [33] glue_1.6.2                  gtable_0.3.3               
    ##  [35] zlibbioc_1.44.0             XVector_0.38.0             
    ##  [37] webshot_0.5.5               DelayedArray_0.24.0        
    ##  [39] questionr_0.7.8             car_3.1-2                  
    ##  [41] BiocGenerics_0.44.0         abind_1.4-5                
    ##  [43] mvtnorm_1.2-2               rstatix_0.7.2              
    ##  [45] miniUI_0.1.1.1              Rcpp_1.0.11                
    ##  [47] MultiDataSet_1.26.0         viridisLite_0.4.2          
    ##  [49] xtable_1.8-4                progress_1.2.2             
    ##  [51] proxy_0.4-27                mclust_6.0.0               
    ##  [53] stats4_4.2.3                htmlwidgets_1.6.2          
    ##  [55] httr_1.4.6                  calibrate_1.7.7            
    ##  [57] ellipsis_0.3.2              farver_2.1.1               
    ##  [59] pkgconfig_2.0.3             utf8_1.2.3                 
    ##  [61] polynom_1.4-1               labeling_0.4.2             
    ##  [63] tidyselect_1.2.0            rlang_1.1.1                
    ##  [65] later_1.3.1                 cellranger_1.1.0           
    ##  [67] munsell_0.5.0               tools_4.2.3                
    ##  [69] cli_3.6.1                   generics_0.1.3             
    ##  [71] broom_1.0.5                 evaluate_0.21              
    ##  [73] fastmap_1.1.1               yaml_2.3.7                 
    ##  [75] processx_3.8.2              fs_1.6.2                   
    ##  [77] future.callr_0.8.1          rootSolve_1.8.2.3          
    ##  [79] future_1.33.0               mime_0.12                  
    ##  [81] ggExtra_0.10.0              compiler_4.2.3             
    ##  [83] rstudioapi_0.15.0           plotly_4.10.2              
    ##  [85] e1071_1.7-13                ggsignif_0.6.4             
    ##  [87] klaR_1.7-2                  DescTools_0.99.49          
    ##  [89] stringi_1.7.12              highr_0.10                 
    ##  [91] ps_1.7.5                    Matrix_1.6-0               
    ##  [93] vctrs_0.6.3                 pillar_1.9.0               
    ##  [95] lifecycle_1.0.3             furrr_0.3.1                
    ##  [97] combinat_0.0-8              data.table_1.14.8          
    ##  [99] bitops_1.0-7                lmom_2.9                   
    ## [101] httpuv_1.6.11               GenomicRanges_1.50.2       
    ## [103] R6_2.5.1                    promises_1.2.0.1           
    ## [105] gld_2.6.6                   IRanges_2.32.0             
    ## [107] parallelly_1.36.0           codetools_0.2-19           
    ## [109] boot_1.3-28.1               MASS_7.3-58.2              
    ## [111] SummarizedExperiment_1.28.0 withr_2.5.0                
    ## [113] S4Vectors_0.36.2            autocogs_0.1.4             
    ## [115] GenomeInfoDbData_1.2.9      expm_0.999-7               
    ## [117] mgcv_1.8-42                 parallel_4.2.3             
    ## [119] hms_1.1.3                   MultiAssayExperiment_1.24.0
    ## [121] labelled_2.12.0             class_7.3-21               
    ## [123] rmarkdown_2.23              snakecase_0.11.0           
    ## [125] MatrixGenerics_1.10.0       carData_3.0-5              
    ## [127] DistributionUtils_0.6-0     Biobase_2.58.0             
    ## [129] shiny_1.7.4.1               base64enc_0.1-3
