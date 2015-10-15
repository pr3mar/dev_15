__author__ = 'pr3mar'
import csv
import numpy as np

f = open('eurovision-final.csv', 'r')
w = len(f.readlines()) - 1
f = open('eurovision-final.csv', 'r')
dict = csv.DictReader(f)
fieldnames = [x.strip() for x in f.readline().strip().split(",") if x]
countries = fieldnames[16:]
data = np.zeros((w, len(countries)))
dict.fieldnames = fieldnames

for row, i in zip(dict, range(w)):
    for country, j in zip(countries, range(len(countries))):
        if row[country]:
            data[i, j] = float(row[country])
        else:
            data[i, j] = -1
data = data.T

print data
