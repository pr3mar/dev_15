#######################################################################################################################
#
# PROBLEMS 
#
#######################################################################################################################
#
# Load the Movies dataset using the command:
#
    md <- read.table("movies.txt", sep=",", header=TRUE)
    for (i in 18:24)
      md[,i] <- as.factor(md[,i])
#
# Answer the following questions:
#
# - Are there more movies shorter than 100 min or longer than (or equal to) 100 minutes?
#   (show your answer numerically and graphically) 

    tab <- table(md$length >= 100)
    names(tab) <- c("krajsi", "daljsi")
    barplot(tab)

# - Are there more action comedies or romantic comedies?

    action <- length(md$Actio[md$Action == "1"])
    romance <- length(md$Romance[md$Romance == "1"])
    action > romance

# - Plot a histogram of the ratings for drama movies.
    
    hist(md$rating[md$Drama > 0], xlab = "drama movies", ylab = "frequency", main="ratings of drama movies")
    
# - Is the average rating of dramas higher than the average rating of non-dramas?
#   (show your answer numerically and graphically)
    
    mean(md$Drama)
    
    
# - Plot the number of animated movies being produced every year for the period 1995-2005.
#
# - Is there a clear boundary between short and feature movies (according to their length)?
#
#
#######################################################################################################################
#
# Load the Players dataset using the command:
#
#	players <- read.table("players.txt", sep=",", header = T)
#
# - Plot the proportion of players according to playing positions.
#
# - Compare career rebounds (the "reb" attribute) with respect to playing position.
#
# - Show the distribution of free throw percentages.
#   The percentage is determined by dividing the number of shots made ("ftm") by the total number of shots attempted ("fta").
#
# - Compare career 3-pointers made for the players active between 1990 and 2007, with respect to playing position. 
#
# - How does the average career length of retired players vary from year to year?
#
#######################################################################################################################

