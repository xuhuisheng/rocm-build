
#include <stdio.h>
#include <stdlib.h>
#include <hipfft.h>

#define NX 1024
#define BATCH 1

int main()
{
    hipfftDoubleComplex *data;

    hipMalloc((void**) &data, sizeof(hipfftDoubleComplex) * NX * BATCH);

    hipfftHandle plan;
    hipfftPlan1d(&plan, NX, HIPFFT_Z2Z, BATCH);

    hipfftExecZ2Z(plan, data, data, HIPFFT_FORWARD);

    hipfftDestroy(plan);
    hipFree(data);
}


