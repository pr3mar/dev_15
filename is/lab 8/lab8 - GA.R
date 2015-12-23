# We are going to use the GA package
# Make sure that the package is installed.
# install.packages("GA")
library(GA)

#
#
# EXAMPLE 1: One-dimensional function optimization
#
#

# The asymmetric double claw is difficult to maximize because there are many local solutions.
# Standard derivative-based optimizers would simply climb up the hill closest to the starting value.

f <- function(x) 
{
	y <- (0.46 * (dnorm(x, -1, 2/3) + dnorm(x, 1, 2/3)) +
	(1/300) * (dnorm(x, -0.5, 0.01) + dnorm(x, -1, 0.01) +
	dnorm(x, -1.5, 0.01)) +
	(7/300) * (dnorm(x, 0.5, 0.07) + dnorm(x, 1, 0.07) +
	dnorm(x, 1.5, 0.07)))
	
	y
}

# Plot the double claw
curve(f, from = -3, to = 3, n = 1000)

# For the maximization of this function we may use f directly as the fitness function
GA <- ga(type = "real-valued", fitness = f, min = -3, max = 3)

# The object returned can be plotted
plot(GA)
summary(GA)

# plot the solution
curve(f, from = -3, to = 3, n = 1000)
points(GA@solution, f(GA@solution), col="red")


# The evolution of the population units and the corresponding functions values at each 
# generation can be obtained by defining a new monitor function and then passing this 
# function as an optional argument to ga

myMonitor <- function(obj) 
{
	curve(f, obj@min, obj@max, n = 1000, main = paste("iteration =", obj@iter))
	points(obj@population, obj@fitness, pch = 20, col = 2)
	rug(obj@population, col = 2)
	Sys.sleep(1)
}

GA <- ga(type = "real-valued", fitness = f, min = -3, max = 3, monitor = myMonitor)




#
#
# EXAMPLE 2: Function optimization on two dimensions
#
#

f2 <- function(x1, x2)
{
	(x1^2 + x2 - 11)^2 + (x1 + x2^2 - 7)^2
}

# Let's draw this function

# Fill a matrix with function values (with x1 and x2 on the interval [-4.0, 4.0])

x1 <- seq(-4.0, 4.0, by = 0.1)
x2 <- seq(-4.0, 4.0, by = 0.1)

arrayPoints <- matrix(nrow = length(x1), ncol = length(x2))
for (i in 1:length(x1))
	for (j in 1:length(x2))
		arrayPoints[i,j] <- f2(x1[i],x2[j])

#
# The same result can be obtained using the outer() function:
#
# arrayPoints <- outer(x1, x2, f2)
#

# Draw a perspective plot of a function surface
persp3D(x1, x2, arrayPoints, theta = 50, phi = 20)

# Plot a heat map of our function values
filled.contour(x1, x2, arrayPoints, color.palette = jet.colors)

# Optimize this function with the monitoring of the space searched at each GA iteration

myFitnes2 <- function(x)
{ 
	-f2(x[1],x[2])
}

GA2 <- ga(type = "real-valued", fitness = myFitnes2, min = c(-4.0, -4.0), max = c(4.0, 4.0), crossover = gareal_blxCrossover, popSize = 50, maxiter = 100)

summary(GA2)

# Plot the solution
filled.contour(x1, x2, arrayPoints, color.palette = jet.colors, plot.axes = { axis(1); axis(2); points(GA2@solution, pch = 19, col = 2)})


myMonitor2 <- function(obj) 
{
	contour(x1, x2, arrayPoints, drawlabels = FALSE, col = gray(0.5))
	title(paste("iteration =", obj@iter), font.main = 1)
	points(obj@population, pch = 20, col = 2)
	Sys.sleep(1)
}

GA2 <- ga(type = "real-valued", fitness = myFitnes2, min = c(-4.0, -4.0), max = c(4.0, 4.0), crossover = gareal_blxCrossover, popSize = 50, maxiter = 100, monitor = myMonitor2)

#
#
# EXAMPLE 3: Curve fitting
#
#

# We consider a data on the growth of trees

# The age at which the tree was measured
Age <- c(2.44, 12.44, 22.44, 32.44, 42.44, 52.44, 62.44, 72.44, 82.44, 92.44, 102.44, 112.44)

# The bole volume of the tree
Vol <- c(2.2, 20.0, 93.0, 262.0, 476.0, 705.0, 967.0, 1203.0, 1409.0, 1659.0, 1898.0, 2106.0)

plot(Age, Vol)

# An ecological model for the plant size (measured by volume) as a function of age is the Richards curve:
# f(x) = a*(1-exp(-b*x))^c, where a, b, in c are the model parameters

# Let's fit the Richards curve using genetic algorithms

# We first define the function f (argument theta represents a vector of the model parameters a, b, and c) 
richards <- function(x, theta)
{
	theta[1] * (1 - exp(-theta[2] * x))^theta[3]
}

# We define the fitness function as the sum of squares of the differences between estimated and observed data
myFitness3 <- function(theta, x, y) 
{
	-sum((y - richards(x, theta))^2)
}

