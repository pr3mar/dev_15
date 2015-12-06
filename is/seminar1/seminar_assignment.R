### DATA PREPARATION
library(ipred)
library(rpart)
library(CORElearn)
library(e1071)
library(randomForest)
library(kernlab)
library(nnet)
setwd("D:/dev/dev_15/is/seminar1")
pollution <- read.csv("pollution.txt")
date <- read.table(text = sapply(pollution$DATE, as.character), sep="-", colClasses = "integer", col.names = c("year", "month", "day"))
pollution$DATE <- NULL
pollution$YEAR <- date$year
pollution$MONTH <- date$month # discretisize for seasons
pollution$SEASON <- cut(as.numeric(as.character(pollution$MONTH)), c(-Inf, 3, 7, 9, 11, Inf), labels = c("WINTER", "SPRING", "SUMMER", "AUTOMN", "WINT"))
levels(pollution$SEASON) <- c("WINTER", "SPRING", "SUMMER", "AUTOMN", "WINTER")
pollution$TRAJ <- as.factor(pollution$TRAJ)
pollution$SHORT_TRAJ <- as.factor(pollution$SHORT_TRAJ)

#
### SOME VISUALISATIONS
## rest of it is done in Orange.

summary(pollution)
str(pollution)

plot(pollution$TRAJ)
plot(pollution$SHORT_TRAJ)

# day’s mean air temperature
boxplot(pollution$AMP_TMP2M_mean, names="Mean air temperature")
hist(pollution$AMP_TMP2M_mean)
# hist(log(pollution$AMP_TMP2M_mean))
summary(pollution$AMP_TMP2M_mean)

# day’s mean relative humidity
boxplot(pollution$AMP_RH_mean)# hist(pollution$AMP_RH_mean)
hist(pollution$AMP_RH_mean)
hist(log(pollution$AMP_RH_mean))
summary(pollution$AMP_RH_mean)

#  day’s total precipitation
boxplot(pollution$AMP_PREC_sum)
hist(pollution$AMP_PREC_sum)
hist(log(pollution$AMP_PREC_sum))
summary(pollution$AMP_PREC_sum)

# day’s mean wind speed
boxplot(pollution$AMP_WS_mean)
hist(pollution$AMP_WS_mean)
hist(log(pollution$AMP_WS_mean))
summary(pollution$AMP_WS_mean)

hist(log(pollution$AMP_PREC_sum[pollution$AMP_PREC_sum > 0]))

hist(pollution$O3_max)
hist(log(pollution$PM10))
hist(log(pollution$PM2.5))

plot(pollution$AMP_WS_mean, pollution$AMP_RH_mean) # poln pogodok xD
plot(pollution$AMP_WS_mean, pollution$AMP_TMP2M_mean)
plot(pollution$AMP_TMP2M_mean, pollution$AMP_RH_mean) # poln pogodok xD

plot(pollution$AMP_TMP2M_mean, pollution$AMP_WS_mean)

#
### CLASSIFICATION MODELS
#

#
## O3_MAX CLASSIFICATION MODEL
#
# discretize o3_max data and divide it from the whole data
o3_data = pollution[,c(1:7, 10,12)]
o3_data <- o3_data[complete.cases(o3_data),]
o3_data$O3_max <- cut(o3_data$O3_max, c(-Inf, 60, 120, 180, +Inf), labels=c("LOW", "MODERATE", "HIGH", "EXTREME"))
#o3_data <- o3_data[is.na(o3_data$O3_max) == F,] # remove NA values (for now)
summary(o3_data)

# write.table(o3_data, quote=F,file="o3_data.tab", sep="\t", na="?", row.names = F)
o3_data.learn <- o3_data[o3_data$YEAR <= median(o3_data$YEAR),]
o3_data.test <- o3_data[o3_data$YEAR > median(o3_data$YEAR),]

o3_data.learn$YEAR <- NULL
o3_data.test$YEAR <- NULL

# write.table(o3_data.learn, quote=F,file="o3_data_learn.tab", sep="\t", na="?", row.names = F)
# write.table(o3_data.test, quote=F,file="o3_data_test.tab", sep="\t", na="?", row.names = F)


set.seed(8678686)
sel <- sample(1:nrow(o3_data.learn), size=as.integer(nrow(o3_data.learn)*0.7), replace=F)
# o3_data_learning <- o3_data.learn[sel,]
# o3_data_validation <- o3_data.learn[-sel,]

