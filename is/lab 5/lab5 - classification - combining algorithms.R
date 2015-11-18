################################################################
#
# Combining machine learning algorithms
#
################################################################

vehicle <- read.table("vehicle.txt", sep=",", header = T)
summary(vehicle)


set.seed(8678686)
sel <- sample(1:nrow(vehicle), size=as.integer(nrow(vehicle)*0.7), replace=F)
learn <- vehicle[sel,]
test <- vehicle[-sel,]


table(learn$Class)
table(test$Class)


#install.packages("CORElearn")
library(CORElearn)
source("myfunctions.R")


#
# Voting
#

modelDT <- CoreModel(Class ~ ., learn, model="tree")
modelNB <- CoreModel(Class ~ ., learn, model="bayes")
modelKNN <- CoreModel(Class ~ ., learn, model="knn", kInNN = 5)

predDT <- predict(modelDT, test, type = "class")
caDT <- CA(test$Class, predDT)
caDT

predNB <- predict(modelNB, test, type="class")
caNB <- CA(test$Class, predNB)
caNB

predKNN <- predict(modelKNN, test, type="class")
caKNN <- CA(test$Class, predKNN)
caKNN

# combine predictions into a data frame
pred <- data.frame(predDT, predNB, predKNN)
pred

# the class with the most votes wins
voting <- function(predictions)
{
	res <- vector()

  	for (i in 1 : nrow(predictons))  	
	{
		vec <- unlist(predictions[i,])
    		res[i] <- names(which.max(table(vec)))
  	i}

  	factor(res, levels=levels(predictions[,1]))
}

predicted <- voting(pred)
CA(test$Class, predicted)




#
# Weighted voting
#

predDT.prob <- predict(modelDT, test, type="probability")
predNB.prob <- predict(modelNB, test, type="probability")
predKNN.prob <- predict(modelKNN, test, type="probability")

# combine predictions into a data frame
pred.prob <- caDT * predDT.prob + caNB * predNB.prob + caKNN * predKNN.prob
pred.prob

#izberemo razred z najvecjo verjetnostjo
predicted <- levels(learn$Class)[apply(pred.prob, 1, which.max)]

CA(test$Class, predicted)


#
# Stacking
#

stacking.learn <- function(formula, train.data, validation.data, n = 50, model = "tree")
{	
	examples <- nrow(train.data)
	
	tier1.models <- list()

	for (i in 1:n)
	{
		# bootstrapping
		sel <- sample(examples, examples, T)
		tmp.train <- train.data[sel,]

		tier1.models[[i]] <- CoreModel(formula, tmp.train, model = model)		
	}

	class.name <- all.vars(formula)[1]

	tier2.train <- list(validation.data[class.name])

	for (i in 1:n)
	{
		predicted <- predict(tier1.models[[i]], validation.data, type = "class")

		tier2.train <- c(tier2.train, list(predicted))
	}

	tier2.train <- as.data.frame(tier2.train)
	names(tier2.train) <- c("target", paste("model",1:n,sep=""))
	
	tier2.formula <- as.formula(target ~ .)

	tier2.model <- CoreModel(tier2.formula, tier2.train, model = model)
	
	res <- list()
	res$tier1.models <- tier1.models
	res$tier2.model <- tier2.model
	res$tier2.train <- tier2.train
	res
}

stacking.predict <- function(model, data)
{
	tier2.data <- list()

	n <- length(model$tier1.models)

	for (i in 1:n)
	{
		predicted <- predict(model$tier1.models[[i]], data, type = "class")
		tier2.data <- c(tier2.data, list(predicted))
	}

	tier2.data <- as.data.frame(tier2.data)
	names(tier2.data) <- paste("model",1:n,sep="")	

	tier2.data <- cbind(target = 0, tier2.data)

	predicted <- predict(model$tier2.model, tier2.data, type = "class")
	predicted
}


st.model <- stacking.learn(Class ~ ., learn, learn, n=50) # ni dobro learn == validation
st.pred <- stacking.predict(st.model, test)

CA(test$Class, st.pred)


#
# Random forest as a variation of bagging
#

# install.packages("randomForest")
library(randomForest)

rf <- randomForest(Class ~ ., learn)
predicted <- predict(rf, test, type = "class")
CA(test$Class, predicted)


#
# Boosting
#

# install.packages("adabag")
library(adabag)

bm <- boosting(Class ~ ., learn)
predictions <- predict(bm, test) # ne dela kot obicajne predict f-je
names(predictions)

predicted <- predictions$class
CA(test$Class, predicted)

