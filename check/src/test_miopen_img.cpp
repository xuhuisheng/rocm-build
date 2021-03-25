
#include <iostream>
#include <hip/hip_runtime.h>
#include <miopen/miopen.h>
#include "libbmp.h"

using namespace std;

#define CHECK_MIOPEN(cmd)                                                      \
  {                                                                            \
    miopenStatus_t err = (cmd);                                                \
    if (err != miopenStatusSuccess) {                                          \
      fprintf(stderr, "error: '%s'(%d) at %s:%d\n", miopenGetErrorString(err), \
              err, __FILE__, __LINE__);                                        \
      exit(EXIT_FAILURE);                                                      \
    }                                                                          \
  }

#define CHECK_HIP(cmd)                                                      \
  {                                                                         \
    hipError_t hip_error = (cmd);                                           \
    if (hip_error != hipSuccess) {                                          \
      fprintf(stderr, "error: '%s'(%d) at %s:%d\n",                         \
              hipGetErrorString(hip_error), hip_error, __FILE__, __LINE__); \
      exit(EXIT_FAILURE);                                                   \
    }                                                                       \
  }


// 偷懒写一个匿名全局类

// 全局数据
uchar3             *img;                             // 使用gpu的扩展类型(只读取RGB)
float3             *f_img; 
float3             *img_gpu;                         // 输入
float3             *conv_gpu;                        // 输出
float3             *kernel_gpu;                      // 卷积核

// 输入/输出文件名
const char *in_filename  = "gpu.bmp";
const char *out_filename = "gpu_out.bmp";

const int IMAGE_WIDTH = 410;
const int IMAGE_HEIGHT = 728;

// 打开图像
void read_bmp();                                     // 无参数，采用全局成员
// 保存图像
void save_bmp();
// 内存释放
void free_mem();
// Host <-> Device
void move_to_device();  
void move_to_host(); 
void create_kernel();
// cudnn卷积计算封装
void process_conv();

void test_copy_img_data();
void test_bmp();

int main(int argc, const char **argv)
{

    read_bmp();
    move_to_device();
    create_kernel();
    process_conv();
    move_to_host();
    // test_copy_img_data();
    save_bmp();
    free_mem();

    //test_bmp();
}

