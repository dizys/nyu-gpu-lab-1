#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <cuda.h>

#define BLOCK_NUM 8
#define BLOCK_SIZE 500

#define RANGE 19.87

/*** Declaration of the kernel function below this line ***/

__global__ void kernel(float *result);

/**** end of the kernel declaration ***/

int main(int argc, char *argv[])
{
  int i;                          // loop index
  float *result;                  // The arrays that will be processed in the host.
  float *resultd;                 // The arrays that will be processed in the device.
  struct timespec start, end;     // to meaure the time taken by a specific part of code
  int n = BLOCK_NUM * BLOCK_SIZE; // size of the array

  // Allocating the arrays in the host

  if (!(resultd = (float *)malloc(n * sizeof(float))))
  {
    printf("Error allocating array resultd\n");
    exit(1);
  }

  // Fill out the arrays with random numbers between 0 and RANGE;
  srand((unsigned int)time(NULL));
  for (i = 0; i < n; i++)
  {
    result[i] = 0.0;
  }

  /******************  The start GPU part: Do not modify anything in main() above this line  ************/
  // The GPU part

  // Allocate the arrays in the device
  cudaMalloc((void **)&resultd, n * sizeof(float));

  // Copy the arrays from the host to the device
  cudaMemcpy(resultd, result, n * sizeof(float), cudaMemcpyHostToDevice);

  clock_gettime(CLOCK_REALTIME, &start);

  // Call the kernel function
  dim3 grid_size(BLOCK_NUM, 1, 1);
  dim3 block_size(BLOCK_SIZE, 1, 1);
  kernel<<<grid_size, block_size>>>(resultd);

  // Force host to wait on the completion of the kernel
  cudaDeviceSynchronize();

  clock_gettime(CLOCK_REALTIME, &end);

  // Copy the result from the device to the host
  cudaMemcpy(result, resultd, n * sizeof(float), cudaMemcpyDeviceToHost);

  // Free the memory allocated in the device
  cudaFree(resultd);

  printf("Total time taken by the GPU part = %lf\n", (double)(end.tv_sec - start.tv_sec) + (double)(end.tv_nsec - start.tv_nsec) / 1000000000);
  /******************  The end of the GPU part: Do not modify anything in main() below this line  ************/

  // Checking the correctness of the GPU part
  for (i = 0; i < n; i++)
    printf("Element %d: %f", i, result[i]);

  // Free the arrays in the host
  free(result);

  return 0;
}

/**** Write the kernel itself below this line *****/

__global__ void kernel(float *result)
{
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  int sharedMemeorySize = blockIdx.x % 32;
  __shared__ float sharedMemory[sharedMemeorySize];
  sharedMemory[threadIdx.x % sharedMemeorySize] += 1;

  __syncthreads();

  result[i] = sharedMemory[threadIdx.x % sharedMemeorySize];
}
