mae <- function(observed, predicted) #mean absolute error
{
  mean(abs(observed - predicted))
}

rmae <- function(observed, predicted, mean.val) # relative mean absolute error
{  
  sum(abs(observed - predicted)) / sum(abs(observed - mean.val))
}

mse <- function(observed, predicted) # mean squared error
{
  mean((observed - predicted)^2)
}

rmse <- function(observed, predicted, mean.val) # relative mean squared error
{  
  sum((observed - predicted)^2)/sum((observed - mean.val)^2)
}


all_errors <- function(observed, predicted, mean.val)
{
  e1 <- mae(observed, predicted)
  e2 <- rmae(observed, predicted, mean.val)
  e3 <- mse(observed, predicted)
  e4 <- rmse(observed, predicted, mean.val)
  c(e1, e2, e3, e4)
}