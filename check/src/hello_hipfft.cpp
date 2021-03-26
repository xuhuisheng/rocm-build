
#include "hipfft.h"

char status_text[10] = "failure";

char* hipfft_status_to_string(hipfftResult status)
{
    return status_text;
}

int main()
{
    int v;
    hipfftResult ret = hipfftGetVersion(&v);
    if (ret != HIPFFT_SUCCESS) {
        printf("[hipFFT]     %s\n", hipfft_status_to_string(ret));
        return 0;
    }
    printf("[hipFFT]     %d\n", v);
    return 0;
}


