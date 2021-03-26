import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cbook as cbook

with open('hdrt.txt') as f:
    lines = f.readlines()
    p = [line.split()[0] for line in lines]
    time_serial = [line.split()[1] for line in lines]
    time_red = [line.split()[2] for line in lines]
    time_critical = [line.split()[3] for line in lines]


plt.subplot(p, str(time_serial), 'g-o')
plt.subplot(p, time_red, 'r-s')
plt.subplot(p, time_critical, 'b--')

plt.show()