
#include "rocblas.h"

int test_sgemm()
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
        printf("sgemm %f\n", C[i]);
    }

    if(rocblas_destroy_handle(handle) != rocblas_status_success) return EXIT_FAILURE;

    return 0;
}

int test_sgemm_batched()
{
    rocblas_handle handle;
    if(rocblas_create_handle(&handle) != rocblas_status_success) return EXIT_FAILURE;

    rocblas_operation transA = rocblas_operation_none;
    rocblas_operation transB = rocblas_operation_none;
    rocblas_int m = 2;
    rocblas_int n = 2;
    rocblas_int k = 2;
    float alpha = 1;
    float A[2][4] = {
        {1, 0, 0, 0},
        {1, 0, 0, 0}
    };
    rocblas_int lda = 2;
    float B[2][4] = {
        {1, 2, 3, 4},
        {1, 2, 3, 4}
    };
    rocblas_int ldb = 2;
    float beta = 0;
    float C[2][4] = {
        {0, 0, 0, 0},
        {0, 0, 0, 0}
    };
    rocblas_int ldc = 2;
    rocblas_int batch_count = 2;

    int size_a = m * k;
    int size_b = k * n;
    int size_c = m * n;
    float **da, **db, **dc;

    hipMalloc(&da, sizeof(float*) * batch_count);
    hipMalloc(&db, sizeof(float*) * batch_count);
    hipMalloc(&dc, sizeof(float*) * batch_count);
    hipMalloc(&(da[0]), size_a * sizeof(float));
    hipMalloc(&(db[0]), size_b * sizeof(float));
    hipMalloc(&(dc[0]), size_c * sizeof(float));
    hipMalloc(&(da[1]), size_a * sizeof(float));
    hipMalloc(&(db[1]), size_b * sizeof(float));
    hipMalloc(&(dc[1]), size_c * sizeof(float));

    hipMemcpy(da[0], A[0], sizeof(float) * size_a, hipMemcpyHostToDevice);
    hipMemcpy(db[0], B[0], sizeof(float) * size_b, hipMemcpyHostToDevice);
    hipMemcpy(dc[0], C[0], sizeof(float) * size_c, hipMemcpyHostToDevice);
    hipMemcpy(da[1], A[1], sizeof(float) * size_a, hipMemcpyHostToDevice);
    hipMemcpy(db[1], B[1], sizeof(float) * size_b, hipMemcpyHostToDevice);
    hipMemcpy(dc[1], C[1], sizeof(float) * size_c, hipMemcpyHostToDevice);

    rocblas_status ret = rocblas_sgemm_batched(
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
            ldc,
            batch_count);

    printf("%s\n", rocblas_status_to_string(ret));

    hipMemcpy(C[0], dc[0], sizeof(float) * size_c, hipMemcpyDeviceToHost);
    hipMemcpy(C[1], dc[1], sizeof(float) * size_c, hipMemcpyDeviceToHost);

    for (int i = 0; i < 2; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            printf("sgemm %f\n", C[i][j]);
        }
    }

    if(rocblas_destroy_handle(handle) != rocblas_status_success) return EXIT_FAILURE;

    return 0;
}

int test_sgemm_strided_batched()
{
    rocblas_handle handle;
    if(rocblas_create_handle(&handle) != rocblas_status_success) return EXIT_FAILURE;

    rocblas_operation transA = rocblas_operation_none;
    rocblas_operation transB = rocblas_operation_none;
    rocblas_int m = 2;
    rocblas_int n = 2;
    rocblas_int k = 2;
    float alpha = 1;
    float A[] = {1, 0, 0, 0, 1, 2, 3, 4};
    rocblas_int lda = 2;
    rocblas_stride stride_a = 4;
    float B[] = {1, 2, 3, 4, 1, 2, 3, 4};
    rocblas_int ldb = 2;
    rocblas_stride stride_b = 4;
    float beta = 0;
    float C[] = {0, 0, 0, 0, 0, 0, 0, 0};
    rocblas_int ldc = 2;
    rocblas_stride stride_c = 4;
    rocblas_int batch_count = 2;

    int size_a = m * k * batch_count;
    int size_b = k * n * batch_count;
    int size_c = m * n * batch_count;
    float *da, *db, *dc;
    hipMalloc(&da, size_a * sizeof(float));
    hipMalloc(&db, size_b * sizeof(float));
    hipMalloc(&dc, size_c * sizeof(float));

    hipMemcpy(da, A, sizeof(float) * size_a, hipMemcpyHostToDevice);
    hipMemcpy(db, B, sizeof(float) * size_b, hipMemcpyHostToDevice);
    hipMemcpy(dc, C, sizeof(float) * size_c, hipMemcpyHostToDevice);

    rocblas_status ret = rocblas_sgemm_strided_batched(
            handle,
            transA,
            transB,
            m,
            n,
            k,
            &alpha,
            da,
            lda,
            stride_a = 4,
            db,
            ldb,
            stride_b = 4,
            &beta,
            dc,
            ldc,
            stride_c = 4,
            batch_count);

    printf("%s\n", rocblas_status_to_string(ret));

    hipMemcpy(C, dc, sizeof(float) * size_c, hipMemcpyDeviceToHost);

    for (int i = 0; i < size_c; i++)
    {
        printf("sgemm %f\n", C[i]);
    }

    if(rocblas_destroy_handle(handle) != rocblas_status_success) return EXIT_FAILURE;

    return 0;
}

int main()
{
    printf(" ########## start sgemm\n");
    test_sgemm();
    printf(" ########## end   sgemm\n");

    printf(" ########## start sgemm-batched\n");
    // test_sgemm_batched();
    printf(" ########## end   sgemm-batched\n");

    printf(" ########## start sgemm-strided-batched\n");
    test_sgemm_strided_batched();
    printf(" ########## end   sgemm-strided-batched\n");

}


