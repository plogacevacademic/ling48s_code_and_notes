
# ***************************
# *** Normal Distribution ***
# ***************************

# simulate the process underlying the generative process approximating a normal distribution as the number of 
# additive components increases towards infinity
{

n_components = 500
n_values = 10^5
start_value_additive = 0

# create vector at starting values
vals_additive_process <- rep(start_value_additive, n_values)

for(j in 1:n_components) {
  # create a vector of additive changes (-1/1) for this component 
  additive_change <- sample(c(-1,1), n_values, replace = T)
  
  # add the vector of changes due to this component
  vals_additive_process <- vals_additive_process + additive_change
  
  # print the number of current iterations
  print(j)
}

}

# if you change the number of components parameter ('n_components'), you will see that the histogram of
# simulated values will begin to resemble a normal distribution
hist(vals_additive_process)





# *******************************
# *** Log-Normal Distribution ***
# *******************************

# simulate the process underlying the generative process approximating a normal distribution as the number of 
# additive components increases towards infinity
{
  
  n_components = 500
  n_values = 10^5
  start_value_multiplicative = 1
  
  # create vector at starting values
  vals_multiplicative_process <- rep(start_value_multiplicative, n_values)
  
  for(j in 1:n_components) {
    # create a vector of multiplicative changes ( .98 / (1/.98) ) for this component 
    multiplicative_change <- sample(c(1/1.02, 1.02), n_values, replace = T)

    # add the vector of changes due to this component
    vals_multiplicative_process <- vals_multiplicative_process * multiplicative_change

    # print the number of current iterations
    print(j)
  }

}

# As you see, the histogram of the values which are the result of a sequence of multiplications has
# a right-skewed distribution, unlike the symmetrical normal. 
# The reason is that multiplying 1 by 1.02 moves it to the right by .02 units (1*1.02=1.02),
# whereas dividing it by the same value moves it to the left by slightly less (1/1.02=0.9804).
hist( vals_multiplicative_process )

# However, the log of a log-normally distributed variable is normally distributed because 
# (i) the log of a product is sum of the logs of the multiplicands, and 
# (ii) -1*log(a) = log(1/a), i.e., the log of a and the log of 1/a are equally far away from 0:
# That is, log(a*b*c*d*...) = log(a) + log(b) + log(c) + log(d) + ...
# This means that a sequence like log( 1 * 2 * (1/2) * 2 ) = 
# log( 1 ) + log( 2 ) + log( 1/2 ) + log( 2 ), which makes the process additive on the log scale.

hist( log(vals_multiplicative_process) )


# The log normal distribution, which happens to represent reaction times reasonably well has two parameters:
# - mulog (the mean of log(X) )
# - sigmalog (the standard deviation of log(X) )

# Let's simulate reaction time from a log-normal distribution with meanlog=7, sigmalog=0.5
sim_RT <- rlnorm(10^4, meanlog = 7, sdlog = 0.5)

# histogram of the simulated RTs
hist(sim_RT)

# histogram of the log of simulated RTs
hist( log(sim_RT) )

# as you see, the mean and sd of the log of our simulated RTs match the parameters we used (mulog=7.0 / sdlog=0.5)
mean( log(sim_RT) )
sd( log(sim_RT) )

