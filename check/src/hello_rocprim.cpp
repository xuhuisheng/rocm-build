
#include "rocprim/rocprim.hpp"

int main()
{
    int v = rocprim::version();
    printf("[rocPRIM]   %d\n", v);
    return 0;
}