o3_data_learning <- o3_data.learn
o3_data_validation <- o3_data.test


library(CORElearn)
sort(attrEval(O3_max ~ ., o3_data.learn, "MDL"), decreasing = TRUE)
sort(attrEval(O3_max ~ ., o3_data.learn, "InfGain"), decreasing = TRUE)
sort(attrEval(O3_max ~ ., o3_data.learn, "Gini"), decreasing = TRUE)
sort(attrEval(O3_max ~ ., o3_data.learn, "GainRatio"), decreasing = TRUE)
sort(attrEval(O3_max ~ ., o3_data.learn, "ReliefFequalK"), decreasing = TRUE)
sort(attrEval(O3_max ~ ., o3_data.learn, "Relief"), decreasing = TRUE)
sort(attrEval(O3_max ~ ., o3_data.learn, "ReliefFexpRank"), decreasing = TRUE)

observed <- o3_data_validation$O3_max
obsMat <- model.matrix(~O3_max-1, o3_data_validation)
CA <- function(observed, predicted)
{
  t <- table(observed, predicted)
  
  sum(diag(t)) / sum(t)
}
brier.score <- function(observedMatrix, predictedMatrix)
{
  sum((observedMatrix - predictedMatrix) ^ 2) / nrow(predictedMatrix)
}
mypredict.generic <- function(object, newdata){predict(object, newdata, type = "class")}
mymodel.coremodel <- function(formula, data, target.model){CoreModel(formula, data, model=target.model)}
mypredict.coremodel <- function(object, newdata) {pred <- predict(object, newdata)$class; destroyModels(object); pred}
#
#
# DECISION TREES
#
#
# fit a model using the "rpart" library
dt <- rpart(O3_max ~ ., data = o3_data_learning)
plot(dt);text(dt)
predicted <- predict(dt, o3_data_validation, type="class")
CA(observed, predicted)
predMat <- predict(dt, o3_data_validation, type = "prob")
brier.score(obsMat, predMat)
errorest(O3_max~., data=o3_data_learning, model = rpart, predict = mypredict.generic)
decision_tree = c(CA(observed, predicted), brier.score(obsMat, predMat))
# fit a model using the "CORElearn" library
cm.dt <- CoreModel(O3_max ~ ., data = o3_data_learning, model="tree")
plot(cm.dt, o3_data_learning)
predicted <- predict(cm.dt, o3_data_validation, type="class")
CA(observed, predicted)
predMat <- predict(cm.dt, o3_data_validation, type = "probability")
brier.score(obsMat, predMat)
errorest(O3_max~., data=o3_data_learning, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="tree")
decision_tree = c(decision_tree, CA(observed, predicted), brier.score(obsMat, predMat))
#
#
# NAIVE BAYES CLASSIFIER
#
#
# fit a model using the "e1071" library
nb <- naiveBayes(O3_max ~ ., data = o3_data_learning, laplace = 3)
predicted <- predict(nb, o3_data_validation, type="class")
CA(observed, predicted)
predMat <- predict(nb, o3_data_validation, type = "raw")
brier.score(obsMat, predMat)
errorest(O3_max~., data=o3_data_learning, model = naiveBayes, predict = mypredict.generic)
naive_bayes=c(CA(observed, predicted), brier.score(obsMat, predMat))
# fit a model using the "CORElearn" library
cm.nb <- CoreModel(O3_max ~ ., data = o3_data_learning, model="bayes")
predicted <- predict(cm.nb, o3_data_validation, type="class")
CA(observed, predicted)
predMat <- predict(cm.nb, o3_data_validation, type = "probability")
brier.score(obsMat, predMat)
errorest(O3_max~., data=o3_data_learning, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="bayes")
naive_bayes=c(naive_bayes, CA(observed, predicted), brier.score(obsMat, predMat))
#
#
# KNN
#
#
# fit a model using the "CORElearn" library
cm.knn <- CoreModel(O3_max ~ ., data = o3_data_learning, model="knn", kInNN = 20)
predicted <- predict(cm.knn, o3_data_validation, type="class")
CA(observed, predicted)
predMat <- predict(cm.knn, o3_data_validation, type = "probability")
brier.score(obsMat, predMat)
errorest(O3_max~., data=o3_data_learning, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="knn")
knn_model=c(CA(observed, predicted), brier.score(obsMat, predMat))

