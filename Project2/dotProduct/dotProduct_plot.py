import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import csv


data = pd.read_csv('./Project2_code_dotProduct_results_all.txt', delimiter=',')

pivot = data.pivot(index=['n', 'p', 't'], columns='name', values='time')
print(pivot)

grouped = pivot.groupby(['n', 'p']).mean()
print(grouped)

# p-time-plot for reduction
grouped['reduction'].unstack(level=0).plot(
    kind='line',
    title='Reduction Method',
    logy=True,
    ylabel="time in sec",
    xlabel="#processors",
)

plt.savefig("perf_scaling_reduction.pdf")

# p-time-plot for critical
grouped['critical'].unstack(level=0).plot(
    kind='line',
    title="Critical Method",
    logy=True,
    ylabel="time in sec",
    xlabel="#processors"
)
plt.savefig("perf_scaling_critical.pdf")

# p-time-plot for serial
grouped['serial'].unstack(level=0).plot(
    kind='line',
    title="Serial Method",
    logy=True,
    ylabel="time in sec"
)
plt.savefig("perf_scaling_serial.pdf")

plt.show()