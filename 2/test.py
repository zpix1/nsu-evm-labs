from subprocess import check_output
from shlex import split
from json import loads, dumps
from os.path import getsize
import time

def get_time(flag, n):
    c_command = split(f'/usr/local/Cellar/gcc/9.2.0_1/bin/gcc-9 {flag} main.c -o main.out')
    start_time = time.time()
    check_output(c_command)
    end_time = time.time()
    r_command = split(f'./main.out {n}')
    out = loads(check_output(r_command).decode())

    return {'ctime': end_time - start_time, 
            'rtime': out['time'], 
            'size': getsize('main.out'), 
            'md5': check_output(split('md5 main.out')).decode().strip()}

# p = plt.plot()

n = 50000000
data = []

for flag in ['-O0', '-O1', '-O2', '-O3', '-Os', '-Ofast', '-Og']:
    xv = []
    yv = []
    cv = []
    for k in [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75]:
        print(k, flag)
        t = get_time(flag, n * k)
        xv.append(k)
        yv.append(t['rtime'])
        cv.append(t['ctime'])
        print(t)
    data.append([xv, yv, cv])
    # break
print(data)
with open('out.json', 'w') as f:
    f.write(dumps(data))
# plt.show()