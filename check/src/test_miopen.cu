
#include <iostream>
#include <cuda.h>
#include <cudnn.h>

// 结构体定义
#pragma pack(1)
struct img_header{
    // 文件头
    char                  magic[2];                  // 魔法字
    unsigned int          file_size;                 // 文件大小
    unsigned char         reserve1[4];               // 跳4字节
    unsigned int          data_off;                  // 数据区开始位置
    // 信息头
    unsigned char         reserve2[4];               // 跳4字节
    int                   width;                     // 图像宽度
    int                   height;                    // 图像高度
    unsigned char         reserve3[2];               // 跳2字节
    unsigned short int    bit_count;                 // 图像位数1，4，8，16，24，32
    unsigned char         reserve4[24];              // 跳24字节
};


// 偷懒写一个匿名全局类

// 全局数据
struct img_header  header;
uchar3             *img;                             // 使用gpu的扩展类型(只读取RGB)
float3             *f_img; 
float3             *img_gpu;                         // 输入
float3             *conv_gpu;                        // 输出
float3             *kernel_gpu;                      // 卷积核

// 输入/输出文件名
const char *in_filename  = "gpu.bmp";
const char *out_filename = "gpu_out.bmp";

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
void cudnn_conv();

int main(int argc, const char **argv){
    read_bmp();
    move_to_device();
    create_kernel();
    cudnn_conv();
    move_to_host();
    save_bmp();
    free_mem();
}

void cudnn_conv(){
    // 返回状态
    cudnnStatus_t status;
    //cudnn句柄
    cudnnHandle_t h_cudnn;
    // 创建cuDNN上下文句柄
    cudnnCreate(&h_cudnn);
    // =================================================输入输出张量
    // 1. 定义一个张量对象
    cudnnTensorDescriptor_t  ts_in, ts_out;    
    // 2. 创建输入张量
    status = cudnnCreateTensorDescriptor(&ts_in);
    if(CUDNN_STATUS_SUCCESS == status){
        std::cout << "创建输入张量成功!" << std::endl;
    }
    // 3. 设置输入张量数据
    status = cudnnSetTensor4dDescriptor(
        ts_in,                            // 张量对象
        CUDNN_TENSOR_NHWC,                // 张量的数据布局
        CUDNN_DATA_FLOAT,                 // 张量的数据类型
        1,                                // 图像数量
        3,                                // 图像通道
        1080,                             // 图像高度
        1920                              // 图像宽度
    );
    if(CUDNN_STATUS_SUCCESS == status) std::cout << "创建输出张量成功!" << std::endl;
    // 类似创建输出的张量
    cudnnCreateTensorDescriptor(&ts_out);
    status = cudnnSetTensor4dDescriptor(ts_out, CUDNN_TENSOR_NHWC, CUDNN_DATA_FLOAT, 1, 3, 1080, 1920);
    if(CUDNN_STATUS_SUCCESS == status) std::cout << "设置输出张量成功!" << std::endl;
    // =================================================滤波核
    cudnnFilterDescriptor_t kernel;
    cudnnCreateFilterDescriptor(&kernel);
    status = cudnnSetFilter4dDescriptor(kernel, CUDNN_DATA_FLOAT, CUDNN_TENSOR_NHWC, 3, 3, 3, 3);
    if(CUDNN_STATUS_SUCCESS == status) std::cout << "创建卷积核张量成功!" << std::endl;
    // =================================================卷积描述
    cudnnConvolutionDescriptor_t conv;
    status = cudnnCreateConvolutionDescriptor(&conv);
    if(CUDNN_STATUS_SUCCESS == status) std::cout << "创建卷积成功!" << std::endl;
    status = cudnnSetConvolution2dDescriptor(conv, 1, 1, 1, 1, 1, 1, CUDNN_CROSS_CORRELATION, CUDNN_DATA_FLOAT);
    if(CUDNN_STATUS_SUCCESS == status) std::cout << "设置卷积成功!" << std::endl;
    // =================================================卷积算法
    cudnnConvolutionFwdAlgo_t algo;
    status = cudnnGetConvolutionForwardAlgorithm(h_cudnn, ts_in, kernel, conv, ts_out, CUDNN_CONVOLUTION_FWD_PREFER_FASTEST, 0, &algo);
    if(CUDNN_STATUS_SUCCESS == status) std::cout << "获取算法成功!" << std::endl;
    // =================================================工作区
    size_t workspace_size = 0;
    status = cudnnGetConvolutionForwardWorkspaceSize(h_cudnn, ts_in, kernel, conv, ts_out, algo, &workspace_size);
    if(CUDNN_STATUS_SUCCESS == status) std::cout << "获取工作空间大小成功!" << std::endl;
    std::cout << "卷积计算空间大小" << workspace_size << std::endl;
    // 分配工作区空间
    void * workspace;
    cudaMalloc(&workspace, workspace_size);
    // =================================================线性因子
    float alpha = 1.0f;
    float beta  = -100.0f;
    // =================================================数据准备
    // 见全局函数的实现。
    // =================================================卷积执行
    status =  cudnnConvolutionForward(
        h_cudnn,
        &alpha,
        ts_in,
        img_gpu,                         // 输入
        kernel, 
        kernel_gpu,                      // 核
        conv,
        algo,
        workspace,
        workspace_size,
        &beta,
        ts_out,
        conv_gpu                         // 输出
    );
    if (status == CUDNN_STATUS_SUCCESS) {
        std::cout << "卷积计算成功！" << std::endl; 
    }else{
        std::cout << "卷积计算失败！" << std::endl; 
    }
    // 释放cuDNN
    cudnnDestroy(h_cudnn);

}

