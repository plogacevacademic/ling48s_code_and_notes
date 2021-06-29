
# You travel to Madagarcar to study a very rare species of lemur (type X) which has recently been discovered.
# Having observed the surroundings of your camp for some time, you observe that a lot of lemurs really do
# look like type X, but that, on average they seem to be shorter than expected, and might actually be of the
# type Y variety. (They look very similar from a distance but differ in height.)
# You observe the camp surroundings for another day, using specialized equipment which allows you to measure 
# the lemur height from a distance [without error]. You record 1000 animals' height over the course of the day.
# The average observed height you observe is around ~40.5 cm, which is unexpectedly low for the type X variety:
# Their heights are normally distributed with mean=45 cm, sd=3 cm. But it is also too high for type Y, because
# their heights are normally distributed with mean=38 cm, sd=3 cm. [Yes, we magically know the population 
# parameters for both types of monkeys.]
# So you speculate that maybe some lemurs are of type X, and some are of type Y. But in what proportion?
# In order to model that, you will need to know that such data can be generated  
#
# Feel free to implement this model in Stan (I prefer that), or by means of optim & a log-likelihood function 
#
# Mixture likelihood in R: 
#          log(lambda * dnorm(y[n], mu1, sigma1, log = F) + (1-lambda) * dnorm(y[n], mu2, sigma2, log = F))
# Mixture likelihood in Stan: (lambda is the mixing parameter)
#  *** section 5.3 / 5.4 in the stan manual: https://mc-stan.org/docs/2_27/stan-users-guide/summing-out-the-responsibility-parameter.html
#          target += log_mix(lambda, normal_lpdf(y[n] | mu1, sigma1), normal_lpdf(y[n] | mu2, sigma2));
# 


# generate observations
n_obs = 1000 # number of obs
mu_X = 45 # mu parameter (X)
mu_Y = 38 # mu parameter (Y)
sd_X = 2.5 # sd parameter (X)
sd_Y = 2  # mu parameter (Y)
perc_X = .3 # percentage of type X lemurs

# determine for each observation whether it's type X or Y
is_type_X <- runif(n_obs) < perc_X

# sample from the distribution of X's when is_type_X is TRUE, and the distribution of Y if FALSE
observations <- ifelse(is_type_X, rnorm(n_obs, mean = mu_X, sd = sd_X), rnorm(n_obs, mean = mu_Y, sd = sd_Y))

# plot the histogram of heights
ggplot(data=NULL, aes(observations)) + geom_histogram(binwidth=1)


# Either (i) stan model, or (ii) log-likelihood + optim  

