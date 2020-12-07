
#include "rocblas.h"

int main()
{
    rocblas_handle handle;
    if(rocblas_create_handle(&handle) != rocblas_status_success) return EXIT_FAILURE;

    rocblas_operation transA = rocblas_operation_none;
    rocblas_operation transB = rocblas_operation_none;
    rocblas_int m = 2;
    rocblas_int n = 2;
    rocblas_int k = 2;
    float alpha = 1;
    float A[4] = {1, 0, 0, 0};
    rocblas_int lda = 2;
    float B[4] = {1, 2, 3, 4};
    rocblas_int ldb = 2;
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

    rocblas_status ret = rocblas_sgemm(
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
        printf("%f\n", C[i]);
    }

    if(rocblas_destroy_handle(handle) != rocblas_status_success) return EXIT_FAILURE;

    return 0;
}


