
#include "rocfft.h"

char status_text[10] = "failure";

char* rocfft_status_to_string(rocfft_status status)
{
    return status_text;
}

int main()
{
    char text[100];
    rocfft_status ret = rocfft_get_version_string(text, 100);
    if (ret != rocfft_status_success) {
        printf("[rocFFT]     %s\n", rocfft_status_to_string(ret));
        return 0;
    }
    printf("[rocFFT]     %s\n", text);
    return 0;
}


