/****************************************************************
 *                                                              *
 * This file has been written as a sample solution to an        *
 * exercise in a course given at the CSCS-USI Summer School.    *
 * It is made freely available with the understanding that      *
 * every copy of this file must include this header and that    *
 * CSCS/USI take no responsibility for the use of the enclosed  *
 * teaching material.                                           *
 *                                                              *
 * Purpose: : Parallel matrix-vector multiplication and the     *
 *            and power method                                  *
 *                                                              *
 * Contents: C-Source                                           *
 *                                                              *
 ****************************************************************/


#include <stdio.h>
#include <mpi.h>
#include <math.h>
#include <stdlib.h>

#include "hpc-power.h"

#define MAX_ITERS 1000

double norm(double* vec, int N);
void matVec(double* A, double* x, double* y, int N);
double powerMethod(double* A, int N, int max_iters);


void generateMatrix(double* A, int N){
    int size, rank;
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    for(int i = 0; i < N / size; ++i){
        for(int j = 0; j < N; ++j){
            if(i == j){
                A[i*N + j] = 1.;
            }
            if(abs(i-j) == 1){
                A[i*N + j] = 0.;
            }
        }
    }
}

double powerMethod(double* A, int N, int maxIter){
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Status status; 
    MPI_Request request;
    double *x = (double*)calloc(N, sizeof(double));
    if(rank == 0){
        for(int i = 0; i < N; i++){
            x[i] = (double) (rand()%10) / 100;
        }
    }

    for(int i = 0; i < maxIter; i++){
        if(rank == 0){
            double l2 = norm(x, N);
            for(int k = 0; k < N; k++){
                x[k] /= l2;
            }
        }
        double *iter = (double*)calloc(N, sizeof(double));
        matVec(A, x, iter, N);
        if(rank == 0){
            for(int k = 0; k < N; ++k){
                x[k] = iter[k];
            }
        }
    }
    return norm(x,N);
}

double norm(double* vec, int N){
    double res = 0.;

    for(int i = 0; i < N; ++i){
        res += vec[i] * vec[i];
    }

    return sqrt(res);
}

void matVec(double* A, double* x, double* y, int N){
    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Bcast(x, N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    double* B = (double*)calloc(N/size, sizeof(double));
    for(int i = 0; i < N/size; i++){
        for(int j = 0; j < N; j++){
            B[i] += A[i*N + j] * x[j];
        }
    }

    // find sol
    MPI_Gather(B, N/size, MPI_DOUBLE, y, N/size, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    free(B);
}


int main (int argc, char *argv[]){
    int K_input = argc > 1 ? atoi(argv[1]) : 1000;
    int N_input = argc > 2 ? atoi(argv[2]) : 1<<12;

    int my_rank, size;
    int snd_buf, rcv_buf;
    int right, left;
    int sum, i;

    MPI_Status  status;
    MPI_Request request;


    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if(my_rank == 0){
        printf("Ki   = %d\n", K_input);
        printf("Ni   = %d\n", N_input);
    }

    /* This subproject is about to write a parallel program to
       multiply a matrix A by a vector x, and to use this routine in
       an implementation of the power method to find the absolute
       value of the largest eigenvalue of the matrix. Your code will
       call routines that we supply to generate matrices, record
       timings, and validate the answer.
    */

    int N = 1<<12;
    int numrows = N / size;
    double* A = (double*)calloc(N*numrows, sizeof(double)); 
    generateMatrix(A, N);
   
    double time_start = hpc_timer();
    double res = powerMethod(A, N, MAX_ITERS);
    double time_end = time_start - hpc_timer();
    
    if(my_rank == 0){
        printf("size = %i\n", size);
        printf("N    = %i\n", N);
        printf("time = %.4f\n", time_end);
    }
        
    free(A);

    MPI_Finalize();
    return 0;
}
