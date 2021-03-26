
#include "rocblas.h"

int main()
{
    char text[100];
    rocblas_status ret = rocblas_get_version_string(text, 100);
    if (ret != rocblas_status_success) {
        printf("[rocBLAS]    %s\n", rocblas_status_to_string(ret));
        return 0;
    }
    printf("[rocBLAS]    %s\n", text);
    return 0;
}


