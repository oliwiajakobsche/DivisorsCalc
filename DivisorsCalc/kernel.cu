#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "kernel.h"
#include <stdio.h>
#include <iostream>

using namespace std;

int main()
{
    PrintProjectInfo();
    int y = GetNumberFromUser();
    int n = MaxDividorToCheck(y);

    // ************** PREPARING MEMORY **************
    int blockSize = 1024;
    dim3 threadsAmmount(blockSize);
    dim3 blocksAmmount((n / blockSize) + 1);
    blocksAmmount.x = ((n) / blockSize) + 1;
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
    // **********************************************

    return 0;
}

int MaxDividorToCheck(int y)
{
    int dividorsNr = floor(sqrt(y));
    cout << "Max possible dividor to check - floor(sqrt(y)) = " << dividorsNr;
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

