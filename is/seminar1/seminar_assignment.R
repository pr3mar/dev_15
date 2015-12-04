# devide into test and learning set such as:
# 1. test set is AFTER learning set, say 1994 - 2008 is learning, 2008 -> test set
# 2. seasoning is very important! include it in the division
# 3. divide the learning set into learning and validation set and do iterations to set the parameters.
# 4. 

# read the data
setwd("D:/dev/dev_15/is/seminar1")
pollution <- read.csv("pollution.txt")
summary(pollution)
str(pollution)
date <- read.table(text = sapply(pollution$DATE, as.character), sep="-", colClasses = "integer", col.names = c("year", "month", "day"))
pollution$DATE <- NULL
pollution$YEAR <- date$year
pollution$MONTH <- date$month # discretisize for seasons
pollution$SEASON <- cut(as.numeric(as.character(pollution$MONTH)), c(-Inf, 3, 7, 9, 11, Inf), labels = c("WINTER", "SPRING", "SUMMER", "AUTOMN", "WINT"))
levels(pollution$SEASON) <- c("WINTER", "SPRING", "SUMMER", "AUTOMN", "WINTER")
pollution$TRAJ <- as.factor(pollution$TRAJ)
pollution$SHORT_TRAJ <- as.factor(pollution$SHORT_TRAJ)

# discretize o3_max data and divide it from the whole data
o3_data = pollution[,c(1:7, 10,12)]
o3_data <- o3_data[complete.cases(o3_data),]
o3_data$O3_max <- cut(o3_data$O3_max, c(-Inf, 60, 120, 180, +Inf), labels=c("LOW", "MODERATE", "HIGH", "EXTREME"))
#o3_data <- o3_data[is.na(o3_data$O3_max) == F,] # remove NA values (for now)
summary(o3_data)

# write.table(o3_data, quote=F,file="o3_data.tab", sep="\t", na="?", row.names = F)
o3_data.learn <- o3_data[o3_data$YEAR <= median(o3_data$YEAR),]
o3_data.test <- o3_data[o3_data$YEAR > median(o3_data$YEAR),]

o3_data.learn$YEAR <- NULL
o3_data.test$YEAR <- NULL

# write.table(o3_data.learn, quote=F,file="o3_data_learn.tab", sep="\t", na="?", row.names = F)
# write.table(o3_data.test, quote=F,file="o3_data_test.tab", sep="\t", na="?", row.names = F)

library(CORElearn)
sort(attrEval(O3_max ~ ., o3_data.learn, "MDL"), decreasing = TRUE)
sort(attrEval(O3_max ~ ., o3_data.learn, "InfGain"), decreasing = TRUE)
sort(attrEval(O3_max ~ ., o3_data.learn, "Gini"), decreasing = TRUE)
sort(attrEval(O3_max ~ ., o3_data.learn, "GainRatio"), decreasing = TRUE)
sort(attrEval(O3_max ~ ., o3_data.learn, "ReliefFequalK"), decreasing = TRUE)
sort(attrEval(O3_max ~ ., o3_data.learn, "Relief"), decreasing = TRUE)
sort(attrEval(O3_max ~ ., o3_data.learn, "ReliefFexpRank"), decreasing = TRUE)


# write.table(o3_data, quote=F,file="o3_data.tab", sep="\t", na="?", row.names = F)


# discretize pm10 data and divide it from the whole data
pm10_data = pollution[,c(1:6,8,10,12)]
pm10_data = pm10_data[complete.cases(pm10_data),]
pm10_data$PM10 <- cut(pm10_data$PM10, c(-Inf, 35, 50, +Inf), labels=c("LOW", "MODERATE", "HIGH"))
#pm10_data <- pm10_data[is.na(pm10_data$PM10) == F,] # remove NA values (for now)

pm10_data.learn <- pm10_data[pm10_data$YEAR <= median(pm10_data$YEAR),]
pm10_data.test <- pm10_data[pm10_data$YEAR > median(pm10_data$YEAR),]

pm10_data.learn$YEAR <- NULL
pm10_data.test$YEAR <- NULL

# write.table(pm10_data.learn, quote=F,file="pm10_data_learn.tab", sep="\t", na="?", row.names = F)
# write.table(pm10_data.test, quote=F,file="pm10_data_test.tab", sep="\t", na="?", row.names = F)