#
#
# SVM
#
#
#
sm <- svm(O3_max ~ ., data = o3_data_learning, gamma = 0.1)
predicted <- predict(sm, o3_data_validation, type="class")
CA(observed, predicted)
sm <- svm(O3_max ~ ., o3_data_learning, probability = T)
pred <- predict(sm, o3_data_validation, probability = T)
predMat <- attr(pred, "probabilities")
brier.score(obsMat, predMat)
errorest(O3_max~., data=o3_data_learning, model = svm, predict = mypredict.generic)
svm_model=c(CA(observed, predicted), brier.score(obsMat, predMat))


model.svm <- ksvm(O3_max ~ ., data = o3_data_learning, kernel = "rbfdot")
predicted <- predict(model.svm, o3_data_validation, type = "response")
CA(observed, predicted)
model.svm <- ksvm(O3_max ~ ., data = o3_data_learning, kernel = "rbfdot", prob.model = T)
predMat <- predict(model.svm, o3_data_validation, type = "prob")
brier.score(obsMat, predMat)
mypredict.ksvm <- function(object, newdata){predict(object, newdata, type = "response")}
errorest(O3_max~., data=o3_data_learning, model = ksvm, predict = mypredict.ksvm)
svm_model=c(svm_model, CA(observed, predicted), brier.score(obsMat, predMat))
#
#
# NEURAL NETWORKS
#
#
#
scale.data <- function(data)
{
  norm.data <- data
  
  for (i in 1:ncol(data))
  {
    if (!is.factor(data[,i]))
      norm.data[,i] <- scale(data[,i])
  }
  
  norm.data
}
norm.data <- scale.data(rbind(o3_data_learning,o3_data_validation))
norm.learn <- norm.data[1:nrow(o3_data_learning),]
norm.test <- norm.data[-(1:nrow(o3_data_learning)),]
set.seed(1000)
nn <- nnet(O3_max ~ ., data = norm.learn, size = 5,rang = 0.01, decay = 0.0000001, maxit = 10000000)
predicted <- predict(nn, norm.test, type = "class")
CA(observed, predicted)
predMat <- predict(nn, norm.test, type = "raw")
brier.score(obsMat, predMat)
mypredict.nnet <- function(object, newdata){as.factor(predict(object, newdata, type = "class"))}
errorest(O3_max~., data=norm.learn, model = nnet, predict = mypredict.nnet, size = 5, decay = 0.0001, maxit = 10000)
neural_network=c(CA(observed, predicted), brier.score(obsMat, predMat))
#
#
# RANDOM FOREST
#
#
#
rf <- randomForest(O3_max ~ ., data = o3_data_learning)
predicted <- predict(rf, o3_data_validation, type="class")
CA(observed, predicted)
predMat <- predict(rf, o3_data_validation, type = "prob")
brier.score(obsMat, predMat)
mypredict.rf <- function(object, newdata){predict(object, newdata, type = "class")}
errorest(O3_max~., data=o3_data_learning, model = randomForest, predict = mypredict.generic)
random_forest_model=c(CA(observed, predicted), brier.score(obsMat, predMat))
# fit a model using the "CORElearn" library
cm.rf <- CoreModel(O3_max ~ ., data = o3_data_learning, model="rf")
predicted <- predict(cm.rf, o3_data_validation, type="class")
CA(observed, predicted)
predMat <- predict(cm.rf, o3_data_validation, type = "probability")
brier.score(obsMat, predMat)
errorest(O3_max~., data=o3_data_learning, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="rf")
random_forest_model=c(random_forest_model, CA(observed, predicted), brier.score(obsMat, predMat))
o3_max_clas_res<-data.frame(decision_tree, naive_bayes, knn_model, svm_model, neural_network, random_forest_model)


# write.table(o3_data, quote=F,file="o3_data.tab", sep="\t", na="?", row.names = F)

#
## PM10 CLASSIFICATION MODEL
#

# discretize pm10 data and divide it from the whole data
pm10_data = pollution[,c(1:6,8,10,12)]
pm10_data = pm10_data[complete.cases(pm10_data),]
pm10_data$PM10 <- cut(pm10_data$PM10, c(-Inf, 35, 50, +Inf), labels=c("LOW", "MODERATE", "HIGH"))

