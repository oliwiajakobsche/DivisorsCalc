#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "kernel.h"
#include <stdio.h>
#include <thrust/execution_policy.h>
#include <iostream>


using namespace std;

__global__ void InsertIntoCTabIsDivisible(int* a, int number, int nrOfThreads) {
    int threadId = blockIdx.x * blockDim.x + threadIdx.x;

    if (threadId < nrOfThreads)
    {
        if ((number % (threadId + 1) == 0))
            a[threadId] = 1;
        else
            a[threadId] = 0;
    }
}

__global__ void InsertIntoETabDividors(int* c, int* d, int* e, int nrOfThreads) {
    int threadId = blockIdx.x * blockDim.x + threadIdx.x;

    if (threadId < nrOfThreads)
    {
        if (c[threadId] == 1)
        {
            int temp = d[threadId];
            e[temp] = threadId + 1;
        }
    }
}

int main()
{
    PrintProjectInfo();
    int y = GetNumberFromUser();
    int n = MaxDividorToCheck(y);

    //************** PREPARING MEMORY **************
    int blockSize = 1024;
    dim3 threadsAmmount(blockSize);
    dim3 blocksAmmount((n / blockSize) + 1);
    //Alokacja pamięci na tablice po stronie CPU (host)
    int* c = new int[n];
    int* d = new int[n];
    int* e = new int[n];
    //Alokacja pamięci na tablice po stronie GPU (device)
    int* device_c;
    int* device_d;
    int* device_e;
    const int size = n * sizeof(int);
    cudaMalloc((void**)&device_c, size);
    cudaMalloc((void**)&device_d, size);
    cudaMalloc((void**)&device_e, size);
    //**********************************************

                                                                                                 
    InsertIntoCTabIsDivisible<<<blocksAmmount, blockSize>>>(device_c, y, n);    
    cudaMemcpy(c, device_c, size, cudaMemcpyDeviceToHost);
    
    for (int i = 0; i < n; i++)
    {
        cout << "c[" << i << "] =" << c[i] << endl;
    }

    exclusive_scan(thrust::device, device_c, device_c + n, device_d, 0);
    cudaMemcpy(d, device_d, size, cudaMemcpyDeviceToHost);

    for (int i = 0; i < n; i++)
    {
        cout << "d[" << i << "] =" << d[i] << endl;
    }

    InsertIntoETabDividors<<<blocksAmmount, blockSize>>>(device_c, device_d, device_e, n);

    cudaMemcpy(e, device_e, size, cudaMemcpyDeviceToHost);

    int dividorsCounter = c[n - 1] + d[n - 1];

    for (int i = 0; i < dividorsCounter; i++)
    {
        cout << e[i] <<endl;
    }

    return 0;
}

int MaxDividorToCheck(int y)
{
    int dividorsNr = floor(sqrt(y));
    cout << "Max possible dividor to check - floor(sqrt(y)) = " << dividorsNr <<endl;
    return dividorsNr;
}

void PrintProjectInfo()
{
    cout << "*******************" << endl;
    cout << "Divisors Generator" << endl;
    cout << "Student nr 106545" << endl;
    cout << "*******************\n" << endl;
}

int GetNumberFromUser()
{
    int input = 0;

    do {
        cout << "Enter an integer value to get the list of divisors of this number: ";
        cin >> input;
    } while (input < 1);

    return input;
}

