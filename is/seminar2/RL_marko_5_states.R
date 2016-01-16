source("simulation.R")

getStateDesc <- function(sceneObjects)
{
	state <- c(1, 1, 1, 1, 1)
	names(state) <- c("left", "diagLeft", "front", "diagRight", "right")
	
	#state <- c(1, 1, 1)
	#names(state) <- c("left", "front", "right")
	
	leftedge <- sceneObjects[which(sceneObjects$type == "leftside"), "xtopleft"]
	rightedge <- sceneObjects[which(sceneObjects$type == "rightside"), "xbottomright"]

	sel <- which(sceneObjects$type == "fuel")
	for (i in sel)
	{
		if (isOverlapped(	sceneObjects[1, "xtopleft"], 
                            sceneObjects[1, "ytopleft"] + CARLENGTH,
                            sceneObjects[1, "xbottomright"],
                            sceneObjects[1, "ytopleft"],
                            sceneObjects[i, "xtopleft"], 
                            sceneObjects[i, "ytopleft"],
                            sceneObjects[i, "xbottomright"],
                            sceneObjects[i, "ybottomright"]))
				state["front"] <- 3
	
		if (isOverlapped(	sceneObjects[1, "xtopleft"] - CARWIDTH, 
                            sceneObjects[1, "ytopleft"],
                            sceneObjects[1, "xtopleft"],
                            sceneObjects[1, "ybottomright"],
                            sceneObjects[i, "xtopleft"], 
                            sceneObjects[i, "ytopleft"],
                            sceneObjects[i, "xbottomright"],
                            sceneObjects[i, "ybottomright"]))
				state["left"] <- 3
		
		if (isOverlapped(	sceneObjects[1, "xtopleft"] - CARWIDTH, 
                            sceneObjects[1, "ytopleft"] + CARLENGTH,
                            sceneObjects[1, "xtopleft"],
                            sceneObjects[1, "ytopleft"],
                            sceneObjects[i, "xtopleft"], 
                            sceneObjects[i, "ytopleft"],
                            sceneObjects[i, "xbottomright"],
                            sceneObjects[i, "ybottomright"]))
			state["diagLeft"] <- 3
		
		if (isOverlapped(	sceneObjects[1, "xbottomright"], 
                            sceneObjects[1, "ytopleft"],
                            sceneObjects[1, "xbottomright"] + CARWIDTH,
                            sceneObjects[1, "ybottomright"],
                            sceneObjects[i, "xtopleft"], 
                            sceneObjects[i, "ytopleft"],
                            sceneObjects[i, "xbottomright"],
                            sceneObjects[i, "ybottomright"]))
			state["right"] <- 3
		
		if (isOverlapped(	sceneObjects[1, "xbottomright"], 
							sceneObjects[1, "ytopleft"] + CARLENGTH,
							sceneObjects[1, "xbottomright"] + CARWIDTH,
							sceneObjects[1, "ytopleft"],
							sceneObjects[i, "xtopleft"], 
							sceneObjects[i, "ytopleft"],
							sceneObjects[i, "xbottomright"],
							sceneObjects[i, "ybottomright"]))
			state["diagRight"] <- 3
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

		if (isOverlapped(	sceneObjects[1, "xtopleft"] - CARWIDTH, 
                            sceneObjects[1, "ytopleft"],
                            sceneObjects[1, "xtopleft"],
                            sceneObjects[1, "ybottomright"],
                            sceneObjects[i, "xtopleft"], 
                            sceneObjects[i, "ytopleft"],
                            sceneObjects[i, "xbottomright"],
                            sceneObjects[i, "ybottomright"]))
			state["left"] <- 2
		if (isOverlapped(	sceneObjects[1, "xtopleft"] - CARWIDTH, 
                            sceneObjects[1, "ytopleft"] + CARLENGTH,
                            sceneObjects[1, "xtopleft"],
                            sceneObjects[1, "ytopleft"],
                            sceneObjects[i, "xtopleft"], 
                            sceneObjects[i, "ytopleft"],
                            sceneObjects[i, "xbottomright"],
                            sceneObjects[i, "ybottomright"]))
			state["diagLeft"] <- 2

		if (isOverlapped(	sceneObjects[1, "xbottomright"], 
                            sceneObjects[1, "ytopleft"],
                            sceneObjects[1, "xbottomright"] + CARWIDTH,
                            sceneObjects[1, "ybottomright"],
                            sceneObjects[i, "xtopleft"], 
                            sceneObjects[i, "ytopleft"],
                            sceneObjects[i, "xbottomright"],
                            sceneObjects[i, "ybottomright"]))
			state["right"] <- 2
		if (isOverlapped(	sceneObjects[1, "xbottomright"], 
							sceneObjects[1, "ytopleft"] + CARLENGTH,
							sceneObjects[1, "xbottomright"] + CARWIDTH,
							sceneObjects[1, "ytopleft"],
							sceneObjects[i, "xtopleft"], 
							sceneObjects[i, "ytopleft"],
							sceneObjects[i, "xbottomright"],
							sceneObjects[i, "ybottomright"]))
			state["diagRight"] <- 2
	}
	
	if (abs(leftedge) < 2)
		state["left"] <- 2
	if (rightedge - sceneObjects[1,"xbottomright"] < 2)
		state["right"] <- 2
	
	state
}

