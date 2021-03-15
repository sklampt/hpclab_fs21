/* 
    Please include compiler name below (you may also include any other modules you would like to be loaded)

COMPILER= gnu

    Please include All compiler flags and libraries as you want them run. You can simply copy this over from the Makefile's first few lines
 
CC = cc
OPT = -O3
CFLAGS = -Wall -std=gnu99 $(OPT)
MKLROOT = /opt/intel/composer_xe_2013.1.117/mkl
LDLIBS = -lrt -Wl,--start-group $(MKLROOT)/lib/intel64/libmkl_intel_lp64.a $(MKLROOT)/lib/intel64/libmkl_sequential.a $(MKLROOT)/lib/intel64/libmkl_core.a -Wl,--end-group -lpthread -lm

*/

const char* dgemm_desc = "Naive, three-loop dgemm.";

/* This routine performs a dgemm operation
 *  C := C + A * B
 * where A, B, and C are lda-by-lda matrices stored in column-major format.
 * On exit, A and B maintain their input values. */    
void square_dgemm (int n, double* A, double* B, double* C)
{
  // TODO: Implement the blocking optimization
  
  int s = 36;
  for(int ii = 0; ii < n; ii += s){
    for(int jj = 0; jj < n; jj += s){
      for(int kk = 0; kk < n; kk += s){
        for(int i = ii; i < ((ii+s)>n?n:(ii+s)); i++){
          for(int j = jj; j < ((jj+s)>n?n:(jj+s)); j++){
            double cij = C[i+j*n];
            for(int k = kk; k < ((kk+s)>n?n:(kk+s)); k++){
              cij += A[i+k*n] * B[k+j*n];
            }
            C[i+j*n] = cij;
          }
        }
      }
    }
  }
  /*
  // For each row i of A 
  for (int i = 0; i < n; ++i)
    // For each column j of B 
    for (int j = 0; j < n; ++j) 
    {
      // Compute C(i,j) 
      double cij = C[i+j*n];
      for( int k = 0; k < n; k++ )
	      cij += A[i+k*n] * B[k+j*n];
      C[i+j*n] = cij;
    }
  */
}
