
library(dplyr)
library(magrittr)
library(tidyr)
library(cmdstanr)
library(ggplot2)

# Assignment 1

# Let's assume that 150 student's take two exams of varying difficulty. Only some students take both exams, and
# we will assume that their performance on the first exam (or their ability) are unrelated to whether or not
# students also take the second exam.
# Specifically, students 1-100 took exam A (which is relatively *hard*), and students 51-150 took exam B (which is relatively *easy*).
# 
# Because the difficulty of exams A and B is not the same, the results of students 1-50 and 101-150 aren't comparable.
# We want to estimate the students' underlying ability to answer exam questions on this topic while accounting for 
# exam difficulty.

# I will use the following terminology:
# abilityP: probability of answering a question in an average exam correctly [plogis(ability_p) in R; inv_logit(ability_p) in Stan]
# abilityL: log odds of of answering a question in an average exam correctly [qlogis(ability_p) in R; logit(ability_p) in Stan]
# scoreN: discrete score; number of questions answered correctly in a specific exam (out of 100)


# simulate participant ability
n_students = 150
student_id <- 1:n_students

# sample students ability to perform on an average exam from a normal distribution with mean=1, sd=1
student_abilityL <- 
# transform student_abilityL to a probability
student_abilityP <- 

# let's assume symmetric effects of exam
effect_exam_A = -1 # hard exam, percentage of questions that can be answered correctly by student with a fixed ability *decreases*
effect_exam_B = +1 # easy exam, percentage of questions that can be answered correctly by student with a fixed ability *increases*

# calculate the log-odds of correctly answering a question on exams A and B
student_abilityL_examA <- student_abilityL + effect_exam_A
student_abilityL_examB <- student_abilityL + effect_exam_B

# transform student_abilityLs to probabilities 
student_abilityP_examA <- 
student_abilityP_examB <- 

# sample the actual results for each student for each exam from a binomial distribution (assume 100 questions) 
student_scoreN_examA <- 
student_scoreN_examB <- 

# Remember, students 1-100 took exam A, students 51-150 took exam B (only 51-100 took both). ...
#    1-50: A
#  51-100: A, B
# 100-150: B

# ... this is why we'll set the results to NA for students 1-50 on exam A and for students 101-150 for exam B 
student_scoreN_examA[1:50] <- NA
student_scoreN_examB[101:150] <- NA

# join all data in one data frame, and drop all NAs
df <- data.frame(student_id=student_id, grader = "A", c_is_B = -0.5, obs_scoreN = student_scoreN_examA) %>%
      rbind( data.frame(student_id=student_id, grader = "B", c_is_B = +0.5, obs_scoreN = student_scoreN_examB) ) %>%
      cbind(student_abilityP) %>%
      subset(!is.na(obs_scoreN))

head(df)

# plot test results vs theoretical ability
ggplot(data=df, mapping=aes(student_abilityP, obs_scoreN, color = grader)) + 
        geom_point() + geom_abline(intercept = 0, slope = 100) +
        scale_x_continuous(limits = c(0,1)) + scale_y_continuous(limits = c(0,100))


# Complete this Stan model
"
data {
  int n_data_points;
  ... n_students;
  int student_id[...]; 
  ... c_is_exam_B...; 
  int obs_scoreN[n_data_points]; 
}
parameters {
  real delta_examL;
  
  // average student ability
  real avg_abilityL;

  // standard deviation of the latent (unobserved) student ability distribution
  real<lower=0.01> sigma_abilityL_student;

  // by-student deviations from the average ability 
  real delta_abilityL_student[n_students];
}
model {
  // priors
  delta_examL ~ normal(0, 3);
  avg_abilityL ~ normal(0, 3);
  sigma_abilityL_student ~ normal(0, 10);

  // prior over student ability
  for (i in 1:n_students) { 
     
    // complete, taking into account (i) how we assumed student abilities are distributed, and (ii) assuming that we
    // are dealing with deviations from the average here, not their absolute abilites
    delta_abilityL_student[i] ~ ... 
  }

  for (j in 1:n_data_points)
  {
    int current_student = student_id[j];

    // caculate the predicted ability of the current student
    real predicted_student_abilityL = ...

    // calculate the current *additional* effect of exam difficulty 
    real current_exam_effect = ...

    // calculate the predicted *log-odds* of correctly answering a question on the *curent* exam
    real predicted_scoreL = ...

    // transform it to a real probability
    real predicted_scoreP = inv_logit( predicted_scoreL );

    // state that the obtained score follows a binomial distribution with N=100, and probability of success predicted_scoreP
    // look up the binomial distribution sampling statement in the stan documentation (mc-stan.org) 
    obs_scoreN[j] ~ ...
  }
}
" %>%
  write(file = "./model1.stan")

model1 <- cmdstanr::cmdstan_model(stan_file = "./model1.stan")

# initialize the data list
data_lst <-
  list(
    n_data_points = ...
    n_students = ...
    student_id = ...
    c_is_grader_B = ...
    obs_scoreN = ...
  )

# Let's test the model and whether it accepts the specified data set by optimizing it.
res <- model1$optimize(data = data_lst )

# Let's sample from the posterior of the model
fit <- model1$sample(data = data_lst, seed = 1234, iter_warmup = 1000, iter_sampling = 1000)

fit

# Let's extact the samples
samples_list <- fit$draws()
samples <- posterior::as_draws_df(samples_list)

# add the average ability samples to the by-subject deltas
samples_avg <- samples$avg_abilityL
samples_delta <- samples[sprintf("delta_abilityL_student[%d]", 1:n_students)]
samples_ability <- samples_avg + samples_delta

# extract the summary of by subject ability estimates 
abilityL <- samples_ability %>% apply( MARGIN = 2, function(x) quantile(x, c(.05, .5, .95)) ) %>% t() %>% as.data.frame()
abilityL %<>% cbind(student_id = rownames(.))
abilityL$student_id %<>% gsub("delta_abilityL_student\\[", "", .) %>% gsub("\\]", "", .) %>% as.integer()
colnames(abilityL)[1:3] <- c("est_lower", "est_mid", "est_upper")
head(abilityL)

df_merged <- df %>% left_join(abilityL)
df_merged$student_abilityL <- qlogis( df_merged$student_abilityP )

# If you got the model right, out estimates should on the straight line (which is the identity function y=x) 
# Et voila, we have reconstructed participants' abilities (on the log-odds scale).
ggplot(data=df_merged, mapping=aes(student_abilityL, qlogis(obs_scoreN/100), color = grader)) + 
  geom_point() + geom_abline(intercept = 0, slope = 1) + 
  geom_point(aes(qlogis(student_abilityP), est_mid), color = "blue")


# Please recreate the above plot, with all elements, on a probability scale
...


