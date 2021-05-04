

library(rgl)


# *** problem 1***
# generate data from a linear model <yhat = a + b*x, y ~ N(yhat, sigma)> where
# y: species height (cm)  
# x: food availability (bananas/day)
# let's do 10 data points for now
a = 60
b = 2
sigma = 2

# simulation parameter
n = 100
  
# food availability
x <- runif(n = n, min = 1, max = 10)

# generate data
yhat <- a + b*x
y <- rnorm(n = n, mean = yhat, sd = sigma)

plot(x, yhat)
plot(x, y)


# write a cool likelihood function

monkeys_log_likelihood_single <- function(x, y, a, b, sigma) {
  # how likely is y, given x and the parameters?
  yhat <- a + b*x
  dnorm(y, mean = yhat, sd = sigma, log = T)
}

# test likelihood function on one data point
monkeys_log_likelihood_single(x[1], y[1], a=59, b=1.5, sigma=1.9)
monkeys_log_likelihood_single(x[1], y[1], a=60, b=1.5, sigma=2)
monkeys_log_likelihood_single(x[1], y[1], a=60, b=2, sigma=2)

monkeys_log_likelihood_all <- function(x, y, a, b, sigma) {
  log_likelihoods <- rep(NA, length(x))
  for (i in 1:length(x)) {
    log_likelihoods[i] <- monkeys_log_likelihood_single(x[i], y[i], a, b, sigma)
  }
  sum(log_likelihoods)
}

monkeys_log_likelihood_all(x = x, y = y, a = 60, b = 2, sigma = 2)


# plot likelihood for different values of a
f <- function(a) {
  monkeys_log_likelihood_all(x = x, y = y, a = a, b = 2, sigma = 2)
}

plot(function(x) sapply(x, function(x) f(x)), xlim = c(50,70))


# plot likelihood for different values of b
f2 <- function(sigma) {
  monkeys_log_likelihood_all(x = x, y = y, a = 60, b = 2, sigma = sigma)
}

plot(function(x) sapply(x, function(x) f2(x) ), xlim = c(0.5,5))


# use optim to find the the parameters with the highest likelihood
monkeys_log_likelihood_for_optim <- function(par) {
  log_lik <- monkeys_log_likelihood_all(x = x, y = y, a = par["a"], b = par["b"], sigma = par["sigma"])
  print(log_lik)
  log_lik
}
start_par <- c(a=40, b=0.5, sigma=30)

optim_result <- optim(start_par, monkeys_log_likelihood_for_optim, control = list(fnscale = -1))

optim_result


# *** problem 2 ***
# generate data from a linear model describing a negative relationship between word length and word frequency

# attempt number 1:
freq = a + b*length

# attempt number 2:
log( freq/(1-freq) ) = a + b*length

# model assumptions:
# - freq: number of occurrences/total number of tokens
# question: freq ~ length?
# log-odds(freq) = a + b*length <=> freq = plogis(a + b*length)
#  - log-odds (from probabilities to log-odds) function: qlogis
#  - logistic function (from log-odds to probabilities): plogis

# simulate word lengths
wlens <- sample(1:15, size = n, replace = T)

# simulation settings
n = 100
n_corpus = 10^6
a = 0
b = -1 

(log_odds_freq = a + b*wlens)
plot(wlens, log_odds_freq)

perc_freq = plogis(log_odds_freq)
plot(wlens, perc_freq)

# sample according to prev. determined percentages
n_obs <- rep(NA, n)
for(i in 1:n) {
  n_obs[i] <- rbinom(n = 1, size = n_corpus, prob = perc_freq[i])
}

plot(perc_freq, n_obs)



##

freq = 1/(a + b*wlens)


odds_1:odds_2 

odds_1/(odds_1+odds_2) = p_1
odds_2/(odds_1+odds_2) = p_1


# code from LING 411 that we might need
#
# f = function(a,b) {
#   sapply(1:length(a), function(i) sqrt(a[i])+sqrt(b[i]))
# }
# 
# plot3d(f, 
#        col = colorRampPalette(c("blue", "white")), 
#        xlab = "Intercept", ylab = "Slope", zlab = "Sum of squares", 
#        xlim = 6.5+c(-1, 1), ylim = 2.5+c(-1, 1),
#        aspect = c(1, 1, 0.5))
# points3d(x=6.5, y=2.5, z = sum(compute_errors(6.5, 2.5)^2), color = "red", size = 10)
