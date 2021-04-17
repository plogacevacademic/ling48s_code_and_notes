

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
y <- rnorm(n = length(x), mean = yhat, sd = sigma)

plot(x, yhat)
plot(x, y)


# write an old-fashioned discrepancy function

# use optim to find the the parameters with the lowest error

# write a cool likelihood function

monkeys_likelihood_single <- function(x, y, a, b, sigma) {
  # how likely is y, given x and the parameters?
  yhat <- a + b*x
  dnorm(y, mean = yhat, sd = sigma)
}

monkeys_likelihood_all <- function(x, y, a, b, sigma) {
  likelihoods <- rep(NA, length(x))
  for (i in 1:length(x)) {
    likelihoods[i] <- monkeys_likelihood_single(x[i], y[i], a, b, sigma)
  }
  prod(likelihoods)
}

monkeys_likelihood_all(x = x, y = y, a = 60, b = 2, sigma = 2)


# plot likelihood for different values of a
f <- function(a) {
  monkeys_likelihood_all(x = x, y = y, a = a, b = 2, sigma = 2)
}

plot(f, xlim = c(50,70))


# plot likelihood for different values of b
f2 <- function(b) {
  monkeys_likelihood(x = x[1], y = y[1], a = 60, b = b, sigma = 2)
}

plot(f2, xlim = c(50,70))




plot(sqrt)


plot(function(x) dnorm(x, mean = 0, sd = 1), xlim = c(-5,5) )
plot(function(x) pnorm(x, mean = 0, sd = 1), xlim = c(-5,5) )


dnorm(-1, mean = 0, sd = 1)


# use optim to find the the parameters with the highest likelihood

# increase the size of the data set

# see if the 

# write a log-likelihood function





# *** problem 2 ***
# generate data from a linear model describing a negative relationship between word length and word frequency


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
