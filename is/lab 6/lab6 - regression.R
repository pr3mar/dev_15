########################################################################################
#
# Regression
#
########################################################################################

#
# Example 1 (linear regression)
#


# artificial data set - cooling of tea in a thermal bottle
 
min <- c(0,5,8,11,15,18,22,25,30,34,38,42,45,50)
temp <- c(93.3,90.8,89.4,87.9,86.1,84.7,82.9,81.6,79.5,77.9,76.3,74.8,73.6,71.84973)
cooling <- data.frame(min, temp)

# draw a plot
plot(cooling)

# the plot suggests that there is a decreasing linear relationship between time and temperature

# fit a linear model
lm.cooling <- lm(temp ~ min, cooling)
lm.cooling
summary(lm.cooling)

# draw the fit line on the plot
abline(lm.cooling)


#
# Example 2 (locally weighted regression)
#

# the situation changes as we measure for a longer period of time...

min <- c(0,50,100,150,200,250,300,350,400,450,500,550,600,650,700)
temp <- c(93.3,71.8,56.5,45.5,37.7,32.2,28.2,25.3,23.3,21.9,20.8,20.1,19.6,19.2,18.99864)
cooling2 <- data.frame(min, temp)

plot(cooling2)

# it is clear now that this is not a linear function...

# the linear model is a poor approximation 
lm.cooling2 <- lm(temp ~ min, cooling2)
lm.cooling2
summary(lm.cooling2)
abline(lm.cooling2)

# model residuals are the differences between the observed and predicted responses
lm.cooling2$res

plot(cooling2$min, lm.cooling2$res)
abline(h = 0)

plot(lm.cooling2$res ~ lm.cooling2$fit)
abline(h = 0)


# locally weighted regression performs a regression around a point of interest using only training data that are local to that point
 
lwrm <- loess(temp ~ min, data = cooling2, span = 0.5, degree = 1)
plot(cooling2)
lines(cooling2$min, lwrm$fit, col = "red")

lwrm2 <- loess(temp ~ min, data = cooling2, span = 0.3, degree = 1)
lines(cooling2$min, lwrm2$fit, col = "blue")

lwrm3 <- loess(temp ~ min, data = cooling2, span = 0.5, degree = 2)
lines(cooling2$min, lwrm3$fit, col = "green")




# the lwrm2 model's residuals
plot(cooling2$min, lwrm2$res)
abline(h=0)

# model can be used to predict the temperature 
newdata = c(11,12,14.5,123.4,156,320)
predict(lwrm3, newdata)




####################################################################
#
# evaluation of regression models
#
####################################################################

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


##########################################################################
#
# an overview of regression models
#
##########################################################################

# training data set
train.data <- read.table("../data/AlgaeLearn.txt", header = T)
summary(train.data)

# test data set
test.data <- read.table("../data/AlgaeTest.txt", header = T)
observed <- test.data$a1




#
# linear model
#

lm.model <- lm(a1 ~ ., data = train.data)
lm.model


predicted <- predict(lm.model, test.data)
mae(observed, predicted)
rmae(observed, predicted, mean(train.data$a1))



#
# regression tree
#

library(rpart)

rt.model <- rpart(a1 ~ ., train.data)
predicted <- predict(rt.model, test.data)
rmae(observed, predicted, mean(train.data$a1))

plot(rt.model);text(rt.model, pretty = 0)


# parameters that control aspects of the rpart fit
rpart.control()

# build a tree with optional parameters for controlling tree growth (eg maxdepth)
rt.model <- rpart(a1 ~ ., train.data, maxdepth = 2)
plot(rt.model);text(rt.model, pretty = 0)

# the minsplit parameter determines the minimum number of observations that must 
# exist in a node in order for a split to be attempted
rt.model <- rpart(a1 ~ ., train.data, minsplit = 3)
plot(rt.model);text(rt.model, pretty = 0)

# cp parameter controls a compomise between predictive accuracy and tree size
rt.model <- rpart(a1 ~ ., train.data, cp = 0)
plot(rt.model);text(rt.model, pretty = 0)

