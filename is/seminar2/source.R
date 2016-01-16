# simulation.R, line 454 -> comment it -> simulationDraw(simData)

setwd("D:\\dev\\dev_15\\is\\seminar2")
source("RL.R")
initConsts(numlanes=3, numcars=5)
qmat <- qlearning(c(3, 3, 3, 3, 3), gamma=0.9, maxtrial=50)
simulation(qmat)
t <- c()
for (i in 1:100) {
	cat(i,'')
	t[i] <-  simulation(qmat)
	flush.console()
}
mean(t)
t