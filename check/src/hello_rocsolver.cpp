
#include "rocsolver.h"

int main()
{
    char text[100];
    rocblas_status ret = rocsolver_get_version_string(text, 100);
    if (ret != rocblas_status_success) {
        printf("[rocSOLVER] %s\n", rocblas_status_to_string(ret));
        return 0;
    }
    printf("[rocSOVLER] %s\n", text);
    return 0;
}