# a table of optimal prunings based on a complexity parameter
printcp(rt.model)

# prune the tree using the complexity parameter associated with minimum error (eg xerror)
rt.model2 <- prune(rt.model, cp = 0.02) # tudi za klasifikacijo!!
plot(rt.model2)
predicted <- predict(rt.model2, test.data)
rmae(observed, predicted, mean(train.data$a1))




# regression trees are also implemented in CORElearn package
library(CORElearn)

# modelTypeReg
# type: integer, default value: 1, value range: 1, 8 
# type of models used in regression tree leaves (1=mean predicted value, 2=median predicted value, 3=linear by MSE, 4=linear by MDL, 5=linear as in M5, 6=kNN, 7=Gaussian kernel regression, 8=locally weighted linear regression).

rt.core <- CoreModel(a1 ~ ., data=train.data, model="regTree", modelTypeReg = 1)
predicted <- predict(rt.core, test.data)
rmae(observed, predicted, mean(train.data$a1))

modelEval(rt.core, test.data$a1, predicted)




# an overfitted tree will not perform well on unseen data
# (the minNodeWeightTree parameter determines the minimal number of instances of a leaf in the tree model,
#  the selectedPrunerReg parameter determines the regression tree pruning method used)

rt.core2 <- CoreModel(a1 ~ ., data=train.data, model="regTree",  modelTypeReg = 1, minNodeWeightTree = 1, selectedPrunerReg = 0)
plot(rt.core2, train.data)
predicted <- predict(rt.core2, test.data)
rmae(observed, predicted, mean(train.data$a1))

# using a linear model in the leaves can also overfit
rt.core3 <- CoreModel(a1 ~ ., data=train.data, model="regTree",  modelTypeReg = 3)
plot(rt.core3, train.data)
predicted <- predict(rt.core3, test.data)
rmae(observed, predicted, mean(train.data$a1))

# description of available parameters
?helpCore

rt.core4 <- CoreModel(a1 ~ PO4 + size + mxPH, data = train.data, model="regTree", modelTypeReg = 3)
plot(rt.core4, train.data)
predicted <- predict(rt.core4, test.data)
rmae(observed, predicted, mean(train.data$a1))
#
# random forest
#

library(randomForest)

rf.model <- randomForest(a1 ~ ., train.data)
predicted <- predict(rf.model, test.data)
rmae(observed, predicted, mean(train.data$a1))





#
# svm
#

library(e1071)

svm.model <- svm(a1 ~ ., train.data)
predicted <- predict(svm.model, test.data)
rmae(observed, predicted, mean(train.data$a1))





#
# k-nearest neighbor
#

#install.packages("kknn")
library(kknn)

knn.model <- kknn(a1 ~ ., train.data, test.data, k = 3)
predicted <- fitted(knn.model)
rmae(observed, predicted, mean(train.data$a1))


#
# neural network
#

library(nnet)

#
# important!!! 
# in regression problems use linout = T

#set.seed(6789)
nn.model <- nnet(a1 ~ ., train.data, size = 5, decay = 1e-4, maxit = 10000, linout = T)
predicted <- predict(nn.model, test.data)
rmae(observed, predicted, mean(train.data$a1))




#######################################################################################
#
# Feature selection
#
#######################################################################################

# model can be improved by choosing appropriate subset of attributes

rt.core <- CoreModel(a1 ~ ., data=train.data, model="regTree", modelTypeReg = 3)
predicted <- predict(rt.core, test.data)
rmae(observed, predicted, mean(train.data$a1))

rt.core <- CoreModel(a1 ~ PO4 + size + mxPH, data=train.data, model="regTree", modelTypeReg = 3)
predicted <- predict(rt.core, test.data)
rmae(observed, predicted, mean(train.data$a1))



# a wrapper method can be used to evaluate feature subsets
source("wrapperReg.R")
wrapperReg(train.data, "a1", folds=10)
