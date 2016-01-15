# simulation draw -> comment it
setwd("D:\\dev\\dev_15\\is\\seminar2")
source("RL.R")
initConsts(numlanes=3, numcars=5)
qmat <- qlearning(c(3, 3, 3, 3, 3), gamma=0.9, maxtrial=200)
simulation(qmat)
t <- c()
for (i in 1:100) {
	t[i] <-  simulation(qmat)
}
mean(t)
t