library(stringr);library(dplyr);library(purrr)
results = list.files()[str_detect(list.files(),".rds")]

seq_along(results) %>% 
  map_df(~readRDS(results[.])) %>% 
  saveRDS(.,"combined_results.rds")