library(CORElearn)
sort(attrEval(PM10 ~ ., pm10_data.learn, "MDL"), decreasing = TRUE)
sort(attrEval(PM10 ~ ., pm10_data.learn, "InfGain"), decreasing = TRUE)
sort(attrEval(PM10 ~ ., pm10_data.learn, "Gini"), decreasing = TRUE)
sort(attrEval(PM10 ~ ., pm10_data.learn, "GainRatio"), decreasing = TRUE)
sort(attrEval(PM10 ~ ., pm10_data.learn, "ReliefFequalK"), decreasing = TRUE)
sort(attrEval(PM10 ~ ., pm10_data.learn, "Relief"), decreasing = TRUE)
sort(attrEval(PM10 ~ ., pm10_data.learn, "ReliefFexpRank"), decreasing = TRUE)


### REGRESSION
o3_data_reg = pollution[,c(1:7, 10, 12)]
o3_data_reg <- o3_data_reg[complete.cases(o3_data_reg),]

o3_data_reg.learn <- o3_data_reg[o3_data_reg$YEAR <= median(o3_data_reg$YEAR),]
o3_data_reg.test <- o3_data_reg[o3_data_reg$YEAR > median(o3_data_reg$YEAR),]

o3_data_reg.learn$YEAR <- NULL
o3_data_reg.test$YEAR <- NULL

o3_reg_err <- data.frame()
o3_reg_err <- rbind(o3_reg_err, c( 0, 0, 0, 0))
o3_reg_err <- setNames(o3_reg_err, c("MAE", "RMAE", "MSE", "RMSE"))


pm25_data_reg = pollution[,c(1:6, 9, 10, 12)]
pm25_data_reg <- pm25_data_reg[complete.cases(pm25_data_reg),]

pm25_data_reg.learn <- pm25_data_reg[pm25_data_reg$YEAR <= median(pm25_data_reg$YEAR),]
pm25_data_reg.test <- pm25_data_reg[pm25_data_reg$YEAR > median(pm25_data_reg$YEAR),]

pm25_data_reg.learn$YEAR <- NULL
pm25_data_reg.test$YEAR <- NULL

pm25_reg_err <- data.frame()
pm25_reg_err <- rbind(pm25_reg_err, c(0,0,0,0))
pm25_reg_err <- setNames(pm25_reg_err, c("MAE", "RMAE", "MSE", "RMSE"))


# write.table(o3_data_reg.learn, quote=F,file="o3_data_reg_learn.tab", sep="\t", na="?", row.names = F)
# write.table(o3_data_reg.test, quote=F,file="o3_data_reg_test.tab", sep="\t", na="?", row.names = F)

source("functions.R")

set.seed(8678686)
sel <- sample(1:nrow(o3_data_reg.learn), size=as.integer(nrow(o3_data_reg.learn)*0.7), replace=F)
o3_data_reg.learning <- o3_data_reg.learn[sel,]
o3_data_reg.validation <- o3_data_reg.learn[-sel,]
o3 <- o3_data_reg.validation$O3_max

sel <- sample(1:nrow(pm25_data_reg.learn), size=as.integer(nrow(pm25_data_reg.learn)*0.7), replace=F)
pm25_data_reg.learning <- pm25_data_reg.learn[sel,]
pm25_data_reg.validation <- pm25_data_reg.learn[-sel,]
pm25 <- pm25_data_reg.validation$PM2.5

# linear regression
o3.reg.lm.model <- lm(O3_max ~ ., o3_data_reg.learning)
o3.reg.lm.predictions <- predict(o3.reg.lm.model, o3_data_reg.validation)
o3_reg_err[1,] <-all_errors(o3, o3.reg.lm.predictions, mean(o3_data_reg.learning$O3_max))

pm25.reg.lm.model <- lm(PM2.5 ~ ., pm25_data_reg.learning)
pm25.reg.lm.predictions <- predict(pm25.reg.lm.model, pm25_data_reg.validation)
pm25_reg_err[1,] <- all_errors(pm25, pm25.reg.lm.predictions, mean(pm25_data_reg.learning$PM2.5))


# regression tree
library(rpart)
o3.reg.regTree.model <- rpart(O3_max ~ ., o3_data_reg.learning,maxdepth = 5, minsplit= 4)
o3.reg.regTree.prediction <- predict(o3.reg.regTree.model, o3_data_reg.validation)
o3_reg_err <- rbind(o3_reg_err, all_errors(o3, o3.reg.regTree.prediction, mean(o3_data_reg.learning$O3_max)))
plot(o3.reg.regTree.model);text(o3.reg.regTree.model, pretty = 0)

