#####################################################################################
#
# PROBLEMS
#
# - load the "student" dataset:

    student <- read.table("data/student.txt", sep=",", header=T)

# - discretize the attributes G1, G2, and G3 into five bins:
#   fail[0,9], sufficient[10,11], satisfactory[12,13], good[14,15], excellent[16,20]
    
    for(i in 30:32)
      student[,i] <- cut(student[,i], c(-Inf, 9, 11, 13, 15, 20), labels=c("fail", "sufficient", "satisfactory", "good", "excellent") )
    
    barplot(table(student$G1), xlab="grade", ylab="Number of students", main = "grades math")
    barplot(table(student$G2), xlab="grade", ylab="Number of students", main = "grades math")
    barplot(table(student$G3), xlab="grade", ylab="Number of students", main = "grades math")
    
# - train different models to predict secondary school student performance
#   (the target variable is the "G3" attribute)
    
    nrow(student)
    sel <- sample(1:nrow(student), size=as.integer(nrow(student) * 0.7), replace=F)
    
    learn <- student[sel,]
    test <- student[-sel,]
    
    library(rpart)
    dt <- rpart(G3 ~ ., learn)
    predicted <- predict(dt, test, type="class")
    observed <- test$G3
    tab <- table(observed, predicted)
    
    sum(diag(tab))/sum(tab)
    
    
    
# - evaluete trained models using different strategies
    
    mypredict <- function(object, newdata){predict(object, newdata, type = "class")}
    res <- errorest(G3 ~ ., data=student, model = rpart, predict = mypredict)
    1 - res$error
    
# - compare the results
#
#####################################################################################
#
# - load the "vehicle" dataset:
    
    vehicle <- read.table("data/vehicle.txt", sep=",", header = T)

# - train different models to classify a given silhouette as one of four types 
#   of vehicle (the target variable is the "Class" attribute)
    
    summary(vehicle)
    
# - evaluete trained models using different strategies
    
    
    
# - compare the results
    
    
    
#####################################################################################