pm10_data.learn <- pm10_data[pm10_data$YEAR <= median(pm10_data$YEAR),]
pm10_data.test <- pm10_data[pm10_data$YEAR > median(pm10_data$YEAR),]

pm10_data.learn$YEAR <- NULL
pm10_data.test$YEAR <- NULL

# write.table(pm10_data.learn, quote=F,file="pm10_data_learn.tab", sep="\t", na="?", row.names = F)
# write.table(pm10_data.test, quote=F,file="pm10_data_test.tab", sep="\t", na="?", row.names = F)

set.seed(8678686)
sel <- sample(1:nrow(pm10_data.learn), size=as.integer(nrow(pm10_data.learn)*0.7), replace=F)
# pm10_data.learning <- pm10_data.learn[sel,]
# pm10_data.validation <- pm10_data.learn[-sel,]
pm10_data.learning <- pm10_data.learn
pm10_data.validation <- pm10_data.test



sort(attrEval(PM10 ~ ., pm10_data.learn, "MDL"), decreasing = TRUE)
sort(attrEval(PM10 ~ ., pm10_data.learn, "InfGain"), decreasing = TRUE)
sort(attrEval(PM10 ~ ., pm10_data.learn, "Gini"), decreasing = TRUE)
sort(attrEval(PM10 ~ ., pm10_data.learn, "GainRatio"), decreasing = TRUE)
sort(attrEval(PM10 ~ ., pm10_data.learn, "ReliefFequalK"), decreasing = TRUE)
sort(attrEval(PM10 ~ ., pm10_data.learn, "Relief"), decreasing = TRUE)
sort(attrEval(PM10 ~ ., pm10_data.learn, "ReliefFexpRank"), decreasing = TRUE)

