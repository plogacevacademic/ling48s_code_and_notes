
# Remember that so far, we tried to find parameters for which the data have the highest likelihood, i.e. P(D|theta).
# 
# What we really want is a probability distribution over theta. Let's remember the Bayes theorem: (Chapter 1, Lee&Wagenmakers; Chapters 6&7, Farrell&Lewandowsky)
# P(theta|D) = P(D|theta) * P(theta) / P(D)

# two little simulations
p_yes = .3

# experiment 1
exp1 <- list()
exp1$n_trials = 100
exp1$n_yes <- rbinom(1, exp1$n_trials, p_yes)

# experiment 2
exp2 <- list()
exp2$n_trials = 10
exp2$n_yes <- rbinom(1, exp2$n_trials, p_yes)

# likelihood 1
exp1$log_likelihood <- function(tp) {
  log_likelihood <- dbinom(exp1$n_yes, exp1$n_trials, plogis(tp), log = T)
}

# likelihood 2
exp2$log_likelihood <- function(tp) {
  log_likelihood <- dbinom(exp2$n_yes, exp2$n_trials, plogis(tp), log = T)
}

# plot likelihood
plot(exp1$log_likelihood, xlim = c(-100, 100))
plot(exp2$log_likelihood, xlim = c(-100, 100))

# plot likelihood
plot(function(x) exp(exp1$log_likelihood(x)), xlim = c(-6, 4))
plot(function(x) exp(exp2$log_likelihood(x)), xlim = c(-6, 4))

# sample from likelihood
sampled_positions <- c()
cur_exp <- exp2
cur_pos = runif(1, min=-2, max=2)
for (i in 1:10000) {
  proposed_pos = cur_pos + rnorm(1, mean = 0, sd = 1)
  
  log_lik_cur_pos <- cur_exp$log_likelihood(cur_pos)
  log_lik_proposed_pos <- cur_exp$log_likelihood(proposed_pos)
  
  lik_cur_pos <- exp(log_lik_cur_pos)
  lik_proposed_pos <- exp(log_lik_proposed_pos)
  
  relative_likelihood <- lik_proposed_pos / (lik_cur_pos+lik_proposed_pos)
  
  possible_positions <- c(proposed_pos, cur_pos)
  possible_positions_probs <- c(relative_likelihood, 1-relative_likelihood)
  
  cur_pos <- sample(possible_positions, size = 1, prob = possible_positions_probs)
  
  sampled_positions %<>% c(cur_pos)
}

mean(sampled_positions < 0)
HDInterval::hdi(sampled_positions)

ggplot(data=NULL, aes(sampled_positions)) + geom_histogram() + scale_x_continuous(limits = c(-6, 4))

