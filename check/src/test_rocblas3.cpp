
#include "rocblas.h"
#include <thread>

int test_sgemm(float * a, float * b , float * c, float alpha, float beta)
{
    printf("\n\nstart\n\n");
    rocblas_handle handle;

    rocblas_status ret;

    ret = rocblas_create_handle(&handle);
    if(ret != rocblas_status_success)
    {
        printf("[rocBLAS]   %s\n", rocblas_status_to_string(ret));
        return EXIT_FAILURE;
    }
    rocblas_set_atomics_mode(handle, rocblas_atomics_allowed);

    rocblas_operation transA = rocblas_operation_none;
    rocblas_operation transB = rocblas_operation_none;
    rocblas_int m = 3;
    rocblas_int n = 3;
    rocblas_int k = 3;
    // float alpha = 1;
    // float A[6] = {1, 0, 0, 0, 0, 0};
    // float A[6] = {1, 2, 3, 4, 5, 6};
    // float A[9] = a;
    float * A = a;
    rocblas_int lda = 3;
    // float B[9] = b;
    float * B = b;
    rocblas_int ldb = 3;
    // float beta = beta;
    // float C[9] = c;
    float * C = c;
    float D[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};

    float * d_alpha;
    float * d_beta;

    rocblas_int ldc = 3;

    float guard[8192] = {101, 102, 103, 104, 105, 106, 107, 108, 109};

    int size_a = m * k;
    int size_b = k * n;
    int size_c = m * n;
    float *da, *db, *dc;
    hipMalloc(&da, (size_a + 8192 * 2) * sizeof(float));
    hipMalloc(&db, (size_b + 8192 * 2) * sizeof(float));
    hipMalloc(&dc, (size_c + 8192 * 2) * sizeof(float));
    hipMalloc(&d_alpha, (1 + 8192 * 2) * sizeof(float));
    hipMalloc(&d_beta, (1 + 8192 * 2) * sizeof(float));

    hipMemcpy(da, guard, sizeof(float) * 8192, hipMemcpyHostToDevice);
    hipMemcpy(db, guard, sizeof(float) * 8192, hipMemcpyHostToDevice);
    hipMemcpy(dc, guard, sizeof(float) * 8192, hipMemcpyHostToDevice);
    hipMemcpy(d_alpha, guard, sizeof(float) * 8192, hipMemcpyHostToDevice);
    hipMemcpy(d_beta, guard, sizeof(float) * 8192, hipMemcpyHostToDevice);

    da += 8192;
    db += 8192;
    dc += 8192;
    d_alpha += 8192;
    d_beta += 8192;

    hipMemcpy(da + 9, guard, sizeof(float) * 8192, hipMemcpyHostToDevice);
    hipMemcpy(db + 9, guard, sizeof(float) * 8192, hipMemcpyHostToDevice);
    hipMemcpy(dc + 9, guard, sizeof(float) * 8192, hipMemcpyHostToDevice);
    hipMemcpy(d_alpha + 1, guard, sizeof(float) * 8192, hipMemcpyHostToDevice);
    hipMemcpy(d_beta + 1, guard, sizeof(float) * 8192, hipMemcpyHostToDevice);

    hipMemcpy(da, A, sizeof(float) * size_c, hipMemcpyHostToDevice);
    hipMemcpy(db, B, sizeof(float) * size_b, hipMemcpyHostToDevice);
    hipMemcpy(dc, C, sizeof(float) * size_c, hipMemcpyHostToDevice);
    hipMemcpy(d_alpha, &alpha, sizeof(float), hipMemcpyHostToDevice);
    hipMemcpy(d_beta, &beta, sizeof(float), hipMemcpyHostToDevice);

    printf("A\n");
    printf("[%#.f, %#.f, %#.f]\n", A[0], A[3], A[6]);
    printf("[%#.f, %#.f, %#.f]\n", A[1], A[4], A[7]);
    printf("[%#.f, %#.f, %#.f]\n", A[2], A[5], A[8]);
    printf("B\n");
    printf("[%#.f, %#.f, %#.f]\n", B[0], B[3], B[6]);
    printf("[%#.f, %#.f, %#.f]\n", B[1], B[4], B[7]);
    printf("[%#.f, %#.f, %#.f]\n", B[2], B[5], B[8]);
    printf("C\n");
    printf("[%#.f, %#.f, %#.f]\n", C[0], C[3], C[6]);
    printf("[%#.f, %#.f, %#.f]\n", C[1], C[4], C[7]);
    printf("[%#.f, %#.f, %#.f]\n", C[2], C[5], C[8]);

    rocblas_set_pointer_mode(handle, rocblas_pointer_mode_host);
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

    hipMemcpy(D, dc, sizeof(float) * size_c, hipMemcpyDeviceToHost);

    printf("D\n");
    printf("[%#.f, %#.f, %#.f]\n", D[0], D[3], D[6]);
    printf("[%#.f, %#.f, %#.f]\n", D[1], D[4], D[7]);
    printf("[%#.f, %#.f, %#.f]\n", D[2], D[5], D[8]);


    hipMemcpy(dc, C, sizeof(float) * size_c, hipMemcpyHostToDevice);

    rocblas_set_pointer_mode(handle, rocblas_pointer_mode_device);
    ret = rocblas_sgemm(
            handle,
            transA,
            transB,
            m,
            n,
            k,
            d_alpha,
            da,
            lda,
            db,
            ldb,
            d_beta,
            dc,
            ldc);

    printf("%s\n", rocblas_status_to_string(ret));

    hipMemcpy(D, dc, sizeof(float) * size_c, hipMemcpyDeviceToHost);

    printf("D\n");
    printf("[%#.f, %#.f, %#.f]\n", D[0], D[3], D[6]);
    printf("[%#.f, %#.f, %#.f]\n", D[1], D[4], D[7]);
    printf("[%#.f, %#.f, %#.f]\n", D[2], D[5], D[8]);

    printf("\n\nend\n\n");



    ret = rocblas_destroy_handle(handle);
    if (ret != rocblas_status_success) {
        printf("[rocBLAS]   %s\n", rocblas_status_to_string(ret));
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}

int main()
{
    int ret_val = EXIT_SUCCESS;
    float a[9] = {7, 10, 1, 7, 6, 3, 7, 6, 7};
    float b[9] = {-9, 6, -7, 4, -3, 9, -5, 9, -1};
    float c[9] = {10, 2, 9, 10, 4, 7, 6, 3, 7};
    float alpha = 5;
    float beta = 0;

    //printf(" ########## start sgemm\n");
    //ret_val = test_sgemm(a, b, c, alpha, beta);
    //if (ret_val != EXIT_SUCCESS)
    //{
    //    printf("sgemm failure\n");
    //}
    // printf(" ########## end   sgemm\n");
    test_sgemm(a, b, c, alpha, beta);
    b[3] = 9;
    b[4] = -7;
    b[5] = 10;
    b[6] = -4;
    b[7] = 10;
    b[8] = -5;
    // c = {10, 2, 9, 10, 4, 7, 6, 3, 7};
    c[0] = 10;
    c[1] = 2;
    c[2] = 9;
    c[3] = 10;
    c[4] = 4;
    c[5] = 7;
    c[6] = 6;
    c[7] = 3;
    c[8] = 7;
    alpha = 0;
    beta = 3;
    test_sgemm(a, b, c, alpha, beta);

    b[3] = 9;
    b[4] = -10;
    b[5] = 1;
    b[6] = -8;
    b[7] = 4;
    b[8] = -10;

    // c = {10, 2, 9, 10, 4, 7, 6, 3, 7};
    c[0] = 10;
    c[1] = 2;
    c[2] = 9;
    c[3] = 10;
    c[4] = 4;
    c[5] = 7;
    c[6] = 6;
    c[7] = 3;
    c[8] = 7;

    alpha = 1;
    beta = 3;
    ret_val = test_sgemm(a, b, c, alpha, beta);



    b[3] = 6;
    b[4] = -7;
    b[5] = 3;
    b[6] = -2;
    b[7] = 2;
    b[8] = -5;

    // c = {10, 2, 9, 10, 4, 7, 6, 3, 7};
    c[0] = 10;
    c[1] = 2;
    c[2] = 9;
    c[3] = 10;
    c[4] = 4;
    c[5] = 7;
    c[6] = 6;
    c[7] = 3;
    c[8] = 7;

    alpha = 1;
    beta = 1;
    ret_val = test_sgemm(a, b, c, alpha, beta);


		  

    return 0;
}



