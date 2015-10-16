__author__ = 'pr3mar'
import csv
import numpy as np
from math import sqrt
from itertools import product
from itertools import combinations

avg = lambda lst: sum(lst) / len(lst)


class HierarchicalClustering:
    linkages = {"min": min, "max": max, "average": avg}

    def printData(self):
        print self.data.shape
        for i in self.data:
            for j in i:
                print j,
            print
    def printClusters(self):
        print
        for x in self.clusters:
            for y in x:
                print self.countries[y]+',',
            print
    def __init__(self, fn, linkage="average"):
        # copy 76:147
        # serbia & montenegro = 38
        # serbia = 37
        # montenegro = 29
        self.linkage = self.linkages[linkage]
        f = open(fn, 'r')
        self.data = [x[16:63] for x in csv.reader(f, delimiter=",", quotechar="\"")]
        self.countries = self.data[0]
        self.data = np.array(self.data[1:])
        self.data[np.where(self.data == "")] = -1
        self.data = self.data.astype(np.float)
        self.data[76:147, 37] = self.data[76:147, 38]
        self.data[76:147, 29] = self.data[76:147, 38]
        self.data = np.delete(self.data, 38, 1)
        del self.countries[38]
        self.clusters = [[i] for i in range(self.data.shape[1])]

    def column_distance(self, vector_1, vector_2):
        # print vector_1, vector_2
        vector = [(x - y) ** 2 for x, y in zip(self.data[:, vector_1], self.data[:, vector_2]) if x >= 0 and y >= 0]
        return sqrt(sum(vector) / len(vector)) if len(vector) > 0 else 0

    def cluster_distance(self, cluster1, cluster2):
        return self.linkage([self.column_distance(x, y) for x, y in product(cluster1, cluster2)])

    def closes_clusters(self):
        return min((self.cluster_distance(*c), c) for c in combinations(self.clusters, 2))

    def run_clustering(self):
        joining = []
        tmp = self.clusters
        while len(self.clusters) > 1:  # and i < 2:
            dist, pair = self.closes_clusters()
            #TODO make lists of tuples!
            tmp = [x for x in tmp if x not in pair] + [[pair[0]] + [pair[1]]]
            joining.append(tmp)
            self.clusters = [x for x in self.clusters if x not in pair] + [pair[0] + pair[1]]
            # self.printClusters()
        for i in  joining:
            print i

# test = HierarchicalClustering("eurovision-final.csv")
test = HierarchicalClustering("eurovision-final.csv")
# print test.column_distance(0, 2)
# print test.cluster_distance([0, 1], [2])
# dist, ret = test.closes_clusters()
# print dist, ret
# print test.countries[ret[0][0]]
# print test.countries[ret[1][0]]
# print len(test.clusters)
# print len(test.countries)
# print test.countries
test.run_clustering()

# print test.countries[37]
# print test.countries[38]
# print test.countries[29]
