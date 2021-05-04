
# Week 7, 

# Assignment 1
# We want to model the relationship between the time a horse will need to run 1000 meters as a function of that
# horse's weight. (The underlying assumption is that all horses have roughly the same height, and that variation
# in weight largely reflect muscles, and not fat.)
# We will also assume (slightly unrealistically) that the relationship between weight and time to run 1000 meters
# is: time_hat = a + b*weight, where time ~ N(time_hat, sigma)  

# Step 1: Simulation parameters
a = 150
b = -1
sigma_time = .1

# Step 2: Generate horse weights
n_horses = 100
weight_kg = runif(n = n_horses, min = 50, max = 60)
time_sec_hat = a + b*weight_kg
time_sec_obs = rnorm(n_horses, mean = time_ms_hat, sd = 2)

plot(weight_kg, time_sec_hat)

plot(weight_kg, time_sec_obs)


# Step 3: Create likelihood function
likelihood_time <- function(time_sec, weight_kg, a, b) {
  time_sec_hat <- a + b*weight_kg
  lik <- rnorm(n_horses, mean = time_ms_hat, sd = 2)
  prod(lik)
}

likelihood_time(time_sec, weight_kg, a, b)
  


