x = int(input("Vnesi stevilko: "))

# ogrevanje
for i in range(1, x/2 + 1):
    if x % i == 0:
        print i

# obvezna naloga
suma = 0
for i in range(1, x/2 + 1):
    if x % i == 0:
        suma += i
if suma == x:
    print True
else:
    print False


# dodatna naloga
x = 1
stevec = 0
while stevec < 4:
    suma = 0
    for i in range(1, x/2 + 1):
        if x % i == 0:
            suma += i
    if suma == x:
        stevec += 1
        print x,
    x += 1
