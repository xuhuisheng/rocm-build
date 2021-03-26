
#include "rocblas.h"

int forward(float w0, float w1, float b, float* loss, float* grad);
int backward(float grad, float* w0, float* w1, float* b);

int forward(float w0, float w1, float b, float* loss, float* grad)
{
    rocblas_handle handle;

    rocblas_status ret;

    ret = rocblas_create_handle(&handle);
    if(ret != rocblas_status_success)
    {
        printf("[rocBLAS]   %s\n", rocblas_status_to_string(ret));
        return EXIT_FAILURE;
    }

    rocblas_operation transA = rocblas_operation_transpose;
    rocblas_operation transB = rocblas_operation_none;
    rocblas_int m = 1;
    rocblas_int n = 128;
    rocblas_int k = 2;
    float alpha = 1;

    float A[2] = {1, 1};
    A[0] = w0;
    A[1] = w1;

    rocblas_int lda = 2;
    float B[256] = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    };
    rocblas_int ldb = 2;
    float beta = 1;
    float C[128] = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    };
    rocblas_int ldc = 1;
    for (int i = 0; i < 128; i++)
    {
        C[i] *= b;
    }

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

    /*
    printf("sgemm ");
    for (int i = 0; i < 128; i++)
    {
        printf("%f ", C[i]);
    }
    printf("\n");
    */

    float output = 0;
    for (int i = 0; i < 128; i++)
    {
        output += C[i];
    }
    // printf("output : %f\n", (output / 128) * (output / 128));
    *loss = (output / 128) * (output / 128);
    *grad = 2 * output / 128;

    ret = rocblas_destroy_handle(handle);
    if (ret != rocblas_status_success) {
        printf("[rocBLAS]   %s\n", rocblas_status_to_string(ret));
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}

int backward(float grad, float* w0, float* w1, float* b)
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
    rocblas_operation transB = rocblas_operation_transpose;
    rocblas_int m = 2;
    rocblas_int n = 1;
    rocblas_int k = 128;
    float alpha = 1;

    float A[256] = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    };
    rocblas_int lda = 2;
    float B[128] = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    };

    for (int i = 0; i < 128; i++)
    {
        B[i] *= grad;
    }

    rocblas_int ldb = 1;
    float beta = 0;
    float C[2] = {
    	0, 0
    };
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

    /*
    printf("sgemm ");
    for (int i = 0; i < 2; i++)
    {
        printf("%f ", C[i] / 128);
    }
    printf("\n");
    */
    *w0 -= C[0] / 128 * 0.03;
    *w1 -= C[1] / 128 * 0.03;
    *b -= grad * 0.03;

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

    printf(" ########## start sgemm\n");

    // ~ ==============================
    float w0 = 1;
    float w1 = 1;
    float b = 1;
    float loss = 0;
    float grad = 6;

    ret_val = forward(w0, w1, b, &loss, &grad);
    if (ret_val != EXIT_SUCCESS)
    {
        printf("sgemm failure\n");
    }

    ret_val = backward(grad, &w0, &w1, &b);
    if (ret_val != EXIT_SUCCESS)
    {
        printf("sgemm failure\n");
    }
    printf("loss %f\n", loss);
    printf("grad %f\n", grad);
    printf("w0   %f\n", w0);
    printf("w1   %f\n", w1);
    printf("b    %f\n", b);

    // ~ ==============================

    ret_val = forward(w0, w1, b, &loss, &grad);
    if (ret_val != EXIT_SUCCESS)
    {
        printf("sgemm failure\n");
    }

    ret_val = backward(grad, &w0, &w1, &b);
    if (ret_val != EXIT_SUCCESS)
    {
        printf("sgemm failure\n");
    }
    printf("loss %f\n", loss);
    printf("grad %f\n", grad);
    printf("w0   %f\n", w0);
    printf("w1   %f\n", w1);
    printf("b    %f\n", b);

    // ~ ==============================

    ret_val = forward(w0, w1, b, &loss, &grad);
    if (ret_val != EXIT_SUCCESS)
    {
        printf("sgemm failure\n");
    }

    ret_val = backward(grad, &w0, &w1, &b);
    if (ret_val != EXIT_SUCCESS)
    {
        printf("sgemm failure\n");
    }
    printf("loss %f\n", loss);
    printf("grad %f\n", grad);
    printf("w0   %f\n", w0);
    printf("w1   %f\n", w1);
    printf("b    %f\n", b);

    // ~ ==============================

    ret_val = forward(w0, w1, b, &loss, &grad);
    if (ret_val != EXIT_SUCCESS)
    {
        printf("sgemm failure\n");
    }

    ret_val = backward(grad, &w0, &w1, &b);
    if (ret_val != EXIT_SUCCESS)
    {
        printf("sgemm failure\n");
    }
    printf("loss %f\n", loss);
    printf("grad %f\n", grad);
    printf("w0   %f\n", w0);
    printf("w1   %f\n", w1);
    printf("b    %f\n", b);

    // ~ ==============================

    ret_val = forward(w0, w1, b, &loss, &grad);
    if (ret_val != EXIT_SUCCESS)
    {
        printf("sgemm failure\n");
    }

    ret_val = backward(grad, &w0, &w1, &b);
    if (ret_val != EXIT_SUCCESS)
    {
        printf("sgemm failure\n");
    }
    printf("loss %f\n", loss);
    printf("grad %f\n", grad);
    printf("w0   %f\n", w0);
    printf("w1   %f\n", w1);
    printf("b    %f\n", b);

    printf(" ########## end   sgemm\n");

    return 0;

}

