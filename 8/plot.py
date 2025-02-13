from matplotlib import pyplot as plt
import json
from utils import file_size


plt.figure(figsize=(8, 6))

data = json.load(open("res.json"))

plotdata_x = {
    "asc": [],
    "dec": [],
    "ran": []
}

plotdata_y = {
    "asc": [],
    "dec": [],
    "ran": []
}

for i in data:
    plotdata_x[i[0]].append(i[1])
    plotdata_y[i[0]].append(i[3])

plt.plot(plotdata_x["asc"], plotdata_y["asc"], ls="dashed", label="прямой")
plt.plot(plotdata_x["dec"], plotdata_y["dec"], ls="dotted", label="обратный")
plt.plot(plotdata_x["ran"], plotdata_y["ran"], ls="solid", label="случайный")

xticks = []

plt.xscale("log", basex=2)
# plt.yscale("log")

plt.xticks(plotdata_x["asc"], labels=map(file_size, plotdata_x["asc"]))

plt.xlabel("Размер массива")
plt.ylabel("Время чтения элемента, такты")

plt.legend()

plt.savefig('res.png', dpi=300)