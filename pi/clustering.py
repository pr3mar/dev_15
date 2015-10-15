__author__ = 'pr3mar'

from math import sqrt
from itertools import product
from itertools import combinations
avg = lambda lst: sum(lst)/len(lst)

class Clustering:
    linkages = {"min": min, "max": max, "average": avg}

    def __init__(self, fileName, linkage="average"):
        """ Read data from file. """
        print "Opening ", fileName
        #self.fileName = fileName
        f = open(fileName)
        self.header = f.readline().strip().split("\t")[1:]
        self.data = []
        self.id = []
        for line in f:
            row = line.strip().split("\t")
            self.id.append(row[0])
            self.data.append([None if (x =="?" or not len(x))else float(x)
                              for x in row[1:]])
        self.clusters = [[i] for i in range(len(self.data))]
        self.linkage = self.linkages[linkage]

    def row_distance(self, r1, r2):
        """  Distance between rows with indices r1 and r2. """
        return sqrt(sum((x - y)**2 for x, y in zip(self.data[r1], self.data[r2])
                        if x is not None and y is not None))
    def cluster_distance(self, c1, c2):
        """ Distance between two clusters. """
        # min(self.row_distance(x,y) for x,y in product(c1, c2)) #single linkage
        # max(self.row_distance(x,y) for x,y in product(c1, c2)) #complete linkage
        # avg([self.row_distance(x,y) for x,y in product(c1, c2)]) #average linkage
        self.linkage([self.row_distance(x, y) for x, y in product(c1, c2)])

    def closest_clusters(self):
        """  Return two closest clusters. """
        """r, ime = min(...)"""
        min((self.cluster_distance(*c), c) for c in combinations(self.clusters, 2))


    def run(self):
        """  Perform hierarchical clustering. """
        joining = []
        while len(self.clusters) > 1:
            # naredimo nekaj z self.clusters
            # recimo, klicemo closest_clusters
            # dodamo k joining
            # potem pa:
            #   si zapomnemo katera 2 skupini smo zdruzili (v 1 seznam)
            #   naredimo nov seznam, kjer sta ti dve skupini zdruzini
            # self.clusters postane seznam brez teh dveh posamicnih skupin ampak z novo skupino
            # [x for x in c if x not in pair] + [pair[0] + pair[1]]
            pass


hc = Clustering("dummy.txt")
print hc.row_distance(0, 5)
print hc.cluster_distance([0, 1, 2], [4, 6])
