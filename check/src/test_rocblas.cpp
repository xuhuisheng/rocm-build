
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

int test_sgemm_batched()
{
    rocblas_handle handle;

    rocblas_status ret;

    ret = rocblas_create_handle(&handle);
    if(ret != rocblas_status_success)
    {
        printf("[rocBLAS]   %s\n", rocblas_status_to_string(ret));
        return EXIT_FAILURE;
    }

    float a_list[8] = {1, 0, 0, 0, 1, 2, 3, 4};
    float b_list[8] = {1, 2, 3, 4, 1, 2, 3, 4};
    float c_list[8] = {0, 0, 0, 0, 0, 0, 0, 0};

    rocblas_int batch_count = 2;

    float *da_list, *db_list, *dc_list;
    size_t da_pitch, db_pitch, dc_pitch;
    hipMallocPitch((void**)&da_list, &da_pitch, 4 * sizeof(float), 2);
    hipMallocPitch((void**)&db_list, &db_pitch, 4 * sizeof(float), 2);
    hipMallocPitch((void**)&dc_list, &dc_pitch, 4 * sizeof(float), 2);
    hipMemcpy2D(da_list, da_pitch, a_list, 4 * sizeof(float), 4 * sizeof(float), 2, hipMemcpyHostToDevice);
    hipMemcpy2D(db_list, db_pitch, b_list, 4 * sizeof(float), 4 * sizeof(float), 2, hipMemcpyHostToDevice);
    hipMemcpy2D(dc_list, dc_pitch, c_list, 4 * sizeof(float), 4 * sizeof(float), 2, hipMemcpyHostToDevice);

    rocblas_operation transA = rocblas_operation_none;
    rocblas_operation transB = rocblas_operation_none;
    rocblas_int m = 2;
    rocblas_int n = 2;
    rocblas_int k = 2;
    float alpha = 1;
    float **A = 0;
    A = (float**) malloc(batch_count * sizeof(float*));
    A[0] = da_list;
    A[1] = da_list + da_pitch / sizeof(float);
    rocblas_int lda = 2;
    float **B = 0;
    B = (float**) malloc(batch_count * sizeof(float*));
    B[0] = db_list;
    B[1] = db_list + db_pitch / sizeof(float);
    rocblas_int ldb = 2;
    float beta = 0;
    float **C = 0;
    C = (float**) malloc(batch_count * sizeof(float*));
    C[0] = dc_list;
    C[1] = dc_list + dc_pitch / sizeof(float);
    rocblas_int ldc = 2;

    int size_a = m * k;
    int size_b = k * n;
    int size_c = m * n;

    float **da, **db, **dc;

    hipMalloc(&da, sizeof(float*) * batch_count);
    hipMalloc(&db, sizeof(float*) * batch_count);
    hipMalloc(&dc, sizeof(float*) * batch_count);

    hipMemcpy(da, A, sizeof(float*) * batch_count, hipMemcpyHostToDevice);
    hipMemcpy(db, B, sizeof(float*) * batch_count, hipMemcpyHostToDevice);
    hipMemcpy(dc, C, sizeof(float*) * batch_count, hipMemcpyHostToDevice);

    ret = rocblas_sgemm_batched(
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

    float result_list[] = {0, 0, 0, 0, 0, 0, 0, 0};
    hipMemcpy2D(result_list, 4 * sizeof(float), dc_list, dc_pitch, 4 * sizeof(float), 2, hipMemcpyDeviceToHost);

    for (int i = 0; i < 8; i++)
    {
        printf("sgemm %f\n", result_list[i]);
    }

    ret = rocblas_destroy_handle(handle);
    if (ret != rocblas_status_success) {
        printf("[rocBLAS]   %s\n", rocblas_status_to_string(ret));
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}

int test_sgemm_strided_batched()
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

    ret = rocblas_sgemm_strided_batched(
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

    ret = rocblas_destroy_handle(handle);
    if (ret != rocblas_status_success) {
        printf("[rocBLAS]   %s\n", rocblas_status_to_string(ret));
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}

void test_pitch()
{
    printf("start\n");

    float a_list[] = {0, 1, 2, 3, 4, 5};
    float *da_list;
    size_t da_pitch;

    hipMallocPitch((void**)&da_list, &da_pitch, 3 * sizeof(float), 2);

    hipMemcpy2D(da_list, da_pitch, a_list, 3 * sizeof(float), 3 * sizeof(float), 2, hipMemcpyHostToDevice);

    printf("pitch : %zu\n", da_pitch);

    float b_list[] = {0, 0, 0, 0, 0, 0};

    printf("before");
    for (int i = 0; i < 6; i++)
    {
        printf(" %f", b_list[i]);
    }
    printf("\n");

    hipMemcpy2D(b_list, 3 * sizeof(float), da_list, da_pitch, 3 * sizeof(float), 2, hipMemcpyDeviceToHost);

    printf("after ");
    for (int i = 0; i < 6; i++)
    {
        printf(" %f", b_list[i]);
    }
    printf("\n");

    printf("end\n");
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


    printf(" ########## start sgemm-batched\n");
    ret_val = test_sgemm_batched();
    if (ret_val != EXIT_SUCCESS)
    {
        printf("sgemm batched failure\n");
    }
    printf(" ########## end   sgemm-batched\n");


    printf(" ########## start sgemm-strided-batched\n");
    ret_val = test_sgemm_strided_batched();
    if (ret_val != EXIT_SUCCESS)
    {
        printf("sgemm strided batched failure\n");
    }
    printf(" ########## end   sgemm-strided-batched\n");

}


