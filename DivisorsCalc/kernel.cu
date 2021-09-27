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
    int n = DetermineNumberOfDivisorsToCheck(y);

   
    return 0;
}

int DetermineNumberOfDivisorsToCheck(int y)
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

