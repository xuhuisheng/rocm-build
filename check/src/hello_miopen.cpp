
#include <miopen/miopen.h>

int main()
{
    size_t v1 = 0;
    size_t v2 = 0;
    size_t v3 = 0;
    miopenGetVersion(&v1, &v2, &v3);
    printf("[MIOpen]     %zu %zu %zu\n", v1, v2, v3);
    return 0;
}




