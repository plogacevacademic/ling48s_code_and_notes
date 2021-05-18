
# Week 9

# Assignment 2

# We want create a model of the following task: 
# During the study phase, participants are shown 100 faces to study. During, the test phase,
# they are shown 50 of those 'old' faces, intermixed with 50 'new' faces (which were never studied).
# On each test trial participants, have to classify a face as new or old.
# We will assume that they perfom the task in the following way:
# * On 'old' trials (i.e., when the face is 'old'), 
#       -> they recognize the face with probability r and if so, always respond 'old'
#       -> they don't recognize the face with probability (1-r), and if so, they sometimes respond 'old' (with prob g), and sometimes 'new' (with prob 1-g) 
# * On 'new' trials (i.e., when the face is 'new'), 
#       -> they never recognize the face, and therefore, they sometimes respond 'old' (with prob g), and sometimes 'new' (with prob 1-g) 
#
# Let's simulate 50 responses per condition (i.e. 50 'new' trials, and 50 'old' trials).


# load all packages, install if not installed 
library(dplyr)
library(magrittr)
library(tidyr)
library(ggplot2)
library(rgl)


### Simulation

# simulation parameters
r = .9
g = .1

# determine sample size
n_old = 50
n_new = 50

# calculate the probability of 'old' responses
# (this one is tricky, read the description of the model several times)
p_old_oldtrial = 
p_old_newtrial = 

# make the random number generation reproducible
set.seed(123)

# generate responses
resp_old_oldtrials = 
resp_old_newtrials = 

# specify a log-likelihood function
log_lik_fn <- function(resp_old_cond, resp_new_cond, r, g) {

}

### Likelihood function

# test the log-likelihood function
log_lik_fn(resp_old_oldtrials, resp_old_newtrials, r = .5, g = .5)

# specify wrapper function for optim
log_lik_fn_optim <- function(par, resp_old_cond, resp_new_cond) {

}  

# test the wrapper function
log_lik_fn_optim(c(r=.5, g=.5), resp_old_oldtrials, resp_old_newtrials)


### Optimization

# use optim to get ML estimates of r and g
res <- optim(c(r=.5, g=.5), log_lik_fn_optim, resp_old_cond = resp_old_oldtrials, resp_new_cond=resp_old_newtrials, control = list(fnscale=-1) )

# inspect parameter estimates
res

# Consider the logit and the logistic function plotted below which are *inverses* of one another.
plot(qlogis, xlim = c(0, 1)) # Logit (function), https://en.wikipedia.org/wiki/Logit
plot(plogis, xlim = c(-10, 10)) # Logistic function, https://en.wikipedia.org/wiki/Logistic_function

# Fill in the missing information in the following statements:
# * The logit maps values in the interval [<from>; <to>] to the interval [<from>; <to>]
# * The logistic function maps values in the interval [<from>; <to>] to the interval [<from>; <to>]



# Use one of the above functions to create a new log-likelihood wrapper function, such that the domain of log_lik_fn_optim2()
# is *not* constrained with regard to the argument _par_. In other words, change the wrapper function using a transformation of the
# parameters in par, such that it will return a valid likelihood for *any* value of r and g. (For example, even for r=-1, g=10.)
# 
# Only one of the two functions will do the job.
# Please ask a question on the Slack channel if anything is unclear.
#
log_lik_fn_optim2 <- function(par, resp_old_cond, resp_new_cond) {

}  

# use optim to get ML estimates of transformed r and g
res2 <- optim(c(r=0, g=0), log_lik_fn_optim2, resp_old_cond = resp_old_oldtrials, resp_new_cond=resp_old_newtrials, control = list(fnscale=-1))
res2

# compare the log-likelihoods from both model parameterizations
# they should match, at least approximately
res$value
res2$value

# compare the parameter estimates from both model parameterizations
# they will be different
res$par
res2$par

# Transform the parameter estimates to the proportion scale, using the inverse of the transformation function you used in log_lik_fn_optim2()
... something, something ... (res2$par)


# Bonus content:  Please run it, and try to understand how the code works.

# 1. Let's visualize the log-likelihood function over the constrained parameter space:

f_loglik_one <- function(r, g) {
  log_lik_fn(resp_old_cond = resp_old_oldtrials, resp_new_cond = resp_old_newtrials, r, g)
}

f_loglik <- function(r, g) {
  sapply(1:length(r), function(i) f_loglik_one(r[i], g[i]))
}

plot3d(f_loglik, col = "white",
       xlim = c(0, 1), ylim = c(0, 1), zlim = c(-300, 1)
       )

# 2. Let's visualize the likelihood (not log) function over the constrained parameter space:

f_lik_one <- function(r, g) {
  log_lik <- log_lik_fn(resp_old_cond = resp_old_oldtrials, resp_new_cond = resp_old_newtrials, r, g)
  exp(log_lik)
}

f_lik <- function(r, g) {
  sapply(1:length(r), function(i) f_lik_one(r[i], g[i]))
}

# you may have to close the rgl window and fiddle with the zlim parameter to get this to display properly
plot3d(f_lik,
       col = colorRampPalette(c("blue", "white")),
       xlim = c(0, 1), ylim = c(0, 1), zlim = c(0, 1e-9)
       )
