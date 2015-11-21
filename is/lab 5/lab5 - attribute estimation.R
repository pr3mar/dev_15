# Attribute evaluation functions are implemented in the package "CORElearn"

# Load the library
#install.packages("CORElearn")  
library(CORElearn)

#
# Attribute estimation in classification
#



#
# Example 1
#

mr <- read.table("../data/mushroom.txt", sep=",", header=T)
summary(mr)

barplot(table(mr$edibility), ylab="Number of species", main="Edibility of mushrooms")


# the attrEval function evaluates the quality of the attributes/dependent variables 
# specified by the formula. Parameter formula is used as a mechanism to select
# attributes and prediction variable(class). The simplest way is to specify just 
# response variable: "Class ~ .". In this case all other attributes in the data set 
# are evaluated with the selected heuristic method.

# attribute evaluation using information gain
sort(attrEval(edibility ~ ., mr, "InfGain"), decreasing = TRUE)

# build a decision tree using information gain as a splitting criterion
dt <- CoreModel(edibility ~ ., mr, model="tree", selectionEstimator="InfGain")
plot(dt, mr)


#
# Example 2
#

quadrant <- read.table("../data/quadrant.txt", sep=",", header=T)
summary(quadrant)

quadrant$Class <- as.factor(quadrant$Class)

plot(quadrant, col=quadrant$Class)
plot(quadrant$a1, quadrant$a2, col=quadrant$Class)

# attribute evaluation using information gain
sort(attrEval(Class ~ ., quadrant, "InfGain"), decreasing = TRUE)

# information gain is a myopic measure 
# (it assumes that attributes are conditionally independent given the class)

# using information gain to construct a decision tree will produce a poor result
dt2 <- CoreModel(Class ~ ., quadrant, model="tree", selectionEstimator="InfGain")
plot(dt2, quadrant)

# non-myopic measures (Relief and ReleifF)
sort(attrEval(Class ~ ., quadrant, "Relief"), decreasing = TRUE)
sort(attrEval(Class ~ ., quadrant, "ReliefFequalK"), decreasing = TRUE)
sort(attrEval(Class ~ ., quadrant, "ReliefFexpRank"), decreasing = TRUE)

# use ?attrEval to find out different variations of ReliefF measure...

# build a decision tree using ReliefFequalK as a splitting criterion
dt3 <- CoreModel(Class ~ ., quadrant, model="tree", selectionEstimator = "ReliefFequalK")
plot(dt3, quadrant)


#
# Example 3
#

players <- read.table("../lab 2/players.txt", sep=",", header=TRUE)
summary(players)

sort(attrEval(position ~ ., players, "InfGain"), decreasing = TRUE)
sort(attrEval(position ~ ., players, "Gini"), decreasing = TRUE)

# the "id" attribute is overestimated, 
# although it does not carry any useful information

# GainRatio moderates the overestimation of the "id" attribute
sort(attrEval(position ~ ., players, "GainRatio"), decreasing = TRUE)

# Both ReliefF and MDL measures identify the "id" attribute as irrelevant
sort(attrEval(position ~ ., players, "ReliefFequalK"), decreasing = TRUE)
sort(attrEval(position ~ ., players, "MDL"), decreasing = TRUE)



#
#
# Attribute selection
#
#


student <- read.table("../lab 4/data/student.txt", sep=",", header=T)
student$G1 <- cut(student$G1, c(-Inf, 9, 20), labels=c("fail", "pass"))
student$G2 <- cut(student$G2, c(-Inf, 9, 20), labels=c("fail", "pass"))
student$G3 <- cut(student$G3, c(-Inf, 9, 20), labels=c("fail", "pass"))
student$studytime <- cut(student$studytime, c(-Inf, 1, 2, 3, 4), labels=c("none", "few", "hefty", "endless"))

#install.packages("ipred")
library(ipred)

# Modelling and prediction functions to be used in cross-validation  
mymodel <- function(formula, data, target.model){CoreModel(formula, data, model=target.model)}
mypredict <- function(object, newdata) {pred <- predict(object, newdata)$class; destroyModels(object); pred}

# 10-fold cv of the complete feature set
res <- errorest(studytime ~ ., data = student, model = mymodel, predict = mypredict, target.model="tree")
1-res$error



#
# Feature selection using a filter method
#

# evaluate the quality of attributes
sort(attrEval(studytime ~ ., student, "MDL"), decreasing = TRUE)

# train a model using the best evaluated attributes
res <- errorest(studytime ~ sex + Walc + Dalc + freetime + higher + paid, data = student, model = mymodel, predict = mypredict, target.model="tree")
1-res$error

# using the appropriate combination of attributes...
res <- errorest(studytime ~ Dalc + paid + G2, data = student, model = mymodel, predict = mypredict, target.model="tree")
1-res$error

#
# Feature selection using a wrapper method
#

# use a greedy algorithm to search through the space of possible features and evaluate each subset by running a model on the subset
source("wrapper.R")
wrapper(student, className="studytime", classModel="tree", folds=10)
