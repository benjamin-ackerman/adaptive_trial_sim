library(stringr);library(dplyr);library(purrr)
results = list.files()[str_detect(list.files(),".rds")]

seq_along(results) %>% 
  map_df(function(x){readRDS(results[x]) %>% 
           mutate(sim_num = str_extract(results[x],"[1-9]"))}) %>% 
  saveRDS(.,"combined_results.rds")