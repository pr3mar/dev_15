# simulation.R, line 454 -> comment it -> simulationDraw(simData)

setwd("D:\\dev\\dev_15\\is\\seminar2")
source("RL.R")

#gama
initConsts(numlanes=3, numcars=5)
gama <- c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1)
results <- c()
for (i in gama) {
	qmat <- qlearning(c(3, 3, 3, 3, 3), gamma=gama[i], maxtrial=50)
	tmpResults <- c()
	for (j in 1:100) {
		tmpResults[j] <- simulation(qmat)
	}
	results[i] <- mean(tmpResults)
}
write(results, 'gamma.txt', sep=',')

# numcars 
results <- c()
for (i in 1:10) {
	initConsts(numlanes=3, numcars=i)
	qmat <- qlearning(c(3, 3, 3, 3, 3), gamma=0.9, maxtrial=50)
	tmpResults <- c()
	for (j in 1:100) {
		tmpResults[j] <- simulation(qmat)
	}
	results[i] <- mean(tmpResults)
}
write(results, 'numcars.txt', sep=',')

# numlanes 
results <- c()
for (i in 2:6) {
	initConsts(numlanes=i, numcars=5)
	qmat <- qlearning(c(3, 3, 3, 3, 3), gamma=0.9, maxtrial=50)
	tmpResults <- c()
	for (j in 1:100) {
		tmpResults[j] <- simulation(qmat)
	}
	results[i] <- mean(tmpResults)
}
write(results, 'numlanes.txt', sep=',')


# maxtrials
initConsts(numlanes=3, numcars=5)
for (i in seq(25, 250, by=25)) {
	qmat <- qlearning(c(3, 3, 3, 3, 3), gamma=0.9, maxtrial=i)
	tmpResults <- c()
	for (j in 1:100) {
		tmpResults[j] <- simulation(qmat)
	}
	results[i] <- mean(tmpResults)
}
write(results, 'maxtrial.txt', sep=',')



