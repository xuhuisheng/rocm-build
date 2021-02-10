
#include "rocblas.h"

int test_sgemm()
{
    rocblas_handle handle;

    rocblas_status ret;

    ret = rocblas_create_handle(&handle);
    if(ret != rocblas_status_success)
    {
        printf("[rocBLAS]   %s\n", rocblas_status_to_string(ret));
        return EXIT_FAILURE;
    }

    rocblas_operation transA = rocblas_operation_none;
    rocblas_operation transB = rocblas_operation_none;
    rocblas_int m = 2;
    rocblas_int n = 2;
    rocblas_int k = 3;
    float alpha = 1;
    // float A[6] = {1, 0, 0, 0, 0, 0};
    // float A[6] = {1, 2, 3, 4, 5, 6};
    float A[6] = {1, 0, 0, 3, 0, 0};
    rocblas_int lda = 2;
    float B[6] = {1, 2, 3, 4, 5, 6};
    rocblas_int ldb = 3;
    float beta = 0;
    float C[4] = {0, 0, 0, 0};
    rocblas_int ldc = 2;

    int size_a = m * k;
    int size_b = k * n;
    int size_c = m * n;
    float *da, *db, *dc;
    hipMalloc(&da, size_a * sizeof(float));
    hipMalloc(&db, size_b * sizeof(float));
    hipMalloc(&dc, size_c * sizeof(float));

    hipMemcpy(da, A, sizeof(float) * size_a, hipMemcpyHostToDevice);
    hipMemcpy(db, B, sizeof(float) * size_b, hipMemcpyHostToDevice);
    hipMemcpy(dc, C, sizeof(float) * size_c, hipMemcpyHostToDevice);

    ret = rocblas_sgemm(
            handle,
            transA,
            transB,
            m,
            n,
            k,
            &alpha,
            da,
            lda,
            db,
            ldb,
            &beta,
            dc,
            ldc);

    printf("%s\n", rocblas_status_to_string(ret));

    hipMemcpy(C, dc, sizeof(float) * size_c, hipMemcpyDeviceToHost);

    for (int i = 0; i < 4; i++)
    {
        printf("sgemm %f\n", C[i]);
    }

    ret = rocblas_destroy_handle(handle);
    if (ret != rocblas_status_success) {
        printf("[rocBLAS]   %s\n", rocblas_status_to_string(ret));
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}

int main()
{
    // test_pitch();

    int ret_val = EXIT_SUCCESS;

    printf(" ########## start sgemm\n");
    ret_val = test_sgemm();
    if (ret_val != EXIT_SUCCESS)
    {
        printf("sgemm failure\n");
    }
    printf(" ########## end   sgemm\n");

    return 0;
}


