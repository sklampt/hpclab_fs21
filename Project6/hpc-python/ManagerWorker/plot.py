from matplotlib import pyplot as plt

processors = [2, 4, 8, 16]

result_100 = [19.737090, 8.608565, 4.127982, 2.665984]
res_100_2 = [100]
res_100_4 = [32, 33, 35]
res_100_8 = [15, 15, 14, 14, 14, 14, 14]
res_100_16 = [7, 7, 7, 6, 6, 6, 6, 7, 6, 7, 6, 7, 6, 8, 8]

result_50 = [20.004633, 8.229506, 4.477439, 3.159313]
res_50_2 = [50]
res_50_4 = [18, 15, 17]
res_50_8 = [7, 7, 8, 7, 7, 7, 7]
res_50_16 = [4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 4, 3, 3, 3, 5]

plt.plot(processors, result_100, label="100 tasks")
plt.plot(processors, result_50, label="50 tasks")
plt.title("Scaling")
plt.xlabel("number of workers")
plt.ylabel("time")
plt.legend()
plt.show()