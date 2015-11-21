# read the data
pollution <- read.csv("pollution.txt")
summary(pollution)
str(pollution)
date <- read.table(text = sapply(pollution$DATE, as.character), sep="-", colClasses = "factor", col.names = c("year", "month", "day"))
pollution$DATE <- NULL
pollution$YEAR <- date$year
pollution$MONTH <- date$month
pollution$TRAJ <- as.factor(pollution$TRAJ)
pollution$SHORT_TRAJ <- as.factor(pollution$SHORT_TRAJ)

# discrete
o3_data = pollution[,c(0:8)]
o3_data$O3_max <- cut(pollution$O3_max, c(-Inf, 60, 120, 180, +Inf), labels=c("LOW", "MODERATE", "HIGH", "EXTREME"))
pm10_data = pollution[,c(0:7,9)]
pm10_data$PM10 <- cut(pollution$PM10, c(-Inf, 35, 50, +Inf), labels=c("LOW", "MODERATE", "HIGH"))


plot(pollution$TRAJ)
plot(pollution$SHORT_TRAJ)
boxplot(pollution$AMP_TMP2M_mean)
boxplot(pollution$AMP_RH_mean)
boxplot(pollution$AMP_WS_mean)
hist(pollution$AMP_PREC_sum[pollution$AMP_PREC_sum > 0])

hist(pollution$O3_max)
hist(pollution$PM10)
hist(pollution$PM2.5)

length(pollution$AMP_PREC_sum[pollution$AMP_PREC_sum == "NA"])

plot(pollution$AMP_WS_mean, pollution$AMP_RH_mean) # poln pogodok xD
plot(pollution$AMP_WS_mean, pollution$AMP_TMP2M_mean)
plot(pollution$AMP_WS_mean, pollution$PM10)
plot(pollution$AMP_WS_mean, pollution$PM2.5)
plot(pollution$AMP_WS_mean, pollution$O3_max)
plot(pollution$AMP_TMP2M_mean, pollution$AMP_RH_mean) # poln pogodok xD

plot(pollution$AMP_TMP2M_mean, pollution$AMP_WS_mean)

plot(pollution$AMP_TMP2M_mean * pollution$AMP_RH_mean, pollution$AMP_TMP2M_mean + pollution$AMP_WS_mean) # ??? good regression - NO, you stupid assfuck

plot(pollution$AMP_TMP2M_mean * pollution$AMP_RH_mean, pollution$AMP_WS_mean)
boxplot(pollution$AMP_TMP2M_mean * pollution$AMP_RH_mean)
plot(pollution$AMP_TMP2M_mean + pollution$AMP_RH_mean, pollution$AMP_TMP2M_mean * pollution$AMP_WS_mean)


# ozone discretization
plot(ozone_discrete)
summary(ozone_discrete)
# pm10 discretization
plot(pm10_discrete)
summary(pm10_discrete)

# attribute evaluation
library(CORElearn)
sort(attrEval(O3_max ~ ., o3_data, "RReliefFwithMSE"), decreasing = TRUE)
