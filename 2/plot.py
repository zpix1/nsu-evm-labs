#%% 
#!/usr/bin/python3.6
from json import load
import matplotlib
import matplotlib.pyplot as plt

if __name__ == "__main__":
    flags = ['-O0', '-O1', '-O2', '-O3', '-Os', '-Ofast', '-Og']

    data = load(open('out.json', 'r'))

    assert(len(data) == len(flags))

    for i in range(len(data)):
        plt.plot(data[i][0], data[i][1])

    plt.title('Зависимость времени исполнения от различных флагов компиляции')
    plt.legend(flags, loc='upper left')
    plt.xlabel('Взятая часть N')
    plt.ylabel('Время исполнения, сек.')
    plt.xticks(data[0][0] , map(lambda x: f'{x}', data[0][0]))
    # plt.show()
    plt.savefig('out.png')

# %%
