




par(mfrow = c(3,3))

thetas <- seq(.1, .9, .1)

for (theta in thetas)
  plot(function(x) dbinom(x, size = 10, prob = theta), xlim = c(0,10))


lik <- dbinom(1000*6, size = 10000, prob = thetas)
plot(thetas, lik, type = "b")


sum(lik)
