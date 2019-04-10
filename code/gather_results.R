library(stringr);library(dplyr);library(purrr)
results = list.files("../results/")[str_detect(list.files("../results/"),"results_")]

seq_along(results) %>% 
  map_df(function(x){readRDS(paste0("../results/",results[x])) %>% 
           mutate(sim_num = str_extract(results[x],"[1-9]"))}) %>% 
  saveRDS(.,"../results/combined_results.rds")