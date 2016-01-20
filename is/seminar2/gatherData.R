# simulation.R, line 454 -> comment it -> simulationDraw(simData)

setwd("D:\\dev\\dev_15\\is\\seminar2")
source("RL.R")

#gama
initConsts(numlanes=3, numcars=5)
gama <- c(0,0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1)
results_gama <- c()
for (i in gama) {
	cat(i,'\n')
	qmat <- qlearning(c(3,3,3,3,3), gamma=i, maxtrial=50)
	tmpResults <- c()
	for (j in 1:100) {
		tmpResults[j] <- simulation(qmat)
	}
	results_gama <- c(results_gama, mean(tmpResults))
}
write(results_gama, 'gamma_53.txt', sep=',')

# numcars 
results_numcars <- c()
for (i in 1:10) {
	cat(i,'\n')
	initConsts(numlanes=3, numcars=i)
	qmat <- qlearning(c(3,3,3,3,3), gamma=0.9, maxtrial=50)
	tmpResults <- c()
	for (j in 1:100) {
		tmpResults[j] <- simulation(qmat)
	}
	results_numcars <- c(results_numcars, mean(tmpResults))
}
write(results_numcars, 'numcars_53.txt', sep=',')

# numlanes 
results_numlanes <- c()
for (i in 2:6) {
	cat(i,'\n')
	initConsts(numlanes=i, numcars=5)
	qmat <- qlearning(c(3,3,3,3,3), gamma=0.9, maxtrial=50)
	tmpResults <- c()
	for (j in 1:100) {
		tmpResults[j] <- simulation(qmat)
	}
	results_numlanes <- c(results_numlanes, mean(tmpResults))
}
write(results_numlanes, 'numlanes_53.txt', sep=',')


# maxtrials
initConsts(numlanes=3, numcars=5)
results_maxtrials <- c()
for (i in seq(25, 250, by=25)) {
	cat(i,'\n')
	qmat <- qlearning(c(3,3,3,3,3), gamma=0.9, maxtrial=i)
	tmpResults <- c()
	for (j in 1:100) {
		tmpResults[j] <- simulation(qmat)
	}
	results_maxtrials <- c(results_maxtrials, mean(tmpResults))
}
write(results_maxtrials, 'maxtrial_53.txt', sep=',')



