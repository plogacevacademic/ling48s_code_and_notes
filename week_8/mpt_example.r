
# generate data from a simple MPT model which generates
# (i) correct informed responses and 
# (ii) correct and incorrect responses based on guesses
prob_yes_gram <- function(a, g) {
  a + (1-a)*g
}
prob_yes_ungram <- function(a, g) {
  (1-a)*g  
}

# settings
n_resp_per_cond = 20
a = .95
g = .6  

# calculate probability of yes response
p_yes_gram = prob_yes_gram(a, g)
p_yes_ungram = prob_yes_ungram(a, g)

# simulate responses
responses_ungram = rbinom(n = n_resp_per_cond, size = 1, prob = p_yes_ungram)
responses_gram = rbinom(n = n_resp_per_cond, size = 1, prob = p_yes_gram)
  
# let's try to estimate the parameters

log_lik_mpt1 <- function(responses_ungram, responses_gram, a, g)
{
  # calculate probability of yes response
  p_yes_gram = prob_yes_gram(a, g)
  p_yes_ungram = prob_yes_ungram(a, g)
  
  # log lik for gram
  ll_gram = dbinom(x = responses_gram, size = 1, prob = p_yes_gram, log = T)
  
  # log lik for ungram
  ll_ungram = dbinom(x = responses_ungram, size = 1, prob = p_yes_ungram, log = T)
  
  sum(ll_gram) + sum(ll_ungram)
}

log_lik_mpt1(responses_ungram, responses_gram, a, g)
  

log_lik_mpt1_optim <- function(par, responses_ungram, responses_gram) {
  log_lik_mpt1(responses_ungram, responses_gram, par[["a"]], par[["g"]])
}
  
log_lik_mpt1_optim(par = c(a=.5, g=.5), responses_ungram, responses_gram)
  
optim(c(a=.5, g=.5), log_lik_mpt1_optim, responses_ungram=responses_ungram, responses_gram=responses_gram, control = list(fnscale=-1))

# let's see if we can estimate transformed parameters 

