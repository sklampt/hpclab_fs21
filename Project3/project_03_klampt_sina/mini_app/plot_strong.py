import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

def plot(dim, p_values, time, title):

    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    ax1.set_ylabel('time in [s]')
    ax1.set_xlabel('processors in [1]')

    plt.plot(p_values, time,'b-')
    #plt.plot(p_values, time_critical, 'b-')
    #plt.plot(p_values, time_seq,'r-')

    plt.title(title + " for N = " + str(dim))
    #plt.legend(["reduction", "critical", "seq"]);

    plt.savefig("./plots/" + title + "_dim_" + str(dim) + ".png", dpi = 200)

def plot2(N, p_values, time_red, time_critical, title):

    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    ax1.set_ylabel('Speedup in [1]')
    ax1.set_xlabel('processors in [1]')

    plt.plot(p_values, time_red,'g-')
    plt.plot(p_values, time_critical, 'b-')

    plt.title(title + " for N = " + str(N))
    plt.legend(["reduction", "critical", "seq"]);

    plt.savefig("./plots/" + title + "_N_" + str(N) + ".png", dpi = 200)

if __name__ == "__main__":
    data_frame = pd.read_csv("data_strong.csv", sep = ",")
    data_vec = data_frame.values
    #print(data_vec)

    dim_values = [64, 128, 256, 512, 1024]

    #colors = ['red', 'black', 'yellow', 'green', 'blue']
    for i in dim_values:
        fig = plt.figure()
        ax1 = fig.add_subplot(111)
        ax1.set_ylabel('time in [s]')
        ax1.set_xlabel('processors in [1]')
        N_data = np.array(data_vec[np.where(data_vec[:, 1] == i), :])[0]
        p_values = N_data[:, 0]
        time = N_data[:, 2]
        plt.plot(p_values, time, 'g-',label='dim =' + str(i))
        plt.legend()
        plt.savefig("./plots/" + 'Strong_Scaling_'+ str(i) + ".png", dpi = 200)
