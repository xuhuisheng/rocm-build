
#include <stdio.h>

#include <hip/hip_runtime.h>
#include <hipsparse.h>

int main()
{
    hipsparseHandle_t handle;
    hipsparseCreate(&handle);
    int v = 0;
    hipsparseGetVersion(handle, &v);
    printf("[hipSPARSE]  %d\n", v);
    return 0;
}

