
#include "rocblas.h"

#include <iostream>

int test_sgemm(float * a, float * b , float * c, float alpha, float beta)
{
    printf("\n\nstart %f %f\n\n", alpha, beta);
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

    // device_vector<float> db{9, 1, false};
    float * da;
    float * db;
    float * dc;
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

    // printf("%s\n", rocblas_status_to_string(ret));

    hipMemcpy(D, dc, sizeof(float) * size_c, hipMemcpyDeviceToHost);

    printf("D, host mode\n");
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

    //printf("%s\n", rocblas_status_to_string(ret));

    hipMemcpy(D, dc, sizeof(float) * size_c, hipMemcpyDeviceToHost);

    printf("D, device mode\n");
    printf("[%#.f, %#.f, %#.f]\n", D[0], D[3], D[6]);
    printf("[%#.f, %#.f, %#.f]\n", D[1], D[4], D[7]);
    printf("[%#.f, %#.f, %#.f]\n", D[2], D[5], D[8]);

    float h_alpha = alpha;
    float h_beta = beta;
    float * hA = a;
    float * hB = b;
    float * hC_gold = c;
        std::cout << "cblas  : C : "
                 << (h_alpha * (hA[0] * hB[0] + hA[3] * hB[1] + hA[6] * hB[2]) + h_beta * hC_gold[0]) << " "
                 << (h_alpha * (hA[1] * hB[0] + hA[4] * hB[1] + hA[7] * hB[2]) + h_beta * hC_gold[1]) << " "
                 << (h_alpha * (hA[2] * hB[0] + hA[5] * hB[1] + hA[8] * hB[2]) + h_beta * hC_gold[2]) << " "
                 << (h_alpha * (hA[0] * hB[3] + hA[3] * hB[4] + hA[6] * hB[5]) + h_beta * hC_gold[3]) << " "
                 << (h_alpha * (hA[1] * hB[3] + hA[4] * hB[4] + hA[7] * hB[5]) + h_beta * hC_gold[4]) << " "
                 << (h_alpha * (hA[2] * hB[3] + hA[5] * hB[4] + hA[8] * hB[5]) + h_beta * hC_gold[5]) << " "
                 << (h_alpha * (hA[0] * hB[6] + hA[3] * hB[7] + hA[6] * hB[8]) + h_beta * hC_gold[6]) << " "
                 << (h_alpha * (hA[1] * hB[6] + hA[4] * hB[7] + hA[7] * hB[8]) + h_beta * hC_gold[7]) << " "
                 << (h_alpha * (hA[2] * hB[6] + hA[5] * hB[7] + hA[8] * hB[8]) + h_beta * hC_gold[8]) << " "
                 << std::endl;


    printf("\n\nend\n\n");



    ret = rocblas_destroy_handle(handle);
    if (ret != rocblas_status_success) {
        printf("[rocBLAS]   %s\n", rocblas_status_to_string(ret));
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}

void test0()
{

    float a[9] = {7, 1, 3, 9, 9, 7, 1, 3, 7};
    float b[9] = {-9, 2, -6, 1, -6, 9, -8, 4, -10};
    float c[9] = {10, 7, 8, 7, 6, 2, 8, 5, 9};
    float alpha = 5;
    float beta = 0;

    test_sgemm(a, b, c, alpha, beta);
}


void test1()
{

    float a[9] = {1, 9, 5, 7, 3, 2, 9, 7, 4};
    float b[9] = {-8, 2, -5, 7, -1, 8, -1, 1, -5};
    float c[9] = {10, 6, 1, 1, 8, 8, 8, 2, 6};
    float alpha = 0;
    float beta = 3;

    test_sgemm(a, b, c, alpha, beta);
}


void test2()
{

    float a[9] = {9, 6, 10, 10, 1, 8, 5, 3, 2};
    float b[9] = {-2, 1, -3, 8, -4, 1, -8, 10, -2};
    float c[9] = {10, 5, 9, 9, 3, 3, 3, 7, 5};
    float alpha = 1;
    float beta = 3;

    test_sgemm(a, b, c, alpha, beta);
}


void test3()
{

    float a[9] = {2, 2, 9, 8, 2, 7, 2, 7, 4};
    float b[9] = {-9, 10, -9, 9, -2, 9, -9, 8, -9};
    float c[9] = {6, 10, 6, 6, 1, 4, 10, 4, 1};
    float alpha = 1;
    float beta = 1;

    test_sgemm(a, b, c, alpha, beta);
}


int main()
{
	test0();
	test1();
	test2();
	test3();

    return 0;
}



