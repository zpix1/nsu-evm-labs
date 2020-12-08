from matplotlib import pyplot as plt
import json

plt.figure(figsize=(8, 6))

data = json.load(open("res.json"))
x = list([a[0] for a in data])
y = list([a[1] for a in data])

plt.plot(x, y)
plt.scatter(x, y)

xticks = []


plt.xticks(x)

plt.xlabel("Число фрагментов")
plt.ylabel("Время чтения элемента, такты")

plt.savefig('res.png', dpi=300)