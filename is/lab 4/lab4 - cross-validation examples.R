# Please download the "insurance.txt" dataset into a local directory. 
# Set that directory as the current working directory of R.
# You can achive this using the "setwd" command or by selecting "File -> Change dir..."

# We are going to use the following packages: ipred, prodlim, rpart, and CORElearn. 
# Make sure that the packages are installed.

# You install a package in R with the function install.packages():
#
     install.packages(c("ipred", "prodlim", "CORElearn"))
#
# To install packages without root access:
#
#     install.packages(install.packages(c("ipred", "prodlim", "CORElearn")), lib="path to my folder")
#     library(ipred, lib.loc="path to my folder")
#


ins <- read.table("data/insurance.txt", header = T, sep = ",")


#
#
# CROSS VALIDATION
#
#

library(ipred)

# force the predict function to return class labels only (and not the class probabilities...)
mypredict <- function(object, newdata){predict(object, newdata, type = "class")}


#
# decision trees (rpart)
#

library(rpart)

# 10-fold cross-validation of decision trees for the complete dataset
res <- errorest(insurance~., data=ins, model = rpart, predict = mypredict)
res

# classification accuracy
1-res$error



# leave-one-out strategy
res <- errorest(insurance~., data=ins, model = rpart, predict = mypredict, est.para=control.errorest(k = nrow(ins)))
res

# classification accuracy
1-res$error



#
# decision trees (CORElearn)
#

library(CORElearn)

# force the CoreModel function to train a model of a given type (specified by the parameter "target.model")
mymodel.coremodel <- function(formula, data, target.model){CoreModel(formula, data, model=target.model)}

# force the predict function to return class labels only and also destroy the internal representation of a given model
mypredict.coremodel <- function(object, newdata) {pred <- predict(object, newdata)$class; destroyModels(object); pred}

# 10-fold cross validation 
res <- errorest(insurance~., data=ins, model = mymodel.coremodel, predict = mypredict.coremodel, target.model = "tree")
1-res$error

# leave-one-out strategy
res <- errorest(insurance~., data=ins, model = mymodel.coremodel, predict = mypredict.coremodel, target.model = "tree", est.para=control.errorest(k = nrow(ins)))
1-res$error

