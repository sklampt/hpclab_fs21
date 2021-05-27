from mpi4py import MPI
import numpy as np

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()
dims = [0, 0]
dims = MPI.Compute_dims(size, dims)
periods = [True, True]
comm_cart = comm.Create_cart(dims, periods)
coords = comm_cart.Get_coords(rank)
west, east = comm_cart.Shift(0, 1)
north, south = comm_cart.Shift(1, 1)

req1 = comm_cart.irecv(source=south, tag=11)
req2 = comm_cart.isend(rank, dest=north, tag=11)

req3 = comm_cart.irecv(source=north, tag=11)
req4 = comm_cart.isend(rank, dest=south, tag=11)

req5 = comm_cart.irecv(source=east, tag=11)
req6 = comm_cart.isend(rank, dest=west, tag=11)

req7 = comm_cart.irecv(source=west, tag=11)
req8 = comm_cart.isend(rank, dest=east, tag=11)

rank_s = req1.wait()
req2.wait()

rank_n = req3.wait()
req4.wait()

rank_e = req5.wait()
req6.wait()

rank_w = req7.wait()
req8.wait()

if south == rank_s:
    print("south correct")

if north == rank_n:
    print("north correct")

if east == rank_e:
    print("east correct")

if west == rank_w:
    print("west correct")