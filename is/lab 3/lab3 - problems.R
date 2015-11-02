######################################################################################################
#
# PROBLEM
#
######################################################################################################
#
# - load the movies dataset
# 
# - transform the attributes "Action", "Animation", "Comedy", "Drama", "Documentary", "Romance",
#   and "Short" into factors
#
# - IMPORTANT: remove the "title" and "budget" attributes from the dataset
#
# - split the data into two sets:
#		training set, which contains information about the movies made before the year 2004
#		test set, which contains information about the movies made in the year 2004 or later
#   then remove the "year" attribute 
#
# - build a decision tree to predict whether or not a movie is a comedy.
#
# - evaluate that model on the test data
# 
#
######################################################################################################
#
# - load the tic-tac-toe training and test datasets:
# 
#	learn <- read.table("tic-tac-toe-learn.txt", header=T, sep=",")
#	test <- read.table("tic-tac-toe-test.txt", header=T, sep=",")
#
# - train a decision tree (the "Class" attribute is our target variable) and evaluate that model
#   on the test data
# 
# - plot the ROC curve for your model (the value "positive" is our positive class) 
#
# - try to improve your model with ROC analysis
#
######################################################################################################




######################################################################################################
#
# Exam problem
#
# We trained a model for a given 4-class problem and used it to classify 4 test examples.
# The obtained class probabilities are shown in the following table:
#
#
#	             
# actual class: | predicted probs:    C1    C2    C3    C4
# C1            |                   0.40  0.30  0.00  0.30
# C2            |                   0.60  0.20  0.20  0.00
# C1            |                   0.25  0.00  0.00  0.75
# C4            |                   0.25  0.50  0.00  0.25
#
#
# Calculate:
# 
# a) the classifiaction accuracy of our model
#
# b) the expected accuracy of the majority model 
#    (assume that the class distribution in the training and test sets are equal)
# 
# c) the specificity and sensitivity of the model, after merging the classes C2, C3, and C4 
#    into a single class
#
# d) the average Brier score of the model
#
# e) the average information score (use the same assumption as in b) )
#
######################################################################################################
