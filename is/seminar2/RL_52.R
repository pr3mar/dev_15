source("simulation.R")

getStateDesc <- function(sceneObjects)
{
	state <- c(1, 1, 1, 1, 1)
	names(state) <- c("left", "diagLeft", "front", "diagRight", "right")
	
	#state <- c(1, 1, 1)
	#names(state) <- c("left", "front", "right")
	
	leftedge <- sceneObjects[which(sceneObjects$type == "leftside"), "xtopleft"]
	rightedge <- sceneObjects[which(sceneObjects$type == "rightside"), "xbottomright"]

	# sel <- which(sceneObjects$type == "fuel")
	# for (i in sel)
	# {
		# if (isOverlapped(	sceneObjects[1, "xtopleft"], 
                            # sceneObjects[1, "ytopleft"] + CARLENGTH, #* 2,
                            # sceneObjects[1, "xbottomright"],
                            # sceneObjects[1, "ytopleft"],
                            # sceneObjects[i, "xtopleft"], 
                            # sceneObjects[i, "ytopleft"],
                            # sceneObjects[i, "xbottomright"],
                            # sceneObjects[i, "ybottomright"]))
				# state["front"] <- 3
	
		# if (isOverlapped(	sceneObjects[1, "xtopleft"] - CARWIDTH ,#* 2, 
                            # sceneObjects[1, "ytopleft"],
                            # sceneObjects[1, "xtopleft"],
                            # sceneObjects[1, "ybottomright"],
                            # sceneObjects[i, "xtopleft"], 
                            # sceneObjects[i, "ytopleft"],
                            # sceneObjects[i, "xbottomright"],
                            # sceneObjects[i, "ybottomright"]))
				# state["left"] <- 3
		
		# if (isOverlapped(	sceneObjects[1, "xtopleft"] - CARWIDTH ,#* 2, 
                            # sceneObjects[1, "ytopleft"] + CARLENGTH ,#* 2,
                            # sceneObjects[1, "xtopleft"],
                            # sceneObjects[1, "ytopleft"],
                            # sceneObjects[i, "xtopleft"], 
                            # sceneObjects[i, "ytopleft"],
                            # sceneObjects[i, "xbottomright"],
                            # sceneObjects[i, "ybottomright"]))
			# state["diagLeft"] <- 3
		
		# if (isOverlapped(	sceneObjects[1, "xbottomright"], 
                            # sceneObjects[1, "ytopleft"],
                            # sceneObjects[1, "xbottomright"] + CARWIDTH ,#* 2,
                            # sceneObjects[1, "ybottomright"],
                            # sceneObjects[i, "xtopleft"], 
                            # sceneObjects[i, "ytopleft"],
                            # sceneObjects[i, "xbottomright"],
                            # sceneObjects[i, "ybottomright"]))
			# state["right"] <- 3
		
		# if (isOverlapped(	sceneObjects[1, "xbottomright"], 
							# sceneObjects[1, "ytopleft"] + CARLENGTH ,#* 2,
							# sceneObjects[1, "xbottomright"] + CARWIDTH ,#* 2,
							# sceneObjects[1, "ytopleft"],
							# sceneObjects[i, "xtopleft"], 
							# sceneObjects[i, "ytopleft"],
							# sceneObjects[i, "xbottomright"],
							# sceneObjects[i, "ybottomright"]))
			# state["diagRight"] <- 3
	# }	
	sel <- which(sceneObjects$type == "car")
	for (i in sel)
	{
		if (isOverlapped(sceneObjects[1, "xtopleft"], 
                             sceneObjects[1, "ytopleft"] + CARLENGTH ,#* 2,
                             sceneObjects[1, "xbottomright"],
                             sceneObjects[1, "ytopleft"],
                             sceneObjects[i, "xtopleft"], 
                             sceneObjects[i, "ytopleft"],
                             sceneObjects[i, "xbottomright"],
                             sceneObjects[i, "ybottomright"]))
			state["front"] <- 2

		if (isOverlapped(	sceneObjects[1, "xtopleft"] - CARWIDTH ,#* 2, 
                            sceneObjects[1, "ytopleft"],
                            sceneObjects[1, "xtopleft"],
                            sceneObjects[1, "ybottomright"],
                            sceneObjects[i, "xtopleft"], 
                            sceneObjects[i, "ytopleft"],
                            sceneObjects[i, "xbottomright"],
                            sceneObjects[i, "ybottomright"]))
			state["left"] <- 2
		if (isOverlapped(	sceneObjects[1, "xtopleft"] - CARWIDTH ,#* 2, 
                            sceneObjects[1, "ytopleft"] + CARLENGTH ,#* 2,
                            sceneObjects[1, "xtopleft"],
                            sceneObjects[1, "ytopleft"],
                            sceneObjects[i, "xtopleft"], 
                            sceneObjects[i, "ytopleft"],
                            sceneObjects[i, "xbottomright"],
                            sceneObjects[i, "ybottomright"]))
			state["diagLeft"] <- 2

		if (isOverlapped(	sceneObjects[1, "xbottomright"], 
                            sceneObjects[1, "ytopleft"],
                            sceneObjects[1, "xbottomright"] + CARWIDTH ,#* 2,
                            sceneObjects[1, "ybottomright"],
                            sceneObjects[i, "xtopleft"], 
                            sceneObjects[i, "ytopleft"],
                            sceneObjects[i, "xbottomright"],
                            sceneObjects[i, "ybottomright"]))
			state["right"] <- 2
		if (isOverlapped(	sceneObjects[1, "xbottomright"], 
							sceneObjects[1, "ytopleft"] + CARLENGTH ,#* 2,
							sceneObjects[1, "xbottomright"] + CARWIDTH ,#* 2,
							sceneObjects[1, "ytopleft"],
							sceneObjects[i, "xtopleft"], 
							sceneObjects[i, "ytopleft"],
							sceneObjects[i, "xbottomright"],
							sceneObjects[i, "ybottomright"]))
			state["diagRight"] <- 2
	}
	
	if (abs(leftedge) < 5)
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
	
	if('leftside' %in% hitObjects || 'rightside' %in% hitObjects || 'car' %in% hitObjects) {
		reward <- reward - 1000000
	}
	
	# nothing
	if(action == 1) {
		if(curState['front'] == 2) {
			reward <- reward + (10)
			if (curState['diagLeft'] == 2 && curState['diagRight'] == 2 && curState['right'] == 2 && curState['left'] == 2) {
				reward <- reward + (100)
			}
		} else {
			reward <- reward + (-10000)
		}
	}
	# left
	if(action == 2) {
		if(curState['front'] == 2) {
			reward <- reward + 15
			if(curState['diagRight'] == 2 && curState['right'] == 2){# || curState['right'] == 2) {
				reward <- reward + 110
			}
		} else {
			reward <- reward + (-10000)
		}
	}
	# right
	if(action == 3) {
		if(curState['front'] == 2) {
			reward <- reward + 15
			if(curState['diagLeft'] == 2 && curState['left'] == 2){# || curState['left'] == 2) {
				reward <- reward + 110
			}
		} else {
			reward <- reward + (-10000)
		}
	}
	# speed++
	if(action == 4) {
		if(curState['front'] == 1) {
			reward <- reward + 15
			
			if(curState['diagLeft'] == 1 && curState['diagRight'] == 1) {
				reward <- reward + 10
			}
			
			if (curState['diagLeft'] == 1 && curState['diagRight'] == 1 && curState['right'] == 1 && curState['left'] == 1) {
				reward <- reward + (100)
			}
		} else {
			reward <- reward + (-1000)
		}
	}
	# speed--
	if(action == 5) {
		if(curState['front'] == 2) {
			reward <- reward + 50
			if (curState['diagLeft'] == 2 && curState['diagRight'] == 2 && curState['right'] == 2 && curState['left'] == 2){
				reward <- reward + (100)
			}
		} else {
			reward <- reward + (-1000)
		}
	}
	
	reward
}


