__author__ = 'pr3mar'
#input = 15 7 9 14 -7 12

import sys
import math

# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

n = 2 # the number of temperatures to analyse
temps = "-10 -10" # the n temperatures expressed as integers ranging from -273 to 5526

# Write an action using print
# To debug: print >> sys.stderr, "Debug messages..."
max = 5527
if n >= 2:
    temps = [int(i) for i in temps.split(" ")]
elif n == 1:
    print temps
else:
    print 0
    sys.exit(0)
index = -1
for i in range(0, n):
    if abs(temps[i]) <= abs(max):
        # print >> sys.stderr, temps[i], max
        if abs(temps[i]) == abs(temps[index]) and index > -1:
            if temps[i] > 0:
                max = temps[i]
                index = i
        else:
            max = temps[i]
            index = i

print max