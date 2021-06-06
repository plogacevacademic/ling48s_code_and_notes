library(dplyr)
library(magrittr)

# not used for now
n_subjects = 30
n_conditions = 2

# the two conditions are congruent and incongruent are log-normally distributed
rt_congruent_mulog = 7.2
rt_incongruent = 7.5
sigmalog = 0.5

n_measurements_per_condition = 50
rts_congruent = rlnorm(n_measurements_per_condition, meanlog = rt_congruent_mulog, sdlog = sigmalog)
rts_incongruent = rlnorm(n_measurements_per_condition, meanlog = rt_incongruent, sdlog = sigmalog)



"
data {
  int n_data_points;
  real rts[n_data_points]; 
  real c_incongruent[n_data_points]; // numerical contrast for whether the trial is congruent or incongruent 
}
parameters {
  // declare three parameters: mulog_average, sigmalog_average, delta_mu_log_incongruent
}
model {
  
  // priors
  // <specify normal priors for three parameters>
  //    * mulog_average: mean=7, sd=5
  //    * sigmalog_average: mean=0, sd=3
  //    * delta_mu_log_incongruent: mean=0, sd=1

  // likelihood
  for (i in 1:n_data_points) {
    real predicted_mulog;
    // <calculate predicted_mulog for the current data point>
    // <specify the likelihood for the current data point>
  }
}
" %>%
write(file = "./stroop_2.stan")


library(cmdstanr)
model2 <- cmdstan_model(stan_file = "./stroop_2.stan")

data_lst_model2 <-
  list(
    n_data_points = ..., # number of data points
    rts = ... , # a vector with all RTs
    c_incongruent = ... # a vector with contrasts indicating trial congruence (congruent: -0.5, incongruent: -0.5 )
  )

# sample from model2
fit <- ...

# Let's take a look at the distribution of the posterior samples. Do the results make sense?
fit

# extract samples into a data frame called samples

# plot histograms for mulog_average, sigmalog_average, delta_mu_log_incongruent

# calculate the posterior probability that incongruent trials are slower than congruent trials
