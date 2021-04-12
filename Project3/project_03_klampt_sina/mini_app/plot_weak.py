import matplotlib.pyplot as plt
import pandas as pd
import numpy as np


if __name__ == "__main__":
    data_frame = pd.read_csv("data_weak_2.csv", sep = ",")
    data_vec = data_frame.values

    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    ax1.set_ylabel('time in [s]')
    ax1.set_xlabel('processors in [1]')
    p_values = data_vec[:, 0]
    time = data_vec[:, 2]
    plt.plot(p_values, time, 'g-',label='points per thread = 8192' )
    plt.legend()
    plt.savefig("./plots/" + 'Weak_Scaling_2' + ".png", dpi = 200)