void process_conv()
{
    cout << "handle conv start" << endl;


  miopenHandle_t handle;
  CHECK_MIOPEN(miopenCreate(&handle));

  CHECK_MIOPEN(miopenEnableProfiling(handle, true));

  // input tensor
  const int in_shape[4] = {1, 3, IMAGE_HEIGHT, IMAGE_WIDTH};  // NCHW

  miopenTensorDescriptor_t in_desc;
  CHECK_MIOPEN(miopenCreateTensorDescriptor(&in_desc));
  CHECK_MIOPEN(miopenSet4dTensorDescriptor(in_desc, miopenFloat, in_shape[0],
                                           in_shape[1], in_shape[2],
                                           in_shape[3]));  // NCHW

  // filter tensor
  const int filt_shape[4] = {
    3, // out_shape[1]
    3, // in_shape[1]
    3, // height
    3  // width
  };   // KCHW

  miopenTensorDescriptor_t filt_desc;
  CHECK_MIOPEN(miopenCreateTensorDescriptor(&filt_desc));
  CHECK_MIOPEN(miopenSet4dTensorDescriptor(filt_desc, miopenFloat,
                                           filt_shape[0], filt_shape[1],
                                           filt_shape[2], filt_shape[3]));

  miopenConvolutionDescriptor_t conv_desc;
  CHECK_MIOPEN(miopenCreateConvolutionDescriptor(&conv_desc));

  const int pad_h = 1;
  const int pad_w = 1;
  const int stride_h = 1;
  const int stride_w = 1;
  const int dilation_h = 1;
  const int dilation_w = 1;

  CHECK_MIOPEN(miopenInitConvolutionDescriptor(conv_desc, miopenConvolution,
                                               pad_h, pad_w, stride_h, stride_w,
                                               dilation_h, dilation_w));

  // output
  int out_shape[4];  // NCHW

  CHECK_MIOPEN(miopenGetConvolutionForwardOutputDim(
      conv_desc, in_desc, filt_desc, &out_shape[0], &out_shape[1],
      &out_shape[2], &out_shape[3]));

  miopenTensorDescriptor_t out_desc;
  CHECK_MIOPEN(miopenCreateTensorDescriptor(&out_desc));
  CHECK_MIOPEN(miopenSet4dTensorDescriptor(out_desc, miopenFloat, out_shape[0],
                                           out_shape[1], out_shape[2],
                                           out_shape[3]));
std:cout << "out shape " << out_shape[0] << " " << out_shape[1] << " " << out_shape[2]
	    << " " << out_shape[3] << std::endl;
  // workspace
  size_t ws_size = 0;
  CHECK_MIOPEN(miopenConvolutionForwardGetWorkSpaceSize(
      handle, /* w */ filt_desc, /* x */ in_desc, conv_desc, /* y */ out_desc,
      &ws_size));
  std::cout << "ws_size = " << ws_size << "\n";

  size_t in_data_size = in_shape[0] * in_shape[1] * in_shape[2] * in_shape[3] / 3;
  size_t filt_data_size =
      filt_shape[0] * filt_shape[1] * filt_shape[2] * filt_shape[3] / 3;
  size_t out_data_size =
      out_shape[0] * out_shape[1] * out_shape[2] * out_shape[3] / 3;

  float3 *in_data = nullptr;
  CHECK_HIP(hipMalloc(&in_data, in_data_size * sizeof(float3)));

  float3 *filt_data = nullptr;
  CHECK_HIP(hipMalloc(&filt_data, filt_data_size * sizeof(float3)));

  float3 *out_data = nullptr;
  CHECK_HIP(hipMalloc(&out_data, out_data_size * sizeof(float3)));

  float3 *ws_data = nullptr;
  CHECK_HIP(hipMalloc(&ws_data, ws_size));

  // fill with dummy data.
  // std::vector<float> in_buf(in_data_size);
  // std::iota(in_buf.begin(), in_buf.end(), 0);
  // CHECK_HIP(hipMemcpy(in_data, in_buf.data(), in_data_size * sizeof(float),
  //                    hipMemcpyHostToDevice));

  // std::vector<float> filt_buf(filt_data_size);
  // std::iota(filt_buf.begin(), filt_buf.end(), 0);
  // CHECK_HIP(hipMemcpy(filt_data, filt_buf.data(),
  //                    filt_data_size * sizeof(float), hipMemcpyHostToDevice));

  miopenConvAlgoPerf_t perf{};
  int algo_count = 0;
  bool exhaustive_search = false;
  std::cout << "find conv algo" << std::endl;
  // CHECK_MIOPEN(miopenFindConvolutionForwardAlgorithm(
  //    handle, in_desc,
  //    /* ptr */ in_data, filt_desc, /* ptr */ filt_data, conv_desc, out_desc,
  //    /* ptr */ out_data, /* req algos*/ 1, &algo_count, &perf,
  //    /* ptr */ ws_data, ws_size, exhaustive_search));
  in_data = img_gpu;
  filt_data = kernel_gpu;
  CHECK_MIOPEN(miopenFindConvolutionForwardAlgorithm(
      handle, in_desc,
      /* ptr */ in_data, filt_desc, /* ptr */ filt_data, conv_desc, out_desc,
      /* ptr */ out_data, /* req algos*/ 1, &algo_count, &perf,
      /* ptr */ ws_data, ws_size, exhaustive_search));

  float alpha = 1.0f;
  float beta = 0.0f;
  CHECK_MIOPEN(miopenConvolutionForward(handle, &alpha, in_desc,
                                        /* ptr */ in_data, filt_desc,
                                        /* ptr */ filt_data, conv_desc,
                                        perf.fwd_algo, &beta, out_desc,
                                        out_data, ws_data, ws_size));

  float time = -1.0f;
  CHECK_MIOPEN(miopenGetKernelTime(handle, &time));
  std::cout << "time : " << time << "\n";

  // std::vector<float> out_buf(out_data_size);
  // CHECK_HIP(hipMemcpy(out_buf.data(), out_data, out_data_size * sizeof(float),
  //                    hipMemcpyDeviceToHost));

  //for (size_t i = 0; i < out_buf.size(); i++) {
  //  std::cout << "[" << i << "] = " << out_buf[i] << "\n";
  //}
  conv_gpu = out_data;

  //CHECK_HIP(hipFree(ws_data));
  //CHECK_HIP(hipFree(out_data));
  //CHECK_HIP(hipFree(filt_data));
  //CHECK_HIP(hipFree(in_data));

  CHECK_MIOPEN(miopenDestroyTensorDescriptor(out_desc));
  CHECK_MIOPEN(miopenDestroyTensorDescriptor(in_desc));
  CHECK_MIOPEN(miopenDestroyTensorDescriptor(filt_desc));

  CHECK_MIOPEN(miopenDestroyConvolutionDescriptor(conv_desc));

  CHECK_MIOPEN(miopenDestroy(handle));
}

