# Please download datasets "spamlearn.txt" and "spamtest.txt" 
# into a local directory. Set that directory as the current working directory of R.
# You can achive this using the "setwd" command or by selecting "File -> Change dir..."

# We are going to use the following packages: ipred, prodlim, rpart, CORElearn, e1071, randomForest, 
# kernlab, and nnet. Make sure that the packages are installed.



# You install a package in R with the function install.packages():
#
#     install.packages(c("ipred", "prodlim", "CORElearn", "e1071", "randomForest", "kernlab", "nnet"))
#
# To install packages without root access:
#
#     install.packages(install.packages(c("ipred", "prodlim", "CORElearn", "e1071", "randomForest", "kernlab", "nnet")), lib="path to my folder")
#     library(ipred, lib.loc="path to my folder")
#




learn <- read.table("spamlearn.txt", header = T)
test <- read.table("spamtest.txt", header = T)

# the target variable is the "Class" attribute
observed <- test$Class
obsMat <- model.matrix(~Class-1, test)

# the classification accuracy
CA <- function(observed, predicted)
{
	t <- table(observed, predicted)

	sum(diag(t)) / sum(t)
}

# the brier score
brier.score <- function(observedMatrix, predictedMatrix)
{
	sum((observedMatrix - predictedMatrix) ^ 2) / nrow(predictedMatrix)
}

# the library ipred is needed to perform cross-validation
library(ipred)

mypredict.generic <- function(object, newdata){predict(object, newdata, type = "class")}
mymodel.coremodel <- function(formula, data, target.model){CoreModel(formula, data, model=target.model)}
mypredict.coremodel <- function(object, newdata) {pred <- predict(object, newdata)$class; destroyModels(object); pred}




#
#
# DECISION TREES
#
#

# fit a model using the "rpart" library

library(rpart)
dt <- rpart(Class ~ ., data = learn)
plot(dt);text(dt)
predicted <- predict(dt, test, type="class")
CA(observed, predicted)

predMat <- predict(dt, test, type = "prob")
brier.score(obsMat, predMat)

errorest(Class~., data=learn, model = rpart, predict = mypredict.generic)



# fit a model using the "CORElearn" library

library(CORElearn)
cm.dt <- CoreModel(Class ~ ., data = learn, model="tree")
plot(cm.dt, learn)
predicted <- predict(cm.dt, test, type="class")
CA(observed, predicted)

predMat <- predict(cm.dt, test, type = "probability")
brier.score(obsMat, predMat)

errorest(Class~., data=learn, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="tree")




#
#
# NAIVE BAYES CLASSIFIER
#
#

# fit a model using the "e1071" library

library(e1071)

nb <- naiveBayes(Class ~ ., data = learn)
predicted <- predict(nb, test, type="class")
CA(observed, predicted)

predMat <- predict(nb, test, type = "raw")
brier.score(obsMat, predMat)

errorest(Class~., data=learn, model = naiveBayes, predict = mypredict.generic)



# fit a model using the "CORElearn" library

library(CORElearn)
cm.nb <- CoreModel(Class ~ ., data = learn, model="bayes")
predicted <- predict(cm.nb, test, type="class")
CA(observed, predicted)

predMat <- predict(cm.nb, test, type = "probability")
brier.score(obsMat, predMat)

errorest(Class~., data=learn, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="bayes")




#
#
# KNN
#
#

# fit a model using the "CORElearn" library

library(CORElearn)
cm.knn <- CoreModel(Class ~ ., data = learn, model="knn", kInNN = 5)
predicted <- predict(cm.knn, test, type="class")
CA(observed, predicted)

predMat <- predict(cm.knn, test, type = "probability")
brier.score(obsMat, predMat)

errorest(Class~., data=learn, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="knn")




#
#
# RANDOM FOREST
#
#

# fit a model using the "randomForest" library

library(randomForest)

rf <- randomForest(Class ~ ., data = learn)
predicted <- predict(rf, test, type="class")
CA(observed, predicted)

predMat <- predict(rf, test, type = "prob")
brier.score(obsMat, predMat)

mypredict.rf <- function(object, newdata){predict(object, newdata, type = "class")}
errorest(Class~., data=learn, model = randomForest, predict = mypredict.generic)



# fit a model using the "CORElearn" library

library(CORElearn)
cm.rf <- CoreModel(Class ~ ., data = learn, model="rf")
predicted <- predict(cm.rf, test, type="class")
CA(observed, predicted)

predMat <- predict(cm.rf, test, type = "probability")
brier.score(obsMat, predMat)

errorest(Class~., data=learn, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="rf")




#
#
# SVM
#
#

# fit a model using the "e1071" library

library(e1071)

sm <- svm(Class ~ ., data = learn)
predicted <- predict(sm, test, type="class")
CA(observed, predicted)

sm <- svm(Class ~ ., learn, probability = T)
pred <- predict(sm, test, probability = T)
predMat <- attr(pred, "probabilities")
# in this particular case, the columns of predMat are in reverse order,
# so we need to invert them
brier.score(obsMat, predMat[,c(2,1)])

errorest(Class~., data=learn, model = svm, predict = mypredict.generic)


# fit a model using the "kernlab" library

library(kernlab)

model.svm <- ksvm(Class ~ ., data = learn, kernel = "rbfdot")
predicted <- predict(model.svm, test, type = "response")
CA(observed, predicted)

model.svm <- ksvm(Class ~ ., data = learn, kernel = "rbfdot", prob.model = T)
predMat <- predict(model.svm, test, type = "prob")
brier.score(obsMat, predMat)

mypredict.ksvm <- function(object, newdata){predict(object, newdata, type = "response")}
errorest(Class~., data=learn, model = ksvm, predict = mypredict.ksvm)

#
#
# NEURAL NETWORKS
#
#

# fit a model using the "nnet" library

library(nnet)

# the algorithm is more robust when scaled data is used

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

norm.data <- scale.data(rbind(learn,test))
norm.learn <- norm.data[1:nrow(learn),]
norm.test <- norm.data[-(1:nrow(learn)),]

nn <- nnet(Class ~ ., data = norm.learn, size = 5, decay = 0.0001, maxit = 10000)
predicted <- predict(nn, norm.test, type = "class")
CA(observed, predicted)

# in the case of a binary classification task the method returns probabilities just for one class
# so we have to reconstruct the complete matrix on our own

pm <- predict(nn, norm.test, type = "raw")
predMat <- cbind(1-pm, pm)
brier.score(obsMat, predMat)

mypredict.nnet <- function(object, newdata){as.factor(predict(object, newdata, type = "class"))}
errorest(Class~., data=norm.learn, model = nnet, predict = mypredict.nnet, size = 5, decay = 0.0001, maxit = 10000)

