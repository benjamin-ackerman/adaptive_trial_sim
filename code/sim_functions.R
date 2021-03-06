sim = function(n, pA_true, pB_true, complete, burn_in, gamma = 2){
  # Initialize parameters
  j = 0
  n_A = n_B = s_A = s_B = 0
  
  # I am setting the first estimates of pA and pB to be the true values
  pA_hat = pA_true
  pB_hat = pB_true
  
  # Since the simulations for DBCD are unstable at the start, I burn in 20 fair coin randomized patients
  if(burn_in == TRUE){
    i = 0
    n = n + 20
    j = j + 20
    data = data.frame()
    while(i < 20){
      assignment = rbinom(1, 1, 0.5)
      data[(i+1),"T"] = assignment
      data[(i+1),"Y"] = rbinom(1,1,ifelse(assignment == 1, pA_true,pB_true))
      
      i = i+1
    }
    pA_burn_in = pA_hat = data %>% filter(T == 1) %>% summarise(pA = mean(Y)) %>% pull()
    pB_burn_in = pB_hat = data %>% filter(T == 0) %>% summarise(pB = mean(Y)) %>% pull()
    
    nA_burn_in = n_A = ifelse(is.na(table(data$T)["1"]),0, as.numeric(table(data$T)["1"]))
    nB_burn_in = n_B = ifelse(is.na(table(data$T)["0"]),0, as.numeric(table(data$T)["0"]))
    
    s_A = pA_hat*n_A
    s_B = pB_hat*n_B
  }
  
  while(j < n){
    if(burn_in == TRUE){
      # First adaptive stage:
      phat = sqrt(pA_hat)/(sqrt(pA_hat) + sqrt(pB_hat))
      if(is.nan(phat)){phat = 0.5}
      # Manuscript states that pA = 1 if n_A/j = 0, and pA = 0 if n_A/j = 1
      if(n_A/j == 0){
        pA = 1
      } else if(n_A/j == 1){
        pA = 0
      } else{
        # Second adaptive stage:
        pA = (phat*(j*phat/n_A)^gamma)/(phat*(j*phat/n_A)^gamma + (1-phat)*(j*(1-phat)/n_B)^gamma)
      }
    } 
    if(burn_in == FALSE){
      # If no burn-in, the first person will be randomized according to a fair coin
      if(j == 0){
        pA = 0.5
      } else if(n_A/j == 0){
        # Manuscript states that pA = 1 if n_A/j = 0, and pA = 0 if n_A/j = 1
        pA = 1
      } else if(n_A/j == 1){
        pA = 0
      } else{
        # First adaptive stage:
        phat = sqrt(pA_hat)/(sqrt(pA_hat) + sqrt(pB_hat))
        if(is.nan(phat)){phat = 0.5}
        # Second adaptive stage:
        pA = (phat*(j*phat/n_A)^gamma)/(phat*(j*phat/n_A)^gamma + (1-phat)*(j*(1-phat)/n_B)^gamma)
      }
    }
    # If simulation is just using a fair coin, ignore above and use p=0.5
    if(complete == TRUE){
      assignment = rbinom(1,1,0.5)
    } else{
      assignment = rbinom(1,1,pA)
    }
    
    # Simulate the number of successes in each treatment group by true pA and pB
    if(assignment == 1){
      n_A = n_A + 1
      s_A = s_A + rbinom(1,1,pA_true)
    } else{
      n_B = n_B + 1
      s_B = s_B + rbinom(1,1,pB_true)
    }
    
    # Set up parameters for next run
    j = j+1
    pA_hat = ifelse(is.nan(s_A/n_A),pA_true,s_A/n_A)
    pB_hat = ifelse(is.nan(s_B/n_B),pB_true,s_B/n_B)
  }
  
  # Get rid of burn-ins
  if(burn_in == TRUE){
    n_A = n_A - nA_burn_in
    s_A = s_A - pA_burn_in*nA_burn_in
    n_B = n_B - nB_burn_in
    s_B = s_B - pB_burn_in*nB_burn_in
  }
  
  # Return a data frame of the parameters and results
  return(data.frame(pA = pA_true,
                    pB = pB_true,
                    n = ifelse(burn_in == TRUE, n-20,n),
                    method = ifelse(complete == TRUE,"Complete",paste0("Gamma = ",gamma)),
                    n_A = n_A,s_A = s_A,
                    n_B = n_B,s_B = s_B,
                    n_failure = (n_A + n_B - s_A - s_B))) 
}