void create_kernel()
{
    hipMalloc((void**) &kernel_gpu, 3 * 3 * 3 * sizeof(float3));   // 返回指针，则参数就需要二重指针。
    // 卷积核
    float3 data_kernel[] = {

        make_float3(0.0f, 0.0f, 0.0f), make_float3(1.0f, 1.0f, 1.0f), make_float3(-0.1f, 0.0f, 0.0f), 
        make_float3(0.0f, 0.0f, 0.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(0.0f, 0.0f, 0.0f), 
        make_float3(0.1f, 0.0f, 0.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(0.0f, 0.0f, 0.0f),
        make_float3(0.0f, 0.0f, 0.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(-0.1f, 0.0f, 0.0f), 
        make_float3(0.0f, 0.0f, 0.0f), make_float3(1.0f, 1.0f, 1.0f), make_float3(0.0f, 0.0f, 0.0f), 
        make_float3(0.1f, 0.0f, 0.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(0.0f, 0.0f, 0.0f),
        make_float3(0.0f, 0.0f, 0.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(-0.1f, 0.0f, 0.0f), 
        make_float3(0.0f, 0.0f, 0.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(0.0f, 0.0f, 0.0f), 
        make_float3(0.1f, 0.0f, 0.0f), make_float3(1.0f, 1.0f, 1.0f), make_float3(0.0f, 0.0f, 0.0f)
    };
    hipMemcpy((void*) kernel_gpu, (void*) data_kernel, 3 * 3 * 3 * sizeof(float3), hipMemcpyHostToDevice);
    /*
    hipMalloc((void**)&kernel_gpu, 1 * 1 * 1 * sizeof(float3));   // 返回指针，则参数就需要二重指针。
    float3 data_kernel[] = {
        make_float3(1.0f, 1.0f, 1.0f)
    };
    // 拷贝到device
    hipMemcpy((void*)kernel_gpu, (void*)data_kernel, 1 * 1 * 1 * sizeof(float3), hipMemcpyHostToDevice);
    */
}

void move_to_host()
{
    // 把选装后的图像拷贝到Host内存，用来保存到磁盘
    hipMemcpy((void*) f_img,
        (void*) conv_gpu,
        IMAGE_HEIGHT * IMAGE_WIDTH * sizeof(float3),
        hipMemcpyDeviceToHost
    );

    img = (uchar3 *) malloc(IMAGE_WIDTH * IMAGE_HEIGHT * sizeof(uchar3));
    // 循环把图像转换为uchar3
    for(int i = 0; i < IMAGE_HEIGHT * IMAGE_WIDTH; i++){
        img[i].x = (unsigned char) f_img[i].x;
        img[i].y = (unsigned char) f_img[i].y;
        img[i].z = (unsigned char) f_img[i].z;
    }
}

void move_to_device()
{
    // 分配GPU内存
    hipMalloc((void**) &img_gpu, IMAGE_HEIGHT * IMAGE_WIDTH * sizeof(float3));   // 返回指针，则参数就需要二重指针。
    // 拷贝数据
    hipMemcpy((void*) img_gpu, (void*) f_img, IMAGE_HEIGHT * IMAGE_WIDTH * sizeof(float3), hipMemcpyHostToDevice);

    // 用来存储卷积计算输出
    hipMalloc((void**)&conv_gpu, IMAGE_HEIGHT * IMAGE_WIDTH * sizeof(float3));   // 返回指针，则参数就需要二重指针。
    // 初始化为指定为0
    hipMemset(conv_gpu, 0, IMAGE_HEIGHT * IMAGE_WIDTH * sizeof(float3));
}

void read_bmp()
{
    bmp_img img_t;
    bmp_img_init_df(&img_t, IMAGE_WIDTH, IMAGE_HEIGHT);

    bmp_img_read(&img_t, in_filename);

    //header.height = IMAGE_HEIGHT;
    //header.width = IMAGE_WIDTH;

    f_img = (float3 *) malloc(IMAGE_WIDTH * IMAGE_HEIGHT * sizeof(float3));

    for (size_t y = 0; y < IMAGE_HEIGHT; y++)
    {
        for (size_t x = 0; x < IMAGE_WIDTH; x++)
        {
            // printf("(%d, %d) (%d, %d, %d)\n", x, y, img.img_pixels[x][y].blue, img.img_pixels[x][y].green, img.img_pixels[x][y].red);
            f_img[y * IMAGE_WIDTH + x].x = (float) img_t.img_pixels[y][x].red;
            f_img[y * IMAGE_WIDTH + x].y = (float) img_t.img_pixels[y][x].green;
            f_img[y * IMAGE_WIDTH + x].z = (float) img_t.img_pixels[y][x].blue;
        }
    }
    bmp_img_free(&img_t);
}

void save_bmp()
{
    printf("save bmp start\n");

    bmp_img img_t;
    bmp_img_init_df(&img_t, IMAGE_WIDTH, IMAGE_HEIGHT);

    for (size_t y = 0; y < IMAGE_HEIGHT; y++)
    {
        for (size_t x = 0; x < IMAGE_WIDTH; x++)
        {
            /*
            bmp_pixel_init(&img_t.img_pixels[y][x],
                img[y * IMAGE_WIDTH + x].x,
                img[y * IMAGE_WIDTH + x].y,
                img[y * IMAGE_WIDTH + x].z);
            */

            img_t.img_pixels[y][x].red   = (char) f_img[y * IMAGE_WIDTH + x].x;
            img_t.img_pixels[y][x].green = (char) f_img[y * IMAGE_WIDTH + x].y;
            img_t.img_pixels[y][x].blue  = (char) f_img[y * IMAGE_WIDTH + x].z;
        }
    }

    bmp_img_write(&img_t, out_filename);
    bmp_img_free(&img_t);

    printf("save bmp end\n");
}

void free_mem()
{
    printf("free mem start\n");

    /* 释放Host与Device内存 */
    free(img); // 直接释放（不需要指定大小，malloc系列函数有内部变量管理分配的内存）
    hipFree(img_gpu);
    hipFree(conv_gpu);
    hipFree(kernel_gpu);

    printf("free mem end\n");    
}

void test_copy_img_data()
{
    printf("test copy img data start\n");

    img = (uchar3 *) malloc(IMAGE_WIDTH * IMAGE_HEIGHT * sizeof(uchar3));
    // 循环把图像转换为uchar3
    for(int i = 0; i < IMAGE_WIDTH * IMAGE_HEIGHT; i++){
        img[i].x = (unsigned char) f_img[i].x;
        img[i].y = (unsigned char) f_img[i].y;
        img[i].z = (unsigned char) f_img[i].z;
    }

    printf("test copy img data end\n");
}

void test_bmp()
{
    bmp_img img_t;
    bmp_img_init_df(&img_t, IMAGE_WIDTH, IMAGE_HEIGHT);

    bmp_img_read(&img_t, in_filename);
    
    bmp_img_write(&img_t, out_filename);
    bmp_img_free(&img_t);

}


