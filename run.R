library(dplyr);library(purrr);library(ggplot2);library(rlang)
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

# Get results for DBCD gamma = 2
results_adaptive = 1:10000 %>% 
  map_df(~sim(n,pa,pb,complete = FALSE, burn_in = TRUE)) %>% 
  mutate(method = "DBCD (gamma == 2)")

# Get results for completely random coin
results_random = 1:10000 %>% 
  map_df(~sim(n,pa,pb,complete = TRUE, burn_in = FALSE)) %>% 
  mutate(method = "Complete")

# Bind the two and write RDS file
plot_results = results_adaptive %>% 
  bind_rows(results_random)

results = plot_results %>% 
  group_by(pA,pB,n,method) %>% 
  summarise(expected_failure = ceiling(mean(n_failure)),
            sd_failure = sd(n_failure),
            max_failure = max(n_failure, na.rm=TRUE)) %>% 
  ungroup() %>% 
  mutate(method = ifelse(method == "DBCD (gamma == 2)","Gamma = 2",method))

saveRDS(results,file = paste0("../results/results_",row_num,".rds"))

### Make and save plot of distribution of n_failure
p = ggplot(plot_results) + 
  geom_density(adjust = 2,aes(n_failure, stat(density),fill = method), alpha=0.5) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(title = "Distribution of Simulated Treatment Failures by Randomization Method",
       subtitle = expr(paste(p[A]== !!pa,", ",p[B] == !!pb,", ",n == !!n)),
       fill = "Method",
       x = expression(n[failure])) +
  scale_fill_discrete(labels = scales::parse_format())

ggsave(paste0("../figures/scenario_",row_num,".png"),p,width=8,height=7,units="in",scale=1.2)

