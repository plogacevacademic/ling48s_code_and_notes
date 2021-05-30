
# Example 1:
# Simple Monte Carlo Simulation:
# Healthy eating: Let's say that Peter decided to eat healthy, and to that end he decided that he will eat a variety 
# of foods in certain proportions.
# Potatoes: .5 (P)
# Selery: .1 (S)
# Carrots: .2 (C)
# Lettuce: .1 (L)
# Avocado: .1 (A)
#
# Peter am generally very forgetful, and always looses notes with a record of what he ate.
# He needs a different approach, and so he decides to to carry a card with the proportions of different 
# foods he plans to eat, and several die.

foods_die <- c(rep("P",5), rep("C",2), "L", "A", "S")
length(foods_die)

eaten <- c()
for(i in 1:1000) {
  cur_food <- sample(foods_die, size = 1)
  eaten %<>% c( cur_food )
}

ggplot(data = NULL, aes(x=as.factor(eaten) )) + geom_histogram(stat="count")

# Example 2:
# Markov Chain Monte Carlo
# Peter goes shopping and needs to make sure that his dietary requirements are well-represented in his shopping cart.
# As usual, he doesn't want to keep track of anything, so he keeps randomly walking around at the food stand.

foods <- c("P", "C", "L", "A", "S")
food_props <- c(P=.5, C=.2, L=.1, A=.1, S=.1)

cur_position <- "L"
bought <- c()

for(i in 1:1000) {
  proposal_position <- sample(foods, 1)
  rel_proportion <- food_props[proposal_position]/(food_props[proposal_position] + food_props[cur_position])
  
  position_alternatives <- c(proposal_position, cur_position)
  position_probabilities <- c(rel_proportion, 1-rel_proportion)
  
  cur_position <- sample(position_alternatives, 1, prob = position_probabilities)
  bought %<>% c(cur_position)
}


df_bought <- data.frame(bought, idx = 1:length(bought))
ggplot(df_bought, aes(idx, bought)) + geom_point()