observed <- pm10_data.validation$PM10
obsMat <- model.matrix(~PM10-1, pm10_data.validation)
mypredict.generic <- function(object, newdata){predict(object, newdata, type = "class")}
mymodel.coremodel <- function(formula, data, target.model){CoreModel(formula, data, model=target.model)}
mypredict.coremodel <- function(object, newdata) {pred <- predict(object, newdata)$class; destroyModels(object); pred}
#
#
# DECISION TREES
#
#
# fit a model using the "rpart" library
dt <- rpart(PM10 ~ ., data = pm10_data.learning)
#plot(dt);text(dt)
predicted <- predict(dt, pm10_data.validation, type="class")
CA(observed, predicted)
predMat <- predict(dt, pm10_data.validation, type = "prob")
brier.score(obsMat, predMat)
errorest(PM10~., data=pm10_data.learning, model = rpart, predict = mypredict.generic)
decision_tree = c(CA(observed, predicted), brier.score(obsMat, predMat))
# fit a model using the "CORElearn" library
cm.dt <- CoreModel(PM10 ~ ., data = pm10_data.learning, model="tree")
plot(cm.dt, pm10_data.learning)
predicted <- predict(cm.dt, pm10_data.validation, type="class")
CA(observed, predicted)
predMat <- predict(cm.dt, pm10_data.validation, type = "probability")
brier.score(obsMat, predMat)
errorest(PM10~., data=pm10_data.learning, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="tree")
decision_tree = c(decision_tree, CA(observed, predicted), brier.score(obsMat, predMat))
#
#
# NAIVE BAYES CLASSIFIER
#
#
# fit a model using the "e1071" library
nb <- naiveBayes(PM10 ~ ., data = pm10_data.learning, laplace = 3)
predicted <- predict(nb, pm10_data.validation, type="class")
CA(observed, predicted)
predMat <- predict(nb, pm10_data.validation, type = "raw")
brier.score(obsMat, predMat)
errorest(PM10~., data=pm10_data.learning, model = naiveBayes, predict = mypredict.generic)
naive_bayes=c(CA(observed, predicted), brier.score(obsMat, predMat))
# fit a model using the "CORElearn" library
cm.nb <- CoreModel(PM10 ~ ., data = pm10_data.learning, model="bayes")
predicted <- predict(cm.nb, pm10_data.validation, type="class")
CA(observed, predicted)
predMat <- predict(cm.nb, pm10_data.validation, type = "probability")
brier.score(obsMat, predMat)
errorest(PM10~., data=pm10_data.learning, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="bayes")
naive_bayes=c(naive_bayes, CA(observed, predicted), brier.score(obsMat, predMat))
#
#
# KNN
#
#
# fit a model using the "CORElearn" library
cm.knn <- CoreModel(PM10 ~ ., data = pm10_data.learning, model="knn", kInNN = 20)
predicted <- predict(cm.knn, pm10_data.validation, type="class")
CA(observed, predicted)
predMat <- predict(cm.knn, pm10_data.validation, type = "probability")
brier.score(obsMat, predMat)
errorest(PM10~., data=pm10_data.learning, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="knn")
knn_model=c(CA(observed, predicted), brier.score(obsMat, predMat))
#
#
# SVM
#
#
# fit a model using the "e1071" library
sm <- svm(PM10 ~ ., data = pm10_data.learning, gamma = 0.1)
predicted <- predict(sm, pm10_data.validation, type="class")
CA(observed, predicted)
sm <- svm(PM10 ~ ., pm10_data.learning, probability = T)
pred <- predict(sm, pm10_data.validation, probability = T)
predMat <- attr(pred, "probabilities")
brier.score(obsMat, predMat) # in this particular case, the columns of predMat are in reverse order, so we need to invert them
errorest(PM10~., data=pm10_data.learning, model = svm, predict = mypredict.generic)
svm_model=c(CA(observed, predicted), brier.score(obsMat, predMat))
# fit a model using the "kernlab" library
model.svm <- ksvm(PM10 ~ ., data = pm10_data.learning, kernel = "rbfdot")
predicted <- predict(model.svm, pm10_data.validation, type = "response")
CA(observed, predicted)
model.svm <- ksvm(PM10 ~ ., data = pm10_data.learning, kernel = "rbfdot", prob.model = T)
predMat <- predict(model.svm, pm10_data.validation, type = "prob")
brier.score(obsMat, predMat)
mypredict.ksvm <- function(object, newdata){predict(object, newdata, type = "response")}
errorest(PM10~., data=pm10_data.learning, model = ksvm, predict = mypredict.ksvm)
svm_model=c(svm_model, CA(observed, predicted), brier.score(obsMat, predMat))
#
#
# NEURAL NETWORKS
#
#
# fit a model using the "nnet" library
scale.data <- function(data) # the algorithm is more robust when scaled data is used
{
  norm.data <- data
  
  for (i in 1:ncol(data))
  {
    if (!is.factor(data[,i]))
      norm.data[,i] <- scale(data[,i])
  }
  
  norm.data
}
norm.data <- scale.data(rbind(pm10_data.learning,pm10_data.validation))
norm.learn <- norm.data[1:nrow(pm10_data.learning),]
norm.test <- norm.data[-(1:nrow(pm10_data.learning)),]
set.seed(1000)
nn <- nnet(PM10 ~ ., data = norm.learn, size = 5,rang = 0.01, decay = 0.0000001, maxit = 10000000)
predicted <- predict(nn, norm.test, type = "class")
CA(observed, predicted)
predMat <- predict(nn, norm.test, type = "raw")
brier.score(obsMat, predMat)
mypredict.nnet <- function(object, newdata){as.factor(predict(object, newdata, type = "class"))}
errorest(PM10~., data=norm.learn, model = nnet, predict = mypredict.nnet, size = 5, decay = 0.0001, maxit = 10000)
neural_network=c(CA(observed, predicted), brier.score(obsMat, predMat))
#
#
# RANDOM FOREST
#
#
# fit a model using the "randomForest" library
rf <- randomForest(PM10 ~ ., data = pm10_data.learning)
predicted <- predict(rf, pm10_data.validation, type="class")
CA(observed, predicted)
predMat <- predict(rf, pm10_data.validation, type = "prob")
brier.score(obsMat, predMat)
mypredict.rf <- function(object, newdata){predict(object, newdata, type = "class")}
errorest(PM10~., data=pm10_data.learning, model = randomForest, predict = mypredict.generic)
random_forest_model=c(CA(observed, predicted), brier.score(obsMat, predMat))
# fit a model using the "CORElearn" library
cm.rf <- CoreModel(PM10 ~ ., data = pm10_data.learning, model="rf")
predicted <- predict(cm.rf, pm10_data.validation, type="class")
CA(observed, predicted)
predMat <- predict(cm.rf, pm10_data.validation, type = "probability")
brier.score(obsMat, predMat)
errorest(PM10~., data=pm10_data.learning, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="rf")
random_forest_model=c(random_forest_model, CA(observed, predicted), brier.score(obsMat, predMat))
PM_10_clas_res<-data.frame(decision_tree, naive_bayes, knn_model, svm_model, neural_network, random_forest_model)



