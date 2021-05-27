from mpi4py import MPI
import numpy as np

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

up = (rank+1)%size
do = (rank-1+size)%size

# pickle-based communication
sum1 = rank
send_buffer = rank
recv_buffer = rank
for i in range(size-1):
    comm.send(send_buffer, dest=up)
    recv_buffer = comm.recv(source=do)
    sum1 += recv_buffer
    send_buffer = recv_buffer
print(f"Sum from rank {rank} is {sum1}")

# direct array data communication
sum2 = rank
send_buffer = np.array([rank])
recv_buffer = np.array([rank])
for i in range(size-1):
    req1 = comm.Send([send_buffer, MPI.INT], dest=up, tag=11)
    req2 = comm.Recv([recv_buffer, MPI.INT], source=do, tag=11)
    sum2 += recv_buffer[0]
    send_buffer = recv_buffer
print(f"direct Sum from rank {rank} is {sum2}")