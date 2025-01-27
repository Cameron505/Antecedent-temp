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
| pre      |   1 | 0.0025800 | 0.1596463 | 7.557022 |   0.001 |
| inc      |   5 | 0.0032469 | 0.2009156 | 1.902109 |   0.018 |
| pre:inc  |   5 | 0.0028229 | 0.1746759 | 1.653693 |   0.059 |
| Residual |  22 | 0.0075109 | 0.4647622 |       NA |      NA |
| Total    |  33 | 0.0161607 | 1.0000000 |       NA |      NA |

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
| Pre      |   1 | 0.0000141 | 0.0361871 | 1.375732 |   0.238 |
| Inc      |   5 | 0.0000734 | 0.1882390 | 1.431265 |   0.207 |
| Pre:Inc  |   5 | 0.0000665 | 0.1705848 | 1.297032 |   0.266 |
| Residual |  23 | 0.0002358 | 0.6049891 |       NA |      NA |
| Total    |  34 | 0.0003897 | 1.0000000 |       NA |      NA |

Permanova results all

<img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-13-1.png" width="50%" /><img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-13-2.png" width="50%" />

|          |  Df |  SumOfSqs |        R2 |         F | Pr(\>F) |
|:---------|----:|----------:|----------:|----------:|--------:|
| Pre      |   1 | 0.0000047 | 0.0117707 | 0.4052875 |   0.704 |
| Inc      |   5 | 0.0000655 | 0.1637689 | 1.1277753 |   0.374 |
| Pre:Inc  |   5 | 0.0000626 | 0.1564754 | 1.0775498 |   0.398 |
| Residual |  23 | 0.0002672 | 0.6679850 |        NA |      NA |
| Total    |  34 | 0.0003999 | 1.0000000 |        NA |      NA |

Permanova results pos

<img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-15-1.png" width="50%" /><img src="SCGSR_Final_data_report_files/figure-gfm/unnamed-chunk-15-2.png" width="50%" />

|          |  Df |  SumOfSqs |        R2 |        F | Pr(\>F) |
|:---------|----:|----------:|----------:|---------:|--------:|
| Pre      |   1 | 0.0000364 | 0.0493385 | 2.557097 |   0.109 |
| Inc      |   5 | 0.0002197 | 0.2975080 | 3.083825 |   0.016 |
| Pre:Inc  |   5 | 0.0001546 | 0.2093743 | 2.170273 |   0.069 |
| Residual |  23 | 0.0003277 | 0.4437791 |       NA |      NA |
| Total    |  34 | 0.0007384 | 1.0000000 |       NA |      NA |

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

