# simulation draw -> comment it
setwd("D:\\dev\\dev_15\\is\\seminar2")
source("RL.R")
initConsts(numlanes=3, numcars=5)
gama <- c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1)
results <- c()
for (i in gama) {
	qmat <- qlearning(c(2, 2, 2, 2, 2), gamma=gama[i], maxtrial=50)
	tmpResults <- c()
	for (j in 1:100) {
		tmpResults[j] <- simulation(qmat)
	}
	results[i] <- mean(tmpResults)
}