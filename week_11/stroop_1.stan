data {
  int n_data_points;
  real rts_congruent[n_data_points]; 
  real rts_incongruent[n_data_points]; 
}
parameters {
  real mu_log[2];
  real<lower=0> sigma_log;
}
model {
  
  // priors
  mu_log[1] ~ normal(7, 5);
  mu_log[2] ~ normal(7, 5);
  sigma_log ~ normal(0, 3);

  // likelihood
  for (i in 1:n_data_points) {
    rts_congruent[i] ~ lognormal(mu_log[1], sigma_log);
    rts_incongruent[i] ~ lognormal(mu_log[2], sigma_log);
  }
}
