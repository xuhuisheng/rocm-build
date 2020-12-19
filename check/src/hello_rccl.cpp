
#include <rccl.h>

int main()
{
    int v = 0;
    ncclGetVersion(&v);
    printf("[rccl]      %d\n", v);
    return 0;
}




