//#include "cuda_runtime.h"
//#include "device_launch_parameters.h"
//#include <stdio.h>
//#include <stdlib.h>
//#include <fstream>
//#include <string>
//#include <sstream>
//
//__global__ void checkCorrectness(int data[9][9], int* d_number_presence)
//{
//	extern __shared__ int number_presence[];
//	int idx = blockDim.y*blockIdx.y + threadIdx.y;
//	int idy = blockDim.x*blockIdx.x + threadIdx.x;
//	int index_1, index_2, index_3;
//	int k = 81;
//
//	//printf("[Thread pos: %d | %d, val: %d]\n", idx, idy, data[idx][idy]);
//
//	number_presence[idx * 9 + idy] = 0;
//	number_presence[k + idx * 9 + idy] = 0;
//	number_presence[(2*k) + (idx * 9 + idy)] = 0;
//
//	index_1 = idx * 9 + data[idx][idy] - 1;
//	index_2 = k + idy * 9 + data[idx][idy] - 1;
//	index_3 = (2 * k) + ((idx / 3) * 27) + ((idy / 3) * 9) + data[idx][idy] - 1;
//
//	printf("[idx: %d, idy: %d | val: %d | %d, %d, %d]\n", idx, idy, data[idx][idy], index_1, index_2 - 81 , index_3 - 162);
//	//printf("%d, %d, %d\n", index_1, index_2 - 81, index_3 - 162);
//	
//	__syncthreads();
//
//	if (data[idx][idy] > 0)
//	{
//		number_presence[idx * 9 + data[idx][idy] - 1] = 1; //informs, is number in data[idx][idy] - 1 is present in row idx
//		number_presence[k + (idy * 9 + data[idx][idy] - 1)] = 1; //informs, is number in data[idx][idy] - 1 is present in column idy
//		number_presence[(2 * k) + ((idx / 3) * 27) + ((idy / 3) * 9) + data[idx][idy] - 1] = 1; //informs, that number which is in data[idx][idy] - 1 is present in proper 'quarter'
//	}
//
//	__syncthreads();
//
//	d_number_presence[idx * 9 + idy] = number_presence[idx * 9 + idy];
//	d_number_presence[k + idx * 9 + idy] = number_presence[k + idx * 9 + idy];
//	d_number_presence[(2 * k) + (idx * 9 + idy)] = number_presence[(2 * k) + (idx * 9 + idy)];
//
//
//	//number_presence[idx][data[idx][idy] - 1] = (data[idx][idy] > 0) ? 1 : 0;
//
//	//__syncthreads();
//
//	//number_presence[9 + idy][data[idx][idy] - 1] = (data[idx][idy] > 0) ? 1 : 0;
//
//	//__syncthreads();
//
//	//d_number_presence[idx][data[idx][idy] - 1] = number_presence[idx][data[idx][idy] - 1];
//	//d_number_presence[9 + idy][data[idx][idy] - 1] = number_presence[9 + idy][data[idx][idy] - 1];
//
//	//__syncthreads();
//}
//
//__global__ void addArray(int* a, int size, int* res)
//{
//	int idx = blockDim.x*blockIdx.x + threadIdx.x;
//
//	for (int i = 1; i <= size / 2; i *= 2)
//	{
//		if (idx % (2 * i) == 0) {
//			printf("BEFORE [Thread %d]: %d\n", idx, a[idx]);
//			a[idx] += a[idx + i];
//			printf("AFTER [Thread %d]: %d\n", idx, a[idx]);
//		}
//		else
//		{
//			printf("[Thread %d] returning\n", idx);
//			return;
//		}
//		__syncthreads();
//	}
//
//	*res = a[idx];
//}
//
//void setValues(int** h_sudoku)
//{
//	h_sudoku[0][0] = 2;
//	h_sudoku[0][1] = 0;
//	h_sudoku[0][2] = 0;
//	h_sudoku[0][3] = 8;
//	h_sudoku[0][4] = 0;
//	h_sudoku[0][5] = 4;
//	h_sudoku[0][6] = 0;
//	h_sudoku[0][7] = 0;
//	h_sudoku[0][8] = 6;
//
//	h_sudoku[1][0] = 0;
//	h_sudoku[1][1] = 0;
//	h_sudoku[1][2] = 6;
//	h_sudoku[1][3] = 0;
//	h_sudoku[1][4] = 0;
//	h_sudoku[1][5] = 0;
//	h_sudoku[1][6] = 5;
//	h_sudoku[1][7] = 0;
//	h_sudoku[1][8] = 0;
//
//	h_sudoku[2][0] = 0;
//	h_sudoku[2][1] = 7;
//	h_sudoku[2][2] = 4;
//	h_sudoku[2][3] = 0;
//	h_sudoku[2][4] = 0;
//	h_sudoku[2][5] = 0;
//	h_sudoku[2][6] = 9;
//	h_sudoku[2][7] = 2;
//	h_sudoku[2][8] = 0;
//
//	h_sudoku[3][0] = 3;
//	h_sudoku[3][1] = 0;
//	h_sudoku[3][2] = 0;
//	h_sudoku[3][3] = 0;
//	h_sudoku[3][4] = 4;
//	h_sudoku[3][5] = 0;
//	h_sudoku[3][6] = 0;
//	h_sudoku[3][7] = 0;
//	h_sudoku[3][8] = 7;
//
//	h_sudoku[4][0] = 0;
//	h_sudoku[4][1] = 0;
//	h_sudoku[4][2] = 0;
//	h_sudoku[4][3] = 3;
//	h_sudoku[4][4] = 0;
//	h_sudoku[4][5] = 5;
//	h_sudoku[4][6] = 0;
//	h_sudoku[4][7] = 0;
//	h_sudoku[4][8] = 0;
//
//	h_sudoku[5][0] = 4;
//	h_sudoku[5][1] = 0;
//	h_sudoku[5][2] = 0;
//	h_sudoku[5][3] = 0;
//	h_sudoku[5][4] = 6;
//	h_sudoku[5][5] = 0;
//	h_sudoku[5][6] = 0;
//	h_sudoku[5][7] = 0;
//	h_sudoku[5][8] = 9;
//
//	h_sudoku[6][0] = 0;
//	h_sudoku[6][1] = 1;
//	h_sudoku[6][2] = 9;
//	h_sudoku[6][3] = 0;
//	h_sudoku[6][4] = 0;
//	h_sudoku[6][5] = 0;
//	h_sudoku[6][6] = 7;
//	h_sudoku[6][7] = 4;
//	h_sudoku[6][8] = 0;
//
//	h_sudoku[7][0] = 0;
//	h_sudoku[7][1] = 0;
//	h_sudoku[7][2] = 8;
//	h_sudoku[7][3] = 0;
//	h_sudoku[7][4] = 0;
//	h_sudoku[7][5] = 0;
//	h_sudoku[7][6] = 2;
//	h_sudoku[7][7] = 0;
//	h_sudoku[7][8] = 0;
//
//	h_sudoku[8][0] = 5;
//	h_sudoku[8][1] = 0;
//	h_sudoku[8][2] = 0;
//	h_sudoku[8][3] = 6;
//	h_sudoku[8][4] = 0;
//	h_sudoku[8][5] = 8;
//	h_sudoku[8][6] = 0;
//	h_sudoku[8][7] = 0;
//	h_sudoku[8][8] = 1;
//}
//
//int** readSudokuArray(char* filename)
//{
//	int** h_sudoku = new int*[9];
//
//	for (int i = 0; i < 9; i++) {
//		h_sudoku[i] = new int[9];
//	}
//
//	//printf("SUDOKU FILENAME: %s\n", filename);
//	std::ifstream sudoku_file(filename);
//
//	int a0, a1, a2, a3, a4, a5, a6, a7, a8;
//	int i = 0;
//
//	while (sudoku_file >> a0 >> a1 >> a2 >> a3 >> a4 >> a5 >> a6 >> a7 >> a8)
//	{
//		h_sudoku[i][0] = a0;
//		h_sudoku[i][1] = a1;
//		h_sudoku[i][2] = a2;
//		h_sudoku[i][3] = a3;
//		h_sudoku[i][4] = a4;
//		h_sudoku[i][5] = a5;
//		h_sudoku[i][6] = a6;
//		h_sudoku[i][7] = a7;
//		h_sudoku[i][8] = a8;
//		i++;
//	}
//
//	return h_sudoku;
//}
//
//void printArray(int** h_sudoku, int N, int M)
//{
//	for (int i = 0; i < N; i++)
//	{
//		for (int j = 0; j < M; j++)
//			printf("%d |", h_sudoku[i][j]);
//		printf("\n");
//
//		for (int j = 0; j < N; j++)
//			printf("- |");
//		printf("\n");
//	}
//}
//
//void printOneDimArray(int* arr, int N, int M)
//{
//	for (int i = 0; i < N; i++)
//	{
//		for (int j = 0; j < M; j++)
//		{
//			printf("%d|", arr[i*N + j]);
//		}
//		printf("\n");
//		if (i != 0 && i % 9 == 0)
//			printf("\n");
//	}
//}
//
//int main()
//{
//	int N = 9;
//	int ** h_sudoku;
//	int * h_number_presence = new int[243];
//	int * h_number_presence_nice_adding = new int[256];
//
//	int *h_result;
//	int(*d_sudoku)[9];
//	int* d_number_presence;
//	int* d_number_presence_nice_adding;
//
//	int *d_result;
//	
//	char filename[] = "arr_1_solved.txt";
//	//char filename[] = "arr_1_unsolved.txt";
//	int help[9][9];
//	int sharedMemorySize;
//	
//	cudaEvent_t start, stop;
//	float time;
//
//	h_result = (int*)malloc(sizeof(int));
//
//	h_sudoku = readSudokuArray(filename);
//
//	//printArray(h_sudoku, N, N);
//
//	for(int i = 0; i < 9; i++)
//		for (int j = 0; j < 9; j++)
//			help[i][j] = h_sudoku[i][j];
//		
//
//	cudaMalloc((void **)&d_sudoku, N * N * sizeof(int));
//	cudaMalloc((void **)&d_number_presence, 243 * sizeof(int));
//	cudaMalloc((void **)&d_number_presence_nice_adding, 256 * sizeof(int));
//	cudaMalloc((void **)&d_result, sizeof(int));
//
//	cudaMemcpy(d_sudoku, help, (N*N)*sizeof(int), cudaMemcpyHostToDevice);
//
//	cudaEventCreate(&start);
//	cudaEventCreate(&stop);
//
//	cudaEventRecord(start, 0);
//	cudaEventRecord(stop, 0);
//
//	dim3 dimBlock = dim3(9, 9, 1);
//	dim3 dimGrid = dim3(1);
//	sharedMemorySize = 243 * sizeof(int);
//
//	checkCorrectness <<<dimGrid, dimBlock, sharedMemorySize>>> (d_sudoku, d_number_presence);
//
//	cudaDeviceSynchronize();
//
//	cudaMemcpy(h_number_presence, d_number_presence, 243 * sizeof(int), cudaMemcpyDeviceToHost);
//
//	for (int i = 0; i < 243; i++)
//		h_number_presence_nice_adding[i] = h_number_presence[i];
//
//	for (int i = 243; i < 256; i++)
//	{
//		h_number_presence_nice_adding[i] = 0;
//	}
//
//	cudaMemcpy(d_number_presence_nice_adding, h_number_presence_nice_adding, 256 * sizeof(int), cudaMemcpyHostToDevice);
//
//	addArray << <1, 256 >> > (d_number_presence_nice_adding, 256, d_result);
//	
//	cudaDeviceSynchronize();
//
//	cudaMemcpy(h_result, d_result, sizeof(int), cudaMemcpyDeviceToHost);
//	//cudaMemcpy(h_number_presence, d_number_presence, 243 * sizeof(int), cudaMemcpyDeviceToHost);
//	cudaMemcpy(h_number_presence_nice_adding, d_number_presence_nice_adding, 256 * sizeof(int), cudaMemcpyDeviceToHost);
//
//	cudaDeviceSynchronize();
//	cudaEventSynchronize(stop);
//	cudaEventElapsedTime(&time, start, stop);
//
//	
//	printf("Elapsed time: %f\n", time);
//
//	cudaEventDestroy(start);
//	cudaEventDestroy(stop);
//
//	printOneDimArray(h_number_presence, 27, 9);
//	//for (int i = 0; i < 243; i++)
//		//printf("[%d : %d]", i, h_number_presence[i]);
//
//	printf("OBLICZONY WYNIK: %d", *h_result);
//
//	getchar();
//}
//
///*int* readSudokuArray_OneDimension(char* filename)
//{
//	int* h_sudoku = new int[9];
//
//	printf("SUDOKU FILENAME: %s\n", filename);
//	std::ifstream sudoku_file(filename);
//
//	int a0, a1, a2, a3, a4, a5, a6, a7, a8;
//	int i = 0;
//	
//	while (sudoku_file >> a0 >> a1 >> a2 >> a3 >> a4 >> a5 >> a6 >> a7 >> a8)
//	{
//		h_sudoku[i*9 + 0] = a0;
//		h_sudoku[i*9 + 1] = a1;
//		h_sudoku[i*9 + 2] = a2;
//		h_sudoku[i*9 + 3] = a3;
//		h_sudoku[i*9 + 4] = a4;
//		h_sudoku[i*9 + 5] = a5;
//		h_sudoku[i*9 + 6] = a6;
//		h_sudoku[i*9 + 7] = a7;
//		h_sudoku[i*9 + 8] = a8;
//		i++;
//	}
//	
//	return h_sudoku;
//	}*/