void create_kernel(){
    cudaMalloc((void**)&kernel_gpu, 3 * 3 * 3 * sizeof(float3));   // 返回指针，则参数就需要二重指针。
    // 卷积核
    float3 data_kernel[] = {
        make_float3(-1.0f, -1.0f, -1.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(1.0f, 1.0f, 1.0f), 
        make_float3(-2.0f, -2.0f, -2.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(2.0f, 2.0f, 2.0f), 
        make_float3(-1.0f, -1.0f, -1.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(1.0f, 1.0f, 1.0f),
        make_float3(-1.0f, -1.0f, -1.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(1.0f, 1.0f, 1.0f), 
        make_float3(-2.0f, -2.0f, -2.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(2.0f, 2.0f, 2.0f), 
        make_float3(-1.0f, -1.0f, -1.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(1.0f, 1.0f, 1.0f),
        make_float3(-1.0f, -1.0f, -1.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(1.0f, 1.0f, 1.0f), 
        make_float3(-2.0f, -2.0f, -2.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(2.0f, 2.0f, 2.0f), 
        make_float3(-1.0f, -1.0f, -1.0f), make_float3(0.0f, 0.0f, 0.0f), make_float3(1.0f, 1.0f, 1.0f)
    };
    // 拷贝到device
    cudaMemcpy((void*)kernel_gpu, (void*)data_kernel, 3 * 3 * 3 * sizeof(float3), cudaMemcpyHostToDevice);

}

void move_to_host(){
    // 把选装后的图像拷贝到Host内存，用来保存到磁盘
    cudaMemcpy((void*)f_img, (void*)conv_gpu, header.height * header.width * sizeof(float3), cudaMemcpyDeviceToHost);
    // 循环把图像转换为uchar3
    for(int i = 0; i < header.height * header.width; i++){
        img[i].x = (unsigned char)f_img[i].x;
        img[i].y = (unsigned char)f_img[i].y;
        img[i].z = (unsigned char)f_img[i].z;
    }
}

void move_to_device(){
    // 分配GPU内存
    cudaMalloc((void**)&img_gpu, header.height * header.width * sizeof(float3));   // 返回指针，则参数就需要二重指针。
    // 拷贝数据
    cudaMemcpy((void*)img_gpu, (void*)f_img,  header.height * header.width * sizeof(float3), cudaMemcpyHostToDevice);

    // 用来存储卷积计算输出
    cudaMalloc((void**)&conv_gpu, header.height * header.width * sizeof(float3));   // 返回指针，则参数就需要二重指针。
    // 初始化为指定为0
    cudaMemset(conv_gpu, 0, header.height * header.width * sizeof(float3));
}

void read_bmp(){ 
    /* 读取头，分配内存，读取数据，这里数据采用了一维数组，使用的时候，需要转换处理下。*/
    FILE *file = fopen(in_filename, "rb");
    // 读取头
    size_t n_bytes = fread(&header, 1, 54, file); 
    
    // 计算读取的大大小，并分配空间，并读取。
    header.height = header.height >= 0? header.height : -header.height;
    img = (uchar3 *)malloc(header.height * header.width * sizeof(uchar3));
    f_img = (float3 *)malloc(header.height * header.width * sizeof(float3));
    uchar4 buffer;  
    // 循环只读取RGB
    for(int i = 0; i < header.height * header.width; i++){
        fread((void*)&buffer, sizeof(uchar4), 1, file);
        memcpy(&img[i], &buffer, sizeof(uchar3));
        f_img[i].x = (float)buffer.x;
        f_img[i].y = (float)buffer.y;
        f_img[i].z = (float)buffer.z;
    } 

    fclose(file); // 关闭文件
    
}

void save_bmp(){
    /* 使用与读取一样的头信息保存图像 */
    FILE *file = fopen(out_filename, "wb");
    // 写头
    header.bit_count = 24;    //修改图像的位数
    header.file_size = 54 + header.height * header.width * sizeof(uchar3);   // 修改文件大小
    header.height = -header.height;
    size_t n_bytes = fwrite(&header, 1, 54, file);
    header.height = -header.height;
    // 写图像数据
    n_bytes = fwrite(img, sizeof(uchar3), header.height * header.width, file);
    // 关闭文件
    fclose(file);
}

void free_mem(){
    /* 释放Host与Device内存 */
    free(img); // 直接释放（不需要指定大小，malloc系列函数有内部变量管理分配的内存）
    cudaFree(img_gpu);
    cudaFree(conv_gpu);
    cudaFree(kernel_gpu);
}


