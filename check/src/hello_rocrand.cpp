
#include <stdio.h>

#include <hip/hip_runtime.h>
#include <rocrand/rocrand.h>

int main()
{
    int v = 0;
    rocrand_get_version(&v);
    printf("[rocRAND]    %d\n", v);
    return 0;
}

