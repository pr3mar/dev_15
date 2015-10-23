__author__ = 'pr3mar'
from itertools import product

class RobotRescue:

    def __init__(self, grid, robot, wounded):
        # 0 - empty space
        # 1 - obstacle
        self.grid = grid
        self.robot = robot
        self.wounded = wounded

    def solved(self):
        return self.robot == self.wounded

    def generate_moves(self):
        # self.moves = [([i, j], 1) for i, j in product([-1, 0, 1], [-1, 0, 1])
        #                 if grid[self.robot[0] + i][self.robot[1] + j] == 0]
        self.moves = []
        for i, j in product([-1,0,1], [-1,0,1]):
            if i == 0 and j == 0: continue
            tmpX, tmpY = self.robot[0] + i, self.robot[1] + j
            if tmpX < 0 or tmpY < 0 or tmpX >= grid.__len__() or tmpY >= grid.__len__(): continue
            if grid[tmpX][tmpY] == 0: self.moves.append(([i, j], 1))

grid = [
        [0, 0, 0, 0, 0],
        [1, 0, 1, 1, 1],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0]]

rr = RobotRescue(grid, [2, 3], [0, 3])
print rr.solved()
rr.generate_moves()
print rr.moves