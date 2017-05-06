#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>

void addArray(int* a, int size, int* res)
{
	int i = 0;
	for (i = 1; i < size; i++)
	{
		a[0] += a[i];
	}
	
	*res = a[0];
}

__global__ void kernel(int* a, int size, int* res)
{
	int idx= blockDim.x*blockIdx.x + threadIdx.x;

	for (int i = 1; i <= size / 2; i *= 2)
	{
		if (idx % (2 * i) == 0) {
			printf("BEFORE [Thread %d]: %d\n", idx, a[idx]);
			a[idx] += a[idx + i];
			printf("AFTER [Thread %d]: %d\n", idx, a[idx]);
		}
		else
		{
			printf("[Thread %d] returning\n", idx);
			return;
		}
		__syncthreads();
	}         

	*res = a[idx];
}

int main()
{
	int N = 8;
	int *h_arr, *d_arr, *h_res, *d_res;
	cudaEvent_t start, stop;
	float time;


	h_arr = (int*)malloc(N * sizeof(int));
	h_res = (int*)malloc(sizeof(int));
	cudaMalloc(&d_arr, N*sizeof(int));
	cudaMalloc(&d_res, sizeof(int));

	for (int i = 0; i < N; i++)
	{
		h_arr[i] = i;
		printf("[%d]", i);
	}

	cudaMemcpy(d_arr, h_arr, N * sizeof(int), cudaMemcpyHostToDevice);

	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	cudaEventRecord(start, 0);

	kernel<<<1, 8>>>(d_arr, N, d_res);

	cudaMemcpy(h_res, d_res, sizeof(int), cudaMemcpyDeviceToHost);

	//addArray(h_arr, 8, h_res);

	cudaEventRecord(stop, 0);

	cudaEventSynchronize(stop);

	cudaEventElapsedTime(&time, start, stop);

	printf("Result: %d, Time: %f", *h_res, time);

	cudaEventDestroy(start);
	cudaEventDestroy(stop);

	getchar();

	return 0;
}
