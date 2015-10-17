__author__ = 'pr3mar'

class lab1:
    def __init__(self):
        pass

    def smreka(self, height):
        for i, j  in zip(range(height, 0, -1), range(1, height * 2, 2)):
            print ' ' * i + '*' * j

    def evklid(self, a, b):
        return self.evklid(b, a % b) if b > 0 else a

    def isDevisor(self, number, devisor):
        return (number % devisor) == 0

    def allDevisors(self, number):
        return [i+1 for i in range(number/2) if self.isDevisor(number, i + 1)]

    def popolna(self, limit):
        for i in range(limit):
            if i == sum(self.allDevisors(i)):
                print i,
        print

    def sumljive(self, string):
        return [i for i in string.split(" ") if 'u' in i and 'a' in i]

    def children(self, tree, name):
        return tree[name] if name in tree else []

    def grandchildren(self, tree, name):
        if name not in tree:
            return []
        ret = []
        for x in tree[name]:
            ret += self.children(tree, x)
        return ret

    def successors(self, tree, name):
        if name not in tree:
            return []
        children = tree[name]
        ret = children
        for x in children:
             ret += self.successors(tree, x)
        return ret


tmp = lab1()
tmp.smreka(5)
print tmp.evklid(12345, 54321)
tmp.popolna(1000)
print tmp.sumljive('Muha pa je rekla: "Tale juha se je pa res prilegla, najlepsa huala," in odletela.')
tree = {
    'alice': ['mary', 'tom', 'judy'],
    'bob': ['mary', 'tom', 'judy'],
    'ken': ['suzan'],
    'renee': ['rob', 'bob'],
    'rob': ['jim'],
    'sid': ['rob', 'bob'],
    'tom': ['ken']}
print tmp.children(tree, 'mary')
print tmp.grandchildren(tree, 'renee')
print tmp.successors(tree, 'sid')

