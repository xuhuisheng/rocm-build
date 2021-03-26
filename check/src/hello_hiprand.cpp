
#include <hiprand/hiprand.h>

int main()
{
    int v;
    hiprandStatus_t status = hiprandGetVersion(&v);
    if(status != HIPRAND_STATUS_SUCCESS)
    {
        printf("[hipRAND]    failure\n");
        return -1;
    }
    printf("[hipRAND]    %d\n", v);
    return 0;
}

