
#include <stdio.h>

#include <hip/hip_runtime.h>
#include <rocsparse.h>

int main()
{
    rocsparse_handle handle;
    rocsparse_create_handle(&handle);
    int v = 0;
    rocsparse_get_version(handle, &v);
    printf("[rocSPARSE]  %d\n", v);
    return 0;
}

