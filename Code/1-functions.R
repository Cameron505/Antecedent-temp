
import_respiration= function(FILEPATH){
  # import data file
  filePaths_respiration <- list.files(path = FILEPATH, pattern = "csv", full.names = TRUE, recursive = TRUE)
  respiration_data <- do.call(bind_rows, lapply(filePaths_respiration, function(path) {
    df <- read.csv(path, header = TRUE) %>% mutate(Date = lubridate::mdy(Date), pre.inc = as.factor(pre.inc) ,
    Inc.temp = as.factor(Inc.temp)) %>% janitor::clean_names()
    df = df %>% mutate(source = basename(path))
    df}))
  list(respiration_data = respiration_data)
}

process_respiration = function(data){
  data %>% 
    group_by(Sample_ID,Inc_temp,pre_inc) %>%
    summarize(val=trapz(Day,Res))
  
  }