library(dplyr);library(purrr)
source('sim_functions.R')

# Get row number from command line
temp = commandArgs(TRUE)
row_num = as.numeric(temp[1])

# Show all parameters
params = data.frame(pa = c(0.9,0.9,0.9,0.9,0.7,0.7,0.5,0.3,0.2),
                    pb = c(0.3,0.5,0.7,0.8,0.3,0.5,0.4,0.1,0.1),
                    n = c(24,50,162,532,62,248,1036,158,532),
                    stringsAsFactors = FALSE)

# Set values for this run
n = params$n[row_num]
pa = params$pa[row_num]
pb = params$pb[row_num]

# Get results for gamma = 2
results_adaptive = 1:10000 %>% 
  map_df(~sim(n,pa,pb,FALSE)) %>% 
  group_by(pA,pB,n,method) %>% 
  summarise(expected_failure = ceiling(mean(n_failure)),
            sd_failure = sd(n_failure),
            max_failure = max(n_failure, na.rm=TRUE)) %>% 
  ungroup()

# Get results for complete
results_random = 1:10000 %>% 
  map_df(~sim(n,pa,pb,TRUE,burn_in=FALSE)) %>% 
  group_by(pA,pB,n,method) %>% 
  summarise(expected_failure = ceiling(mean(n_failure)),
            sd_failure = sd(n_failure),
            max_failure = max(n_failure, na.rm=TRUE)) %>% 
  ungroup()

# Paste the results together and save them to the cluster
results = rbind(results_adaptive,results_random)

saveRDS(results,file = paste0("results_",row_num,".rds"))