library(CORElearn)
o3.reg.coreReg.model <- CoreModel(O3_max ~ ., data=o3_data_reg.learning, model="regTree", modelTypeReg = 7) 
# 7 is a winner
o3.reg.coreReg.prediction <- predict(o3.reg.coreReg.model, o3_data_reg.validation)
o3_reg_err <- rbind(o3_reg_err, all_errors(o3, o3.reg.coreReg.prediction, mean(o3_data_reg.learning$O3_max)))

modelEval(o3.reg.coreReg.model, o3, o3.reg.coreReg.prediction)



library(rpart)
pm25.reg.regTree.model <- rpart(PM2.5 ~ ., pm25_data_reg.learning,maxdepth = 5, minsplit= 4)
pm25.reg.regTree.prediction <- predict(pm25.reg.regTree.model, pm25_data_reg.validation)
pm25_reg_err <- rbind(pm25_reg_err, all_errors(pm25, pm25.reg.regTree.prediction, mean(pm25_data_reg.learning$PM2.5)))
plot(pm25.reg.regTree.model);text(pm25.reg.regTree.model, pretty = 0)

library(CORElearn)
pm25.reg.coreReg.model <- CoreModel(PM2.5 ~ ., data=pm25_data_reg.learning, model="regTree", modelTypeReg = 7) 
# 7 is a winner
pm25.reg.coreReg.prediction <- predict(pm25.reg.coreReg.model, pm25_data_reg.validation)
pm25_reg_err <- rbind(pm25_reg_err, all_errors(pm25, pm25.reg.coreReg.prediction, mean(pm25_data_reg.learning$PM2.5)))

modelEval(pm25.reg.coreReg.model, pm25, pm25.reg.coreReg.prediction)

# random forest
library(randomForest)

o3.reg.rf.model <- randomForest(O3_max ~ ., o3_data_reg.learning)
o3.reg.rf.prediction <- predict(o3.reg.rf.model, o3_data_reg.validation)
o3_reg_err <- rbind(o3_reg_err, all_errors(o3, o3.reg.rf.prediction, mean(o3_data_reg.learning$O3_max)))


pm25.reg.rf.model <- randomForest(PM2.5 ~ ., pm25_data_reg.learning)
pm25.reg.rf.prediction <- predict(pm25.reg.rf.model, pm25_data_reg.validation)
pm25_reg_err <- rbind(pm25_reg_err, all_errors(pm25, pm25.reg.rf.prediction, mean(pm25_data_reg.learning$PM2.5)))

# svm
library(e1071)

o3.reg.svm.model <- svm(O3_max ~ ., o3_data_reg.learning, kernel="radial", fitted=F)
o3.reg.svm.prediction <- predict(o3.reg.svm.model, o3_data_reg.validation)
o3_reg_err <- rbind(o3_reg_err, all_errors(o3, o3.reg.svm.prediction, mean(o3_data_reg.learning$O3_max)))


pm25.reg.svm.model <- svm(PM2.5 ~ ., pm25_data_reg.learning, kernel="radial", fitted=F)
pm25.reg.svm.prediction <- predict(pm25.reg.svm.model, pm25_data_reg.validation)
pm25_reg_err <- rbind(pm25_reg_err, all_errors(pm25, pm25.reg.svm.prediction, mean(pm25_data_reg.learning$PM2.5)))

# k-nearest neighbor
library(kknn)

o3.reg.knn.model <- kknn(O3_max ~ ., o3_data_reg.learning, o3_data_reg.validation, k = 3)
o3.reg.knn.prediction <- fitted(o3.reg.knn.model)
o3_reg_err <- rbind( o3_reg_err, all_errors(o3, o3.reg.knn.prediction, mean(o3_data_reg.learning$O3_max)))


pm25.reg.knn.model <- kknn(PM2.5 ~ ., pm25_data_reg.learning, pm25_data_reg.validation, k = 3)
pm25.reg.knn.prediction <- fitted(pm25.reg.knn.model)
pm25_reg_err <- rbind(pm25_reg_err, all_errors(pm25, pm25.reg.knn.prediction, mean(pm25_data_reg.learning$PM2.5)))

