
ling48s <- function() sample(c("Utku", "Aref", "Muhammed", "Duygu", "Göksu", "Elifnur", "Burak", "Busra", "Zeynep", "Olgun"), 1)
ling48s()

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



# 

"
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
" %>%
write(file = "./stroop_1.stan")


library(cmdstanr)
model1 <- cmdstan_model(stan_file = "./stroop_1.stan")

data_lst_model1 <-
  list(
    n_data_points = n_measurements_per_condition,
    rts_congruent = rts_congruent,
    rts_incongruent = rts_incongruent
  )

model1$optimize(data = data_lst_model1 )

fit <- model1$sample(data = data_lst_model1, seed = 1234, iter_warmup = 1000, iter_sampling = 1000)

# Let's take a look at the distribution of the posterior samples. Do the results make sense?
fit

# Let's extact the samples
samples_list <- fit$draws()
samples <- posterior::as_draws_df(samples_list)

hist(samples$`mu_log[1]`)
hist(samples$`mu_log[2]`)

sample_delta_mulog <- samples$`mu_log[2]` - samples$`mu_log[1]`

hist(samples$`mu_log[2]` - samples$`mu_log[1]`)
mean(sample_delta_mulog > 0)
