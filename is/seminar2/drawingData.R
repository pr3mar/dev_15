setwd('D:/dev/dev_15/is/seminar2/')

require(ggplot2)
#number of lanes
# 1
x = seq(2, 6, by=1)
numlanes1 = t(read.csv('data/1/numlanes.txt', header=F))
numlanes2 = t(read.csv('data/2/numlanes_LFR.txt', header=F))
numlanes3 = t(read.csv('data/3/numlanes_53.txt', header=F))
numlanes_df = data.frame(x, numlanes1, numlanes2, numlanes3)
names(numlanes_df) = c('numlanes', 'result 1', 'result 2', 'result 3')

glanes <- ggplot(data = numlanes_df, aes(x = numlanes)) +
  geom_line(aes(y = numlanes1, colour = "r1")) +
  geom_line(aes(y = numlanes2 , colour = "r2")) +
  geom_line(aes(y = numlanes3, colour = "r3")) +
  scale_colour_manual("", 
                      breaks = c("r1", "r2", "r3"),
                      values = c("red", "green", "blue")) +
  labs(title="Distance depending on number of lanes", x='number of lanes', y='distance travelled') +
  theme_bw()
glanes
ggsave(filename='numlanes.png', plot=glanes)

#number of cars
x = seq(1, 10, by=1)
numcars1 = t(read.csv('data/1/numcars.txt', header=F))
numcars2 = t(read.csv('data/2/numcars_LFR.txt', header=F))
numcars3 = t(read.csv('data/3/numcars_53.txt', header=F))
numcars_df = data.frame(x, numcars1, numcars2, numcars3)
names(numcars_df) = c('numcars', 'result 1', 'result 2', 'result 3')

gcar <- ggplot(data = numcars_df, aes(x = numcars))
gcar <- gcar + geom_line(aes(y=numcars1, colour = "r1"))
gcar <- gcar + geom_line(aes(y=numcars2 , colour = "r2"))
gcar <- gcar + geom_line(aes(y=numcars3, colour = "r3"))
gcar <- gcar + scale_colour_manual("", 
                      breaks = c("r1", "r2", "r3"),
                      values = c("red", "green", "blue"))
gcar <- gcar + labs(title="Distance depending on number of cars", x='number of cars', y='distance travelled')
gcar <- gcar + theme_bw()
gcar
ggsave(filename='numcars.png', plot=gcar)


# gamma
x = seq(0, 1, by=0.1)
gamma1 = t(read.csv('data/1/gamma.txt', header=F))
gamma2 = t(read.csv('data/2/gamma_LFR.txt', header=F))
gamma3 = t(read.csv('data/3/gamma_53.txt', header=F))
gamma_df = data.frame(x, gamma1, gamma2, gamma3)
names(gamma_df) = c('gamma', 'result 1', 'result 2', 'result 3')

ggamma <- ggplot(data = gamma_df, aes(x = gamma))
ggamma <- ggamma + geom_line(aes(y=gamma1, colour = "r1"))
ggamma <- ggamma + geom_line(aes(y=gamma2 , colour = "r2"))
ggamma <- ggamma + geom_line(aes(y=gamma3, colour = "r3"))
ggamma <- ggamma + scale_colour_manual("", 
                      breaks = c("r1", "r2", "r3"),
                      values = c("red", "green", "blue"))
ggamma <- ggamma + labs(title="Distance depending on discounting factor", x='discounting factor', y='distance travelled')
ggamma <- ggamma + theme_bw()
ggamma
ggsave(filename='gamma.png', plot=ggamma)

#max trials
x = seq(25, 250, by=25)
maxtrials1 = t(read.csv('data/1/maxtrial.txt', header=F))
maxtrials2 = t(read.csv('data/2/maxtrial_LFR.txt', header=F))
maxtrials3 = t(read.csv('data/3/maxtrial_53.txt', header=F))
maxtrials_df = data.frame(x, maxtrials1, maxtrials2, maxtrials3)
names(maxtrials_df) = c('maxtrials', 'result 1', 'result 2', 'result 3')

gtrial <- ggplot(data = maxtrials_df, aes(x = maxtrials))
gtrial <- gtrial + geom_line(aes(y=maxtrials1, colour = "r1"))
gtrial <- gtrial + geom_line(aes(y=maxtrials2 , colour = "r2"))
gtrial <- gtrial + geom_line(aes(y=maxtrials3, colour = "r3"))
gtrial <- gtrial + scale_colour_manual("", 
                      breaks = c("r1", "r2", "r3"),
                      values = c("red", "green", "blue"))
gtrial <- gtrial + labs(title="Distance depending on number of trials", x='number of trials', y='distance travelled')
gtrial <- gtrial + theme_bw()
gtrial
ggsave(filename='maxtrials.png', plot=gtrial)