# neural network
library(nnet)

o3.reg.nn.model <- nnet(O3_max ~ ., o3_data_reg.learning, size = 10, decay = 1e-10, maxit = 10000, linout = T, Hess=T)
o3.reg.nn.prediction <- predict(o3.reg.nn.model, o3_data_reg.validation)
o3_reg_err <- rbind( o3_reg_err,  all_errors(o3, o3.reg.nn.prediction, mean(o3_data_reg.learning$O3_max)))


pm25.reg.nn.model <- nnet(PM2.5 ~ ., pm25_data_reg.learning, size = 25, maxit = 10000, linout = T, Hess=T)
pm25.reg.nn.prediction <- predict(pm25.reg.nn.model, pm25_data_reg.validation)
all_errors(pm25, pm25.reg.nn.prediction, mean(pm25_data_reg.learning$PM2.5))
# pm25_reg_err <- rbind(pm25_reg_err, all_errors(pm25, pm25.reg.nn.prediction, mean(pm25_data_reg.learning$PM2.5)))


rownames(o3_reg_err) <- c("LR", "RT1", "RT2", "RF", "SVM", "kNN", "NNet")
rownames(pm25_reg_err) <- c("LR", "RT1", "RT2", "RF", "SVM", "kNN", "NNet")



# source("wrapperReg.R")
# wrapperReg(o3_data_reg.learning, "O3_max", folds=10)
# wrapperReg(pm25_data_reg.learning, "PM2.5", folds=10)


# some graphs, need to recheck them.
# plot(pollution$TRAJ)
# plot(pollution$SHORT_TRAJ)
# 
# # day’s mean air temperature
# boxplot(pollution$AMP_TMP2M_mean)
# hist(pollution$AMP_TMP2M_mean)
# hist(log(pollution$AMP_TMP2M_mean))
# summary(pollution$AMP_TMP2M_mean)
# 
# # day’s mean relative humidity
# boxplot(pollution$AMP_RH_mean)# hist(pollution$AMP_RH_mean)

# hist(log(pollution$AMP_RH_mean))
# summary(pollution$AMP_RH_mean)
# 
# # day’s mean wind speed
# boxplot(pollution$AMP_PREC_sum)
# hist(pollution$AMP_PREC_sum)
# hist(log(pollution$AMP_PREC_sum))
# summary(pollution$AMP_PREC_sum)
# 
# #  day’s total precipitation
# boxplot(pollution$AMP_WS_mean)
# hist(pollution$AMP_WS_mean)
# hist(log(pollution$AMP_WS_mean))
# summary(pollution$AMP_WS_mean)
# 
# 
# hist(pollution$AMP_PREC_sum[pollution$AMP_PREC_sum > 0])
# 
# hist(pollution$O3_max)
# hist(pollution$PM10)
# hist(pollution$PM2.5)
# 
# length(pollution$AMP_PREC_sum[pollution$AMP_PREC_sum == "NA"])
# 
# plot(pollution$AMP_WS_mean, pollution$AMP_RH_mean) # poln pogodok xD
# plot(pollution$AMP_WS_mean, pollution$AMP_TMP2M_mean)
# plot(pollution$AMP_WS_mean, pollution$PM10)
# plot(pollution$AMP_WS_mean, pollution$PM2.5)
# plot(pollution$AMP_WS_mean, pollution$O3_max)
# plot(pollution$AMP_TMP2M_mean, pollution$AMP_RH_mean) # poln pogodok xD
# 
# plot(pollution$AMP_TMP2M_mean, pollution$AMP_WS_mean)
# 
# plot(pollution$AMP_TMP2M_mean * pollution$AMP_RH_mean, pollution$AMP_TMP2M_mean + pollution$AMP_WS_mean) # ??? good regression - NO, you stupid assfuck
# 
# plot(pollution$AMP_TMP2M_mean * pollution$AMP_RH_mean, pollution$AMP_WS_mean)
# boxplot(pollution$AMP_TMP2M_mean * pollution$AMP_RH_mean)
# plot(pollution$AMP_TMP2M_mean + pollution$AMP_RH_mean, pollution$AMP_TMP2M_mean * pollution$AMP_WS_mean)
# 
# # attribute evaluation
# library(CORElearn)
# sort(attrEval(O3_max ~ ., o3_data, "MDL"), decreasing = TRUE) # ni dobro! learn in test 