observed <- o3_data.test$O3_max
obsMat <- model.matrix(~O3_max-1, o3_data.test)
model.svm <- ksvm(O3_max ~ ., data = o3_data.learn, kernel = "rbfdot")
predicted <- predict(model.svm, o3_data.test, type = "response")
CA(observed, predicted)
model.svm <- ksvm(O3_max ~ ., data = o3_data.learn, kernel = "rbfdot", prob.model = T)
predMat <- predict(model.svm, o3_data.test, type = "prob")
brier.score(obsMat, predMat)
mypredict.ksvm <- function(object, newdata){predict(object, newdata, type = "response")}
errorest(O3_max~., data=o3_data.learn, model = ksvm, predict = mypredict.ksvm)
svm_model=c(svm_model, CA(observed, predicted), brier.score(obsMat, predMat))
res_class_o3<-c(CA(observed, predicted), brier.score(obsMat, predMat))


observed <- pm10_data.test$PM10
obsMat <- model.matrix(~PM10-1, pm10_data.test)
model.svm <- ksvm(PM10 ~ ., data = pm10_data.learn, kernel = "rbfdot")
predicted <- predict(model.svm, pm10_data.test, type = "response")
CA(observed, predicted)
model.svm <- ksvm(PM10 ~ ., data = pm10_data.learn, kernel = "rbfdot", prob.model = T)
predMat <- predict(model.svm, pm10_data.test, type = "prob")
brier.score(obsMat, predMat)
mypredict.ksvm <- function(object, newdata){predict(object, newdata, type = "response")}
errorest(PM10~., data=pm10_data.learn, model = ksvm, predict = mypredict.ksvm)
svm_model=c(svm_model, CA(observed, predicted), brier.score(obsMat, predMat))
res_class_PM10<-c(CA(observed, predicted), brier.score(obsMat, predMat))

#
### REGRESSION MODELS
#

#
## O3_MAX REGRESSION MODELS
#
o3_data_reg = pollution[,c(1:7, 10, 12)]
o3_data_reg <- o3_data_reg[complete.cases(o3_data_reg),]

o3_data_reg.learn <- o3_data_reg[o3_data_reg$YEAR <= median(o3_data_reg$YEAR),]
o3_data_reg.test <- o3_data_reg[o3_data_reg$YEAR > median(o3_data_reg$YEAR),]

#attr evaluation


o3_data_reg.learn$YEAR <- NULL
o3_data_reg.test$YEAR <- NULL

o3_reg_err <- data.frame()
o3_reg_err <- rbind(o3_reg_err, c( 0, 0, 0, 0))
o3_reg_err <- setNames(o3_reg_err, c("MAE", "RMAE", "MSE", "RMSE"))

# write.table(o3_data_reg.learn, quote=F,file="o3_data_reg_learn.tab", sep="\t", na="?", row.names = F)
# write.table(o3_data_reg.test, quote=F,file="o3_data_reg_test.tab", sep="\t", na="?", row.names = F)

source("functions.R")


o3_reg_learning = F

if(o3_reg_learning == T) {
  # learning process
  set.seed(8678686)
  sel <- sample(1:nrow(o3_data_reg.learn), size=as.integer(nrow(o3_data_reg.learn)*0.7), replace=F)
  o3_data_reg.learning <- o3_data_reg.learn[sel,]
  o3_data_reg.validation <- o3_data_reg.learn[-sel,]
  o3 <- o3_data_reg.validation$O3_max
} else {
  o3_data_reg.learning <- o3_data_reg.learn
  o3_data_reg.validation <- o3_data_reg.test
  o3 <- o3_data_reg.validation$O3_max
}


# linear regression
o3.reg.lm.model <- lm(O3_max ~ ., o3_data_reg.learning)
o3.reg.lm.predictions <- predict(o3.reg.lm.model, o3_data_reg.validation)
o3_reg_err[1,] <-all_errors_reg(o3, o3.reg.lm.predictions, mean(o3_data_reg.learning$O3_max))