# The fitness function needs to be maximized with respect to the parameters in theta, given the observed data in x and y.
# A blend crossover is used for improving the search over the parameter space: for two parents x1 and x2 (assume x1 < x2) 
# it randomly picks a solution in the range [x1 - k*(x2-x1), x2 + k*(x2-x1)], where k represents a constant between 0 and 1.

GA3 <- ga(type = "real-valued", fitness = myFitness3, x = Age, y = Vol, min = c(3000, 0, 2), max = c(4000, 1, 4),
 popSize = 500, crossover = gareal_blxCrossover, maxiter = 5000, run = 200, names = c("a", "b", "c"))

summary(GA3)

# Let's plot our solution

plot(Age, Vol)
lines(Age, richards(Age, GA3@solution))


#
#
# EXAMPLE 4: Attribute subset selection
#
#

# A binary GA can be used in attribute subset selection

 
# Load a training data set
train.data <- read.table("AlgaeLearn.txt", header = T)

# Load a test data set
test.data <- read.table("AlgaeTest.txt", header = T)

# Let's build a regression tree
library(rpart)
rt <- rpart(a1 ~ ., data = train.data)
plot(rt); text(rt, pretty = 0)

# Estimate the model using the mean squared error
mean((test.data$a1 - predict(rt, test.data))^2)


# The problem of attribute subset selection can be treated by GAs using a binary string, with 1
# indicating the presence of a predictor and 0 its absence from a given candidate subset. 
# The fitness of a candidate subset can be measured by one of the several model selection criteria.
# Here we use the mean squared error.

# Split data into two sets: one with the target values and the other with attributes' values
# (drop = FALSE is used to prevent the data frame from being coerced into a vector if a single column is selected)
Y <- train.data[, "a1", drop = FALSE]
X <- train.data[, which(names(train.data) != "a1")]

fitness4 <- function(string) 
{
	# at least one attribute has to be selected
	if (sum(string) == 0)
		return(0)

	# which attributes are selected
	inc <- which(string == 1)
	
	# build a regression tree using a dataset composed of the target values and the selected attributes
	# (drop = FALSE is used to prevent the data frame from being coerced into a vector if a single column is selected)
	rt <- rpart(a1 ~., data = cbind(Y, X[,inc, drop = FALSE]))
	
	# estimate the quality of the model
	-mean((test.data$a1 - predict(rt, test.data))^2)
}

GA4 <- ga("binary", fitness = fitness4, nBits = ncol(X), names = colnames(X), monitor = plot)

summary(GA4)

# If there are more than one solution, select the one with the minimum number of attributes
sel <- GA4@solution[which.min(apply(GA4@solution, 1, sum)),]
sel

# Fit the model using the best attribute subset found by GA
rt1 <- rpart(a1 ~., data = cbind(Y, X[, which(sel == 1)]))
mean((test.data$a1 - predict(rt1, test.data))^2)
plot(rt1); text(rt1, pretty = 0)


#
#
# EXAMPLE 5: Constrained optimization
#
#

# The Knapsack problem is defined as follows: given a set of items, each with a mass and a value, determine the subset 
# of items to be included in a collection so that the total weight is less than or equal to a given limit and the total value 
# is as large as possible.

# a vector of the items' values
values <- c(5, 8, 3, 4, 6, 5, 4, 3, 2)

# a vector of the item's weights
weights <- c(1, 3, 2, 4, 2, 1, 3, 4, 5)

# the knapsack capacity
Capacity <- 10

# A binary GA can be used to solve the knapsack problem. The solution to this problem is a binary string equal to the number 
# of items where the ith bit is 1 if the ith item is in the subset and 0 otherwise. The fitness function should penalize 
# unfeasible solutions.

knapsack <- function(x) 
{
	f <- sum(x * values)
	w <- sum(x * weights)

	if (w > Capacity)
		f <- Capacity - w

	f	
}

GA5 <- ga(type = "binary", fitness = knapsack, nBits = length(weights), maxiter = 1000, run = 200, popSize = 100)

summary(GA5)



#
#
# EXAMPLE 6: Traveling salesman problem
#
#

# Given a list of cities and the distances between each pair of cities, what is the shortest possible route that visits 
# each city exactly once and returns to the origin city?

data("eurodist", package = "datasets")
D <- as.matrix(eurodist)
D

# An individual round tour is represented as a permutation of a default numbering of the cities de?ning the current order 
# in which the cities are to be visited

# Calculation of the tour length
tourLength <- function(tour) 
{
	tour <- c(tour, tour[1])
	dist <- 0
	for (i in 2:length(tour)) 
		dist <- dist + D[tour[i],tour[i-1]]

	dist
}

# The fitness function to be maximized is defined as the reciprocal of the tour length.
tspFitness <- function(tour) 
{
	1/tourLength(tour)
}

GA6 <- ga(type = "permutation", fitness = tspFitness, min = 1, max = ncol(D), popSize = 50, maxiter = 5000, run = 500, pmutation = 0.2)

summary(GA6)

# Reconstruct the solution found 
tour <- GA6@solution[1, ]
tour <- c(tour, tour[1])

tourLength(tour)
colnames(D)[tour]


