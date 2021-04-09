
## random number generation

# uniform distribution
x <- runif(10000)
ggplot(data=NULL, aes(x)) + geom_histogram()

# binomial distribution
x <- rbinom(n = 2, size=100, prob = .5)
x


# Decision between L and R, without bias.
# assumption: we sample 1 line/10ms
# proporiton of left-tilted lines is 50%

time <- seq(0, 10000, by = 10)

run_trial <- function (abs_threshold, initial_evidence, prob_L)
{
    threshold_L = abs_threshold
    threshold_R = -1*abs_threshold
  
    # evidence at t=0
    evidence_L = rep(NA, length(time))
    
    # time slice 1
    evidence_L[1] = initial_evidence
    
    # time slice i
    for (i in 2:length(time))
    {
      is_sample_left = rbinom(n=1, size = 1, prob = prob_L)
      evidence_L[i] <- evidence_L[i-1] + ifelse(is_sample_left, 1, -1)
      if (evidence_L[i] < threshold_R) {
        return(list(response = "R", response_time = time[i] ))
        
      } else if (evidence_L[i] > threshold_L) {
        return(list(response = "L", response_time = time[i] ))
      }
    }
    
  #ggplot(data=NULL, aes(time, evidence_L)) + geom_point() + geom_path()
  
  return(list(response = NA, response_time = NA ))
}

# empty data frame
responses <- data.frame()

for (i in 1:1000) {
  ret <- run_trial(abs_threshold = 20, initial_evidence = 0, prob_L = .6)
  responses <- rbind(responses, as.data.frame(ret))
}

mean(responses$response == "L")
table(responses$response)
mean(is.na(responses$response))


ggplot(data=responses, aes(response_time)) + geom_histogram() + 
  facet_wrap(response~., ncol = 1, scales = "free_y")