# regression tree
library(rpart)
o3.reg.regTree.model <- rpart(O3_max ~ ., o3_data_reg.learning,maxdepth = 5, minsplit= 4)
o3.reg.regTree.prediction <- predict(o3.reg.regTree.model, o3_data_reg.validation)
o3_reg_err <- rbind(o3_reg_err, all_errors_reg(o3, o3.reg.regTree.prediction, mean(o3_data_reg.learning$O3_max)))
# plot(o3.reg.regTree.model);text(o3.reg.regTree.model, pretty = 0)

library(CORElearn)
o3.reg.coreReg.model <- CoreModel(O3_max ~ ., data=o3_data_reg.learning, model="regTree", modelTypeReg = 7) 
# 7 is a winner
o3.reg.coreReg.prediction <- predict(o3.reg.coreReg.model, o3_data_reg.validation)
o3_reg_err <- rbind(o3_reg_err, all_errors_reg(o3, o3.reg.coreReg.prediction, mean(o3_data_reg.learning$O3_max)))

modelEval(o3.reg.coreReg.model, o3, o3.reg.coreReg.prediction)

# random forest
library(randomForest)

o3.reg.rf.model <- randomForest(O3_max ~ ., o3_data_reg.learning)
o3.reg.rf.prediction <- predict(o3.reg.rf.model, o3_data_reg.validation)
o3_reg_err <- rbind(o3_reg_err, all_errors_reg(o3, o3.reg.rf.prediction, mean(o3_data_reg.learning$O3_max)))

# svm
library(e1071)

o3.reg.svm.model <- svm(O3_max ~ ., o3_data_reg.learning, kernel="radial", fitted=F)
o3.reg.svm.prediction <- predict(o3.reg.svm.model, o3_data_reg.validation)
o3_reg_err <- rbind(o3_reg_err, all_errors_reg(o3, o3.reg.svm.prediction, mean(o3_data_reg.learning$O3_max)))

# k-nearest neighbor
library(kknn)

o3.reg.knn.model <- kknn(O3_max ~ ., o3_data_reg.learning, o3_data_reg.validation, k = 3)
o3.reg.knn.prediction <- fitted(o3.reg.knn.model)
o3_reg_err <- rbind( o3_reg_err, all_errors_reg(o3, o3.reg.knn.prediction, mean(o3_data_reg.learning$O3_max)))

# neural network
library(nnet)

o3.reg.nn.model <- nnet(O3_max ~ ., o3_data_reg.learning, size = 10, decay = 1e-10, maxit = 10000, linout = T, Hess=T)
o3.reg.nn.prediction <- predict(o3.reg.nn.model, o3_data_reg.validation)
o3_reg_err <- rbind( o3_reg_err,  all_errors_reg(o3, o3.reg.nn.prediction, mean(o3_data_reg.learning$O3_max)))

rownames(o3_reg_err) <- c("LR", "RT1", "RT2", "RF", "SVM", "kNN", "NNet")

o3_reg_err

### PM.25 REGRESSION MODELS

pm25_data_reg = pollution[,c(1:6, 9, 10, 12)]
pm25_data_reg <- pm25_data_reg[complete.cases(pm25_data_reg),]

pm25_data_reg.learn <- pm25_data_reg[pm25_data_reg$YEAR <= median(pm25_data_reg$YEAR),]
pm25_data_reg.test <- pm25_data_reg[pm25_data_reg$YEAR > median(pm25_data_reg$YEAR),]


#attr evaluation


pm25_data_reg.learn$YEAR <- NULL
pm25_data_reg.test$YEAR <- NULL

# write.table(pm25_data_reg.learn, quote=F,file="pm25_data_reg_learn.tab", sep="\t", na="?", row.names = F)
# write.table(pm25_data_reg.test, quote=F,file="pm25_data_reg_test.tab", sep="\t", na="?", row.names = F)

pm25_reg_err <- data.frame()
pm25_reg_err <- rbind(pm25_reg_err, c(0,0,0,0))
pm25_reg_err <- setNames(pm25_reg_err, c("MAE", "RMAE", "MSE", "RMSE"))

pm25_reg_learning = F

