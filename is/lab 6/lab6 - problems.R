#######################################################################################################################
#
# PROBLEMS
#
#######################################################################################################################
#
# - load the "auto-mpg.txt" file
#
	    cars <- read.table("../data/auto-mpg.txt", na.strings = c("?"))
	    colnames(cars) <- c("mpg","cylinders","displacement","horsepower","weight","acceleration","year","origin","name")
	    summary(cars)
	    plot(cars$horsepower ~ cars$displacement)
      cars$name <- NULL
# - identify cases with missing values of the "horsepower" attribute (use which() and is.na() commands)
      
      summary(cars$horsepower)
      sel <- is.na(cars$horsepower)
      sel
                  
      
# - model a relationship between "horsepower" and "displacement" using linear regression or locally weighted regression
      
      model <- lm(horsepower ~ displacement, cars[!sel,])
      abline(model)
      predict(model, cars[sel,])
      
# - fill-in the missing values using the regression models
      cars$horsepower[sel] <- predict(model, cars[sel,])
      plot(cars$horsepower ~ cars$displacement)
      model2 <- loess(horsepower ~ displacement, data = cars[!sel,], span = 0.3, degree = 1)
      plot(cars$horsepower ~ cars$displacement)
      abline(model)
      points(cars$displacement[!sel], model2$fit, col = "blue")
      ord <- order(cars$displacement[!sel])
      lines(cars$displacement[!sel][ord], model2$fit[ord], col = "red")
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
