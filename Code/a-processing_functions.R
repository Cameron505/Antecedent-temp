
import_respiration= function(FILEPATH){
  # import data file
  filePaths_respiration <- list.files(FILEPATH, pattern = "csv", full.names = TRUE, recursive = TRUE)
  respiration_data <- read.csv(FILEPATH, header = TRUE) %>% mutate(Date = lubridate::mdy(Date), pre.inc = as.factor(pre.inc) ,
    Inc.temp = as.factor(Inc.temp)) %>% janitor::clean_names()
  respiration_data = respiration_data %>% mutate(source = basename(FILEPATH))
  respiration_data
  list(respiration_data = respiration_data)
}

process_respiration = function(data){
  data %>% 
    group_by(Sample_ID,Inc_temp,pre_inc) %>%
    summarize(val=trapz(Day,Res))
  
}