Date run: 2024-05-31

    ## R version 4.3.2 (2023-10-31 ucrt)
    ## Platform: x86_64-w64-mingw32/x64 (64-bit)
    ## Running under: Windows 11 x64 (build 22631)
    ## 
    ## Matrix products: default
    ## 
    ## 
    ## locale:
    ## [1] LC_COLLATE=English_United States.utf8 
    ## [2] LC_CTYPE=English_United States.utf8   
    ## [3] LC_MONETARY=English_United States.utf8
    ## [4] LC_NUMERIC=C                          
    ## [5] LC_TIME=English_United States.utf8    
    ## 
    ## time zone: America/Los_Angeles
    ## tzcode source: internal
    ## 
    ## attached base packages:
    ## [1] grid      stats     graphics  grDevices utils     datasets  methods  
    ## [8] base     
    ## 
    ## other attached packages:
    ##  [1] ropls_1.34.0        trelliscopejs_0.2.6 pmartR_2.4.1       
    ##  [4] agricolae_1.3-7     knitr_1.45          nlme_3.1-163       
    ##  [7] cowplot_1.1.1       ggpubr_0.6.0        janitor_2.2.0      
    ## [10] pracma_2.4.4        reshape2_1.4.4      ggbiplot_0.55      
    ## [13] scales_1.3.0        vegan_2.6-4         lattice_0.21-9     
    ## [16] permute_0.9-7       lubridate_1.9.3     forcats_1.0.0      
    ## [19] stringr_1.5.1       purrr_1.0.2         readr_2.1.4        
    ## [22] tidyr_1.3.0         tibble_3.2.1        ggplot2_3.4.4      
    ## [25] tidyverse_2.0.0     dplyr_1.1.4         plyr_1.8.9         
    ## [28] tarchetypes_0.7.9   targets_1.3.2      
    ## 
    ## loaded via a namespace (and not attached):
    ##   [1] rstudioapi_0.15.0           jsonlite_1.8.8             
    ##   [3] MultiAssayExperiment_1.28.0 magrittr_2.0.3             
    ##   [5] farver_2.1.1                rmarkdown_2.25             
    ##   [7] fs_1.6.3                    zlibbioc_1.48.0            
    ##   [9] vctrs_0.6.4                 RCurl_1.98-1.14            
    ##  [11] MultiDataSet_1.30.0         base64enc_0.1-3            
    ##  [13] rstatix_0.7.2               webshot_0.5.5              
    ##  [15] htmltools_0.5.7             S4Arrays_1.2.0             
    ##  [17] progress_1.2.2              broom_1.0.5                
    ##  [19] SparseArray_1.2.3           htmlwidgets_1.6.4          
    ##  [21] plotly_4.10.3               qqman_0.1.9                
    ##  [23] igraph_1.5.1                mime_0.12                  
    ##  [25] lifecycle_1.0.4             iterators_1.0.14           
    ##  [27] pkgconfig_2.0.3             Matrix_1.6-1.1             
    ##  [29] R6_2.5.1                    fastmap_1.1.1              
    ##  [31] GenomeInfoDbData_1.2.11     MatrixGenerics_1.14.0      
    ##  [33] shiny_1.8.0                 snakecase_0.11.1           
    ##  [35] digest_0.6.33               colorspace_2.1-0           
    ##  [37] S4Vectors_0.40.2            ps_1.7.5                   
    ##  [39] GenomicRanges_1.54.1        base64url_1.4              
    ##  [41] labeling_0.4.3              fansi_1.0.5                
    ##  [43] timechange_0.2.0            httr_1.4.7                 
    ##  [45] abind_1.4-5                 mgcv_1.9-0                 
    ##  [47] compiler_4.3.2              withr_2.5.2                
    ##  [49] backports_1.4.1             carData_3.0-5              
    ##  [51] highr_0.10                  ggsignif_0.6.4             
    ##  [53] MASS_7.3-60                 DelayedArray_0.28.0        
    ##  [55] tools_4.3.2                 httpuv_1.6.12              
    ##  [57] glue_1.6.2                  callr_3.7.3                
    ##  [59] promises_1.2.1              checkmate_2.3.0            
    ##  [61] cluster_2.1.4               generics_0.1.3             
    ##  [63] gtable_0.3.4                tzdb_0.4.0                 
    ##  [65] data.table_1.14.8           hms_1.1.3                  
    ##  [67] car_3.1-2                   utf8_1.2.4                 
    ##  [69] XVector_0.42.0              BiocGenerics_0.48.1        
    ##  [71] foreach_1.5.2               pillar_1.9.0               
    ##  [73] ggExtra_0.10.1              limma_3.58.1               
    ##  [75] later_1.3.1                 splines_4.3.2              
    ##  [77] AlgDesign_1.2.1             tidyselect_1.2.0           
    ##  [79] miniUI_0.1.1.1              IRanges_2.36.0             
    ##  [81] SummarizedExperiment_1.32.0 stats4_4.3.2               
    ##  [83] xfun_0.41                   Biobase_2.62.0             
    ##  [85] statmod_1.5.0               matrixStats_1.2.0          
    ##  [87] stringi_1.8.2               lazyeval_0.2.2             
    ##  [89] yaml_2.3.7                  evaluate_0.23              
    ##  [91] codetools_0.2-19            DistributionUtils_0.6-1    
    ##  [93] cli_3.6.1                   xtable_1.8-4               
    ##  [95] munsell_0.5.0               processx_3.8.2             
    ##  [97] Rcpp_1.0.11                 GenomeInfoDb_1.38.5        
    ##  [99] parallel_4.3.2              ellipsis_0.3.2             
    ## [101] autocogs_0.1.4              prettyunits_1.2.0          
    ## [103] mclust_6.0.1                calibrate_1.7.7            
    ## [105] bitops_1.0-7                viridisLite_0.4.2          
    ## [107] crayon_1.5.2                rlang_1.1.2
