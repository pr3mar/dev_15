#
# SOLUTIONS
#

library(rpart)

CA <- function(observed, predicted)
{
	t <- table(observed, predicted)

	sum(diag(t)) / sum(t)
}

Sensitivity <- function(observed, predicted, pos.class)
{
	t <- table(observed, predicted)

	t[pos.class, pos.class] / sum(t[pos.class,])
}

Specificity <- function(observed, predicted, pos.class)
{
	t <- table(observed, predicted)

	# identify the negative class name
	neg.class <- which(row.names(t) != pos.class)

	t[neg.class, neg.class] / sum(t[neg.class,])
}

brier.score <- function(observedMatrix, predictedMatrix)
{
	sum((observedMatrix - predictedMatrix) ^ 2) / nrow(predictedMatrix)
}



mdata <- read.table("movies.txt", header = T, sep = ",")
for (i in 18:24)
	mdata[,i] <- as.factor(mdata[,i])

mdata$title <- NULL
mdata$budget <- NULL

learn <- mdata[mdata$year < 2004,]
test <- mdata[mdata$year >= 2004,]

learn$year <- NULL
test$year <- NULL
	
dt <- rpart(Comedy~., learn)
plot(dt)
text(dt, pretty = 0)

observed <- test$Comedy
predicted <- predict(dt, test, type="class")

CA(observed, predicted)
Sensitivity(observed, predicted, "1")
Specificity(observed, predicted, "1")


predMat <- predict(dt, test, type = "prob")
obsMat <- model.matrix(~Comedy-1, test)

colnames(predMat)
colnames(obsMat)

brier.score(obsMat, predMat)


#######################################################################################

library(pROC)

learn <- read.table("tic-tac-toe-learn.txt", header=T, sep=",")
test <- read.table("tic-tac-toe-test.txt", header=T, sep=",")

# the "Class" is our target variable 
dt <- rpart(Class ~ ., data = learn)
plot(dt);text(dt)

observed <- test$Class
predicted <- predict(dt, test, type = "class")
CA(observed, predicted)

Sensitivity(observed, predicted, "positive")
Specificity(observed, predicted, "positive")


predMat <- predict(dt, test, type = "prob")
obsMat <- model.matrix(~Class-1, test)

colnames(predMat)
colnames(obsMat)

# the second column contains the probabilities for our positive class

rocobj <- roc(observed, predMat[,"positive"])
plot(rocobj)



tp = rocobj$sensitivities
fp = 1 - rocobj$specificities
dist <- (1-tp)^2 + fp^2
best.cutoff <- rocobj$thresholds[which.min(dist)]
best.cutoff

predicted.label <- factor(ifelse(predMat[,2] >= best.cutoff, "positive", "negative"))
CA(observed, predicted.label)
Sensitivity(observed, predicted.label, "positive")
Specificity(observed, predicted.label, "positive")


########################################################################################

Exam problem solution:

a)    1st example: correct,              confusion matrix:
      2nd example: incorrect,		
      3rd example: incorrect,                   C1 C2 C3 C4
      4th example: incorrect              C1    1  0  0  1
                                          C2    1  0  0  0
      CA = 1/4 = 0.25                     C3    0  0  0  0
                                          C4    0  1  0  0



b)    the majority class is C1           confusion matrix:

      CA = 2/4 = 0.5                            C1 C2 C3 C4
                                          C1    2  0  0  0
                                          C2    1  0  0  0
                                          C3    0  0  0  0
                                          C4    1  0  0  0


c)    1st example: incorrect,            confusion matrix:
      2nd example: incorrect,				
      3rd example: incorrect,                POS=C1 NEG=C2,C3,C4
      4th example: correct                POS   0      2
                                          NEG   1      1
	
      Sensitivity = TP/POS = 0 / 2 = 0
      Specificity = TN/NEG = 1 / 2 = 0.5



d)    the average Brier score = (
                                 ((1.0-0.4)^2 + (0.0-0.3)^2 + (0.0-0.0)^2 + (0.0-0.3)^2) + 
                                 ((0.0-0.6)^2 + (1.0-0.2)^2 + (0.0-0.2)^2 + (0.0-0.0)^2) +
                                 ((1.0-0.25)^2 + (0.0-0.0)^2 + (0.0-0.0)^2 + (0.0-0.75)^2) +
                                 ((0.0-0.25)^2 + (0.0-0.5)^2 + (0.0-0.0)^2 + (1.0-0.25)^2) 
                                )/4 = 0.895


e)    prior probabilities: P(C1) = 0.5, P(C2) = 0.25, P(C3) = 0.0, P(C4) = 0.25

      posterior probabilities for the correct class: P1'(C1)=0.4, P2'(C2)=0.2, P3'(C1)=0.25, P4'(C4)=0.25

      the average information score = ([-(-log2(1-P(C1)) + log2(1-P1'(C1)))] + 
					 	   [-(-log2(1-P(C2)) + log2(1-P2'(C2)))] + 
					 	   [-(-log2(1-P(C1)) + log2(1-P3'(C1)))] + 
					 	   [-log2(P(C4)) + log2(P4'(C4))]
						  ) / 4 = 

				      	= ( log2(0.5) - log2(0.6) 
						  + log2(0.75) - log2(0.8) 
						  + log2(0.5) - log2(0.75) 
						  - log2(0.25) + log2(0.25)
						  ) / 4 =

				      	= -0.2352766