#getReward <- function(state, action, hitObjects)
getReward <- function(curState, nextState, action, hitObjects)
{
	# action 1 - nothing
	# action 2 - steer left
	# action 3 - steer right
	# action 4 - speed up
	# action 5 - speed down
	reward <- (-1)
	#cat(hitObjects)
	#cat('action', action, ', ')
	
	if('fuel' %in% hitObjects) {
		reward <- reward + 100000
	}
	
	if('leftside' %in% hitObjects) {
		reward <- reward - 100000
	}
	
	if('rightside' %in% hitObjects) {
		reward <- reward - 100000
	}
	
	if('car' %in% hitObjects) {
		reward <- reward - 100000
	}
	
	
	#nothing
	if(action == 1) {
		##cat('nothing')
		if(curState['front'] == 2) {
			if(curState['diagLeft'] == 2 || curState['diagRight'] == 2) {
				reward <- reward + 250
			} else {
				reward <- reward + 100
			}
		}
	}
	
	#steer left
	if(action == 2) {
		#cat('left')
		if(curState['left'] == 2 || curState['diagRight'] == 2 || nextState['left'] == 2 || nextState['diagLeft'] == 2) {
			reward <- reward + (-10000)
		} else if (nextState['left'] == 3 || curState['diagLeft'] == 3 || curState['left'] == 3 || nextState['diagLeft'] == 3) {
			reward <- reward + 500
		} else if(curState['front'] == 2 && curState['left'] == 1) {
			#if(nextState['diagLeft'] == 1 && nextState['left'] == 1)
			#	reward <- reward + 500
			#else 
				reward <- reward + 500
		}
	}
	
	#steer right
	if(action == 3) {
		#cat('right')
		if(curState['right'] == 2 || curState['diagRight'] == 2 || nextState['right'] == 2 || nextState['diagRight'] == 2) {
			reward <- reward + (-10000)
		} else if (nextState['right'] == 3 || curState['diagRight'] == 3 || curState['right'] == 3 || nextState['diagRight'] == 3) {
			reward <- reward + 500			
		}else if(curState['front'] == 2 && curState['right'] == 1) {
			#if(nextState['diagRight'] == 1 && nextState['right'] == 1)
			#	reward <- reward + 500
			#else 
				reward <- reward + 500
		}
	}
	
	#speed up
	if(action == 4) {
		#cat('speed++')
		if(curState['front'] == 1) {
			#if(nextState['diagLeft'] == 1 || nextState['diagRight'] == 1)
			#	reward <- reward + 500
			#else
				reward <- reward + 400
		} else {
			reward <- reward + (-10000)
		}
	}
	
	#speed down
	if(action == 5) {
		#cat('speed--')
		if(curState['front'] == 2) {
			if(curState['diagLeft'] == 2 || curState['diagRight'] == 2)
				reward <- reward + 500
			else
				reward <- reward + 300
		} else {
			reward <- reward + (-10000)
		}
	}
	#cat(' ', reward, '\n')
	flush.console()
	
	reward
}


