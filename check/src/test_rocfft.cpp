#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
// Include CUDA runtime and CUFFT
#include <hip/hip_runtime.h>
#include <hipfft.h>

#define pi 3.1415926535
#define LENGTH 100 //signal sampling points

int main()
{
    // data gen
    float Data[LENGTH] = { 1,2,3,4 };
    float fs = 1000000.000;//sampling frequency
    float f0 = 200000.00;// signal frequency
    for (int i = 0; i < LENGTH; i++)
    {
        Data[i] = 1.35*cos(2 * pi*f0*i / fs);//signal gen,
    }

    hipfftComplex *CompData = (hipfftComplex*)malloc(LENGTH * sizeof(hipfftComplex));//allocate memory for the data in host
    int i;
    for (i = 0; i < LENGTH; i++)
    {
        CompData[i].x = Data[i];
        CompData[i].y = 0;
    }

    hipfftComplex *d_fftData;
    hipMalloc((void**)&d_fftData, LENGTH * sizeof(hipfftComplex));// allocate memory for the data in device
    hipMemcpy(d_fftData, CompData, LENGTH * sizeof(hipfftComplex), hipMemcpyHostToDevice);// copy data from host to device

    hipfftHandle plan;// cuda library function handle
    hipfftPlan1d(&plan, LENGTH, HIPFFT_C2C, 1);//declaration
    hipfftExecC2C(plan, (hipfftComplex*)d_fftData, (hipfftComplex*)d_fftData, HIPFFT_FORWARD);//execute
    hipDeviceSynchronize();//wait to be done
    hipMemcpy(CompData, d_fftData, LENGTH * sizeof(hipfftComplex), hipMemcpyDeviceToHost);// copy the result from device to host

    for (i = 0; i < LENGTH / 2; i++)
    {
        printf("i=%d\tf= %6.1fHz\tRealAmp=%3.1f\t", i, fs*i / LENGTH, CompData[i].x*2.0 / LENGTH);
        printf("ImagAmp=+%3.1fi", CompData[i].y*2.0 / LENGTH);
        printf("\n");
    }
    hipfftDestroy(plan);
    free(CompData);
    hipFree(d_fftData);

}

