#######################################################################################################################
#
# PROBLEMS
#
#######################################################################################################################
#
# - load the "auto-mpg.txt" file
#
#	    cars <- read.table("auto-mpg.txt", na.strings = c("?"))
#	    colnames(cars) <- c("mpg","cylinders","displacement","horsepower","weight","acceleration","year","origin","name")
#	    summary(cars)
#	    plot(cars$horsepower ~ cars$displacement)
#
# - identify cases with missing values of the "horsepower" attribute (use which() and is.na() commands)
#
#       sel <- is.na(cars$horsepower)
#
# - model a relationship between "horsepower" and "displacement" using linear regression or locally weighted regression
#
# - fill-in the missing values using the regression models
#
#
#######################################################################################################################
#
# - use the fixed auto-mpg dataset and remove the "name" attribute
#
# - split the dataset in two parts:
#	    training set, which contains cars made before the year 81
#	    test set, which contains cars made in the year 81 or later
#
# - build and evaluate different regression models (the target variable is "mpg")
#
#######################################################################################################################