if(pm25_reg_learning) {
  #separate the learning data into learning and validation (randomly)
  sel <- sample(1:nrow(pm25_data_reg.learn), size=as.integer(nrow(pm25_data_reg.learn)*0.7), replace=F)
  pm25_data_reg.learning <- pm25_data_reg.learn[sel,]
  pm25_data_reg.validation <- pm25_data_reg.learn[-sel,]
  pm25 <- pm25_data_reg.validation$PM2.5
} else {
  pm25_data_reg.learning <- pm25_data_reg.learn
  pm25_data_reg.validation <- pm25_data_reg.test
  pm25 <- pm25_data_reg.validation$PM2.5
}
# linear regression
pm25.reg.lm.model <- lm(PM2.5 ~ ., pm25_data_reg.learning)
pm25.reg.lm.predictions <- predict(pm25.reg.lm.model, pm25_data_reg.validation)
pm25_reg_err[1,] <- all_errors_reg(pm25, pm25.reg.lm.predictions, mean(pm25_data_reg.learning$PM2.5))

# regression tree
library(rpart)
pm25.reg.regTree.model <- rpart(PM2.5 ~ ., pm25_data_reg.learning,maxdepth = 5, minsplit= 4)
pm25.reg.regTree.prediction <- predict(pm25.reg.regTree.model, pm25_data_reg.validation)
pm25_reg_err <- rbind(pm25_reg_err, all_errors_reg(pm25, pm25.reg.regTree.prediction, mean(pm25_data_reg.learning$PM2.5)))
# plot(pm25.reg.regTree.model);text(pm25.reg.regTree.model, pretty = 0)

library(CORElearn)
pm25.reg.coreReg.model <- CoreModel(PM2.5 ~ ., data=pm25_data_reg.learning, model="regTree", modelTypeReg = 7) # 7 is a winner
pm25.reg.coreReg.prediction <- predict(pm25.reg.coreReg.model, pm25_data_reg.validation)
pm25_reg_err <- rbind(pm25_reg_err, all_errors_reg(pm25, pm25.reg.coreReg.prediction, mean(pm25_data_reg.learning$PM2.5)))

modelEval(pm25.reg.coreReg.model, pm25, pm25.reg.coreReg.prediction)

# random forest
library(randomForest)

pm25.reg.rf.model <- randomForest(PM2.5 ~ ., pm25_data_reg.learning)
pm25.reg.rf.prediction <- predict(pm25.reg.rf.model, pm25_data_reg.validation)
pm25_reg_err <- rbind(pm25_reg_err, all_errors_reg(pm25, pm25.reg.rf.prediction, mean(pm25_data_reg.learning$PM2.5)))

# svm
library(e1071)

pm25.reg.svm.model <- svm(PM2.5 ~ ., pm25_data_reg.learning, kernel="radial", fitted=F)
pm25.reg.svm.prediction <- predict(pm25.reg.svm.model, pm25_data_reg.validation)
pm25_reg_err <- rbind(pm25_reg_err, all_errors_reg(pm25, pm25.reg.svm.prediction, mean(pm25_data_reg.learning$PM2.5)))

# k-nearest neighbor
library(kknn)

pm25.reg.knn.model <- kknn(PM2.5 ~ ., pm25_data_reg.learning, pm25_data_reg.validation, k = 3)
pm25.reg.knn.prediction <- fitted(pm25.reg.knn.model)
pm25_reg_err <- rbind(pm25_reg_err, all_errors_reg(pm25, pm25.reg.knn.prediction, mean(pm25_data_reg.learning$PM2.5)))

# neural network
library(nnet)
pm25.reg.nn.model <- nnet(PM2.5 ~ ., pm25_data_reg.learning, size = 25, maxit = 10000, linout = T, Hess=T)
pm25.reg.nn.prediction <- predict(pm25.reg.nn.model, pm25_data_reg.validation)
# all_errors_reg(pm25, pm25.reg.nn.prediction, mean(pm25_data_reg.learning$PM2.5))
pm25_reg_err <- rbind(pm25_reg_err, all_errors_reg(pm25, pm25.reg.nn.prediction, mean(pm25_data_reg.learning$PM2.5)))


rownames(pm25_reg_err) <- c("LR", "RT1", "RT2", "RF", "SVM", "kNN", "NNet")

# best combinations
# source("wrapperReg.R")
# wrapperReg(o3_data_reg.learning, "O3_max", folds=10)
# wrapperReg(pm25_data_reg.learning, "PM2.5", folds=10)
