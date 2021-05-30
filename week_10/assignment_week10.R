
library(dplyr)
library(magrittr)
library(ggplot2)
library(cmdstanr)
library(ggplot2)

# Assignment 3: Spam

# Let's model changes in the amount of spam per week. 
# 
# Every week, Peter receives a certain amount of spam. The number is quite variable -- it's usually between 1-40 such mails per week. 
# He hypothesizes that the amount of spam increases over the course of the year.
# Unfortunately, Peter knows nothing about statistics, and he will need our help in determining if that's true.
# To that end, we will need to help him develop a model and test it on simulated data.


# Let us assume that amount of spam does increase over the course of the year. Let's deal with deal with weekly data. 
# So, how do we model this?
# 
# If we knew the total number of spammers out there (and under the assumption that it is constant over time), 
# we could model the arrival or non-arrival of a spam email from a particular spammer as a Bernoulli trial.
# We could therefore model the increase in spam over time as an increase in the parameter (i) p or (ii) N of a binomial distribution, 
# which would mean either (i) higher spam-sending rates for each spammer, or (ii) an increase in the total number of spammers.   
# Unfortunately, we don't how spammers there are, so we can't really use the binomial distribution unless we also  
# want to estimate their number (which would lead to many compications).
# 
# Instead, we will use the so-called Poisson distribution, which is the limiting case of a binomial distribution when p (probability of a success) is low.
# This means that the binomial distribution begins looking a lot like the Poisson distribution as N grows larger as long as p is small.
# In those cases, you can think about the Poisson's only parameter lambda as approximately equal to N*p: Whenever one of them increases,
# the total number of expected successes increases. 

# Here are some examples of the Poisson distribution with different lambda parameters:
x <- 1:20
plot(x, dpois(x, lambda = 3))
plot(x, dpois(x, lambda = 5))
plot(x, dpois(x, lambda = 7))
plot(x, dpois(x, lambda = 10))
plot(x, dpois(x, lambda = 15))

# The Poisson distribution is actually great for us, because the number of potential spammers is definitely very high (large N), 
# the probability of receiving an email from any one of them is low (small p), and a positive increase in either of these parameters (p and N)
# reflects in increase in the spam arrival rate for our purposes, so the Poisson rate parameter lambda is exactly what we need. 

# Please look up the Poisson distribution ...
# ... on wikipedia https://en.wikipedia.org/wiki/Poisson_distribution 
# ... in the R help: ?rpois  
# ... in the Stan help under "Sampling statement": https://mc-stan.org/docs/2_18/functions-reference/poisson.html

# Let's assume that we have 5 years worth of data, on a weekly basis
week_index <- rep(0:51, 5)

# The spam rate during the first week is 1 (a), and increases by 0.5 units per week (b)
a <-
b <-

# each week's lambda is a linear function of the week, as explained in line 54
lambdas <- 
  
# Let's simulate data based on the quantities calculated above
n_spam_mails <- rpois(...)
n_spam_mails

# Define log-likelihood function
log_likelihood_spam <- function(a, b, week_index, n_spam_mails) {
  predicted_lambda <- 
  log_lik <- dpois(...)
  sum(log_lik)
}

# test it
log_likelihood_spam(a, b, week_index=week_index, n_spam_mails=n_spam_mails)

# Define log-prior function
log_prior_spam <- function(a, b) {
  prior_a <- dnorm(..., mean = 0, sd = 10, log = T)
  prior_b <- dnorm(..., mean = 0, sd = 10, log = T)
  prior_a + prior_b
}

# test it
log_prior_spam(a, b)

# Define log-posteior function
log_posterior_spam <- function(a, b, week_index, n_spam_mails) {
  log_lik <- ...
  log_prior <- ...
}

# test it
log_posterior_spam(a, b, week_index=week_index, n_spam_mails=n_spam_mails)


# Define optim wrapper
log_posterior_spam_optim <- function(par, week_index, n_spam_mails) {
  ...
}

log_posterior_spam_optim(par = c(a=a, b=b), week_index=week_index, n_spam_mails=n_spam_mails)

# Run optim
res <- optim(par = c(a=1, b=1), log_posterior_spam_optim, week_index = week_index, n_spam_mails = n_spam_mails, 
             control = list(fnscale=-1))

# Inspect the results. Do they rougly match the assumptions?
res


# Complete this Stan model
"
data {
  int n_data_points;
  int week_idx[n_data_points]; 
  int n_spam_mails[n_data_points]; 
}
parameters {
  // let's make our life easier by constraining a and b to positive numbers since we know this to be true anyway 
  real<lower=0> a;
  real<lower=0> b;
}
model {
  // declare vector of predicted lambdas (all new variables have to be declared at the beginning of the section)
  vector[n_data_points] lambdas;

  // prior for intercept; because a is constrained to be positive in the parameters section, this prior amounts to a *half*-normal prior
  a ~ ... ; // check the example notebooks on how to specify a normal prior centered at zero with a standard deviation of 10

  // prior for slope
  b ~ ... ; // check the example notebooks on how to specify a normal prior centered at zero with a standard deviation of 10

  // calculate predicted lambdas
  for (i in 1:n_data_points) {
    lambdas[i] = ... week_idx[i]; // for each data point, calculate the predicted lambda
  }

  // sampling statment
  n_spam_mails ~ ...(lambdas) ; // look up how to specify that n_spam_mails follows a poisson distribution with the parameter lambdas
}
" %>%
write(file = "./model1.stan")

model1 <- cmdstanr::cmdstan_model(stan_file = "./model1.stan")


data_lst <-
  list(
    n_data_points = length(week_index),
    week_idx = week_index,
    n_spam_mails = n_spam_mails  
  )

# Let's optimize the model to get the MAP (maximum a posteriori) estimate. 
# (It's similar the maximum likelihood estimate, except that we don't want the estimate which maximizes the likelihood, but the posterior.)
model1$optimize(data = data_lst )

# Let's compare it to the result obtained by optim. They should be similar.
res$par

# Let's sample from the posterior of the model
fit <- model1$sample(data = data_lst, seed = 1234, iter_warmup = 1000, iter_sampling = 1000)

# Let's take a look at the distribution of the posterior samples. Do the results make sense?
fit

# Let's extact the samples
samples_list <- fit$draws()
samples <- posterior::as_draws_df(samples_list)

# Plot a histogram of a
hist(samples$a)

# Plot a histogram of b
hist(samples$b)

# Scatterplot of a by b, colored by the value of the posterior at that point
plot(samples$a, samples$b, col = samples$lp__)

