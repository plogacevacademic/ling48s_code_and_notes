
# Week 8

# Assignment 1

# We want to model the relationship between the time a horse will need to run 1000 meters as a function of that
# horse's weight. (The underlying assumption is that all horses have roughly the same height, and that variation
# in weight largely reflect muscles, and not fat.)
# We will also assume (slightly unrealistically) that the relationship between weight and time to run 1000 meters
# is: time_hat = a + b*weight, where time ~ N(time_hat, sigma)  

# Step 1: Simulation parameters
a = 150
b = -1
sigma_time = 2

# Step 2: Generate data
n_horses = 100

# Generate horse weights in kg from a uniform distribution between 50 and 60. Use runif()
weight_kg = 
  
# Calculate the average predicted time to finish a race, for each horse, according to the equation a + b * weight
time_sec_hat = 
  
# Generate actual observations around the predicted mean by using rnorm()
time_sec_obs = 
  
# Plot time_sec_hat by weight. Is this what it should look like?

  
# Plot time_sec_obs by weight. Is this what it should look like?

  

# Step 3: Create likelihood function

# Complete this function to
# (i) calculate the average *predicted* time to complete the race for each observation of weight
# (ii) determine the log-likelihood of each *observed* time using dnorm(..., log=T), save the results to a vector
# (iii) sum and return all log-likelihoods
log_likelihood_time <- function(time_sec, weight_kg, a, b, sigma) {

}

# Test: This function should return a negative number. Does it? 
log_likelihood_time(time_sec_obs, weight_kg, a, b, sigma_time)
  

# Step 4: Create a wrapper for the likelihood function
log_likelihood_time_optim <- function(par) {
  log_likelihood_time(time_sec_obs, weight_kg, par[["a"]], par[["b"]], par[["sigma"]])
}

# Call optim(). Does it recover the approximately correct parameters? If not, please double-check your code above. 
res <- optim(c(a=100, b=-3, sigma=2), log_likelihood_time_optim, control = list(fnscale=-1))
res
