source("simulation.R")

getStateDesc <- function(sceneObjects)
{
	state <- c(1, 1, 1)
	names(state) <- c("left", "front", "right")
	
	leftedge <- sceneObjects[which(sceneObjects$type == "leftside"), "xtopleft"]
	rightedge <- sceneObjects[which(sceneObjects$type == "rightside"), "xbottomright"]

	if (abs(leftedge) < 5)
		state["left"] <- 2
	if (rightedge - sceneObjects[1,"xbottomright"] < 5)
		state["right"] <- 2

	sel <- which(sceneObjects$type == "fuel")
	for (i in sel)
	{
		if (isOverlapped(sceneObjects[1, "xtopleft"], 
                             sceneObjects[1, "ytopleft"] + CARLENGTH,
                             sceneObjects[1, "xbottomright"],
                             sceneObjects[1, "ytopleft"],
                             sceneObjects[i, "xtopleft"], 
                             sceneObjects[i, "ytopleft"],
                             sceneObjects[i, "xbottomright"],
                             sceneObjects[i, "ybottomright"]))
			state["front"] <- 3

		if (isOverlapped(sceneObjects[1, "xtopleft"] - CARWIDTH, 
                             sceneObjects[1, "ytopleft"],
                             sceneObjects[1, "xtopleft"],
                             sceneObjects[1, "ybottomright"],
                             sceneObjects[i, "xtopleft"], 
                             sceneObjects[i, "ytopleft"],
                             sceneObjects[i, "xbottomright"],
                             sceneObjects[i, "ybottomright"]))
			state["left"] <- 3

		if (isOverlapped(sceneObjects[1, "xbottomright"], 
                             sceneObjects[1, "ytopleft"],
                             sceneObjects[1, "xbottomright"] + CARWIDTH,
                             sceneObjects[1, "ybottomright"],
                             sceneObjects[i, "xtopleft"], 
                             sceneObjects[i, "ytopleft"],
                             sceneObjects[i, "xbottomright"],
                             sceneObjects[i, "ybottomright"]))
			state["right"] <- 3
	}
	
	sel <- which(sceneObjects$type == "car")
	for (i in sel)
	{
		if (isOverlapped(sceneObjects[1, "xtopleft"], 
                             sceneObjects[1, "ytopleft"] + CARLENGTH,
                             sceneObjects[1, "xbottomright"],
                             sceneObjects[1, "ytopleft"],
                             sceneObjects[i, "xtopleft"], 
                             sceneObjects[i, "ytopleft"],
                             sceneObjects[i, "xbottomright"],
                             sceneObjects[i, "ybottomright"]))
			state["front"] <- 2

		if (isOverlapped(sceneObjects[1, "xtopleft"] - CARWIDTH, 
                             sceneObjects[1, "ytopleft"],
                             sceneObjects[1, "xtopleft"],
                             sceneObjects[1, "ybottomright"],
                             sceneObjects[i, "xtopleft"], 
                             sceneObjects[i, "ytopleft"],
                             sceneObjects[i, "xbottomright"],
                             sceneObjects[i, "ybottomright"]))
			state["left"] <- 2

		if (isOverlapped(sceneObjects[1, "xbottomright"], 
                             sceneObjects[1, "ytopleft"],
                             sceneObjects[1, "xbottomright"] + CARWIDTH,
                             sceneObjects[1, "ybottomright"],
                             sceneObjects[i, "xtopleft"], 
                             sceneObjects[i, "ytopleft"],
                             sceneObjects[i, "xbottomright"],
                             sceneObjects[i, "ybottomright"]))
			state["right"] <- 2
	}
	
	state
}

getReward <- function(state, action, hitObjects)
{
	# action 1 - nothing
	# action 2 - steer left
	# action 3 - steer right
	# action 4 - speed up
	# action 5 - speed down
	reward <- -1
	
	cat('action', action, ', ')
	
	if(action == 3) {				#steer right
		cat('right')
		if(state['right'] == 2) {
			reward <- (-100)
		} else if(state['right'] == 3) {
			reward <- 10
		} else {
			reward <- -1
		}
	}
	
	if(action == 2) {				#steer left
		cat('left')
		if(state['left'] == 2) {
			reward <- (-100)
		} else if(state['left'] == 3) {
			reward <- 10
		} else {
			reward <- -1
		}
	}
	
	if(action == 1) {				#nothing
		cat('nothing')
		if (state['front'] == 2 || state['front'] == 3){
			reward <- (-100)
		} else {
			reward <- (-1)
		}
	}
	
	if(action == 4) {				#speed up
		cat('speed++')
		if(state['front'] == 2) {
			reward <- (-100)
		} else if(state['left'] == 2 || state['right'] == 2) {
			reward <- 200
		} else {
			reward <- 10
		}
	}
	
	if(action == 5) {				#speed down
		cat('speed--')
		if(state['front'] == 2) {
			reward <- 10
		} else {
			reward <- (-100)
		}
	}
	cat(' ', reward, '\n')
	reward
}


