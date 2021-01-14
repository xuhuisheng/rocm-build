
#include <array>
#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <numeric>
#include <vector>

#include <miopen/miopen.h>
#include <miopen/version.h>

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

int main(int argc, char **argv) {
  std::cout << "MIOPEN_VERSION_MAJOR:" << MIOPEN_VERSION_MAJOR << std::endl;
  std::cout << "MIOPEN_VERSION_MINOR:" << MIOPEN_VERSION_MINOR << std::endl;
  std::cout << "MIOPEN_VERSION_PATCH:" << MIOPEN_VERSION_PATCH << std::endl;

  miopenHandle_t handle;
  CHECK_MIOPEN(miopenCreate(&handle));

  CHECK_MIOPEN(miopenEnableProfiling(handle, true));

  // input tensor
  const int in_shape[4] = {1, 1, 5, 5};  // NCHW

  miopenTensorDescriptor_t in_desc;
  CHECK_MIOPEN(miopenCreateTensorDescriptor(&in_desc));
  CHECK_MIOPEN(miopenSet4dTensorDescriptor(in_desc, miopenFloat, in_shape[0],
                                           in_shape[1], in_shape[2],
                                           in_shape[3]));  // NCHW

  // filter tensor
  const int filt_shape[4] = {1, 1, 2, 2};  // KCHW

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

  // workspace
  size_t ws_size = 0;
  CHECK_MIOPEN(miopenConvolutionForwardGetWorkSpaceSize(
      handle, /* w */ filt_desc, /* x */ in_desc, conv_desc, /* y */ out_desc,
      &ws_size));
  std::cout << "ws_size = " << ws_size << "\n";

  size_t in_data_size = in_shape[0] * in_shape[1] * in_shape[2] * in_shape[3];
  size_t filt_data_size =
      filt_shape[0] * filt_shape[1] * filt_shape[2] * filt_shape[3];
  size_t out_data_size =
      out_shape[0] * out_shape[1] * out_shape[2] * out_shape[3];

  float *in_data = nullptr;
  CHECK_HIP(hipMalloc(&in_data, in_data_size * sizeof(float)));

  float *filt_data = nullptr;
  CHECK_HIP(hipMalloc(&filt_data, filt_data_size * sizeof(float)));

  float *out_data = nullptr;
  CHECK_HIP(hipMalloc(&out_data, out_data_size * sizeof(float)));

  float *ws_data = nullptr;
  CHECK_HIP(hipMalloc(&ws_data, ws_size));

  // fill with dummy data.
  std::vector<float> in_buf(in_data_size);
  std::iota(in_buf.begin(), in_buf.end(), 0);
  CHECK_HIP(hipMemcpy(in_data, in_buf.data(), in_data_size * sizeof(float),
                      hipMemcpyHostToDevice));

  std::vector<float> filt_buf(filt_data_size);
  std::iota(filt_buf.begin(), filt_buf.end(), 0);
  CHECK_HIP(hipMemcpy(filt_data, filt_buf.data(),
                      filt_data_size * sizeof(float), hipMemcpyHostToDevice));

  miopenConvAlgoPerf_t perf{};
  int algo_count = 0;
  bool exhaustive_search = false;
  std::cout << "find conv algo" << std::endl;
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

  std::vector<float> out_buf(out_data_size);
  CHECK_HIP(hipMemcpy(out_buf.data(), out_data, out_data_size * sizeof(float),
                      hipMemcpyDeviceToHost));

  for (size_t i = 0; i < out_buf.size(); i++) {
    std::cout << "[" << i << "] = " << out_buf[i] << "\n";
  }

  CHECK_HIP(hipFree(ws_data));
  CHECK_HIP(hipFree(out_data));
  CHECK_HIP(hipFree(filt_data));
  CHECK_HIP(hipFree(in_data));

  CHECK_MIOPEN(miopenDestroyTensorDescriptor(out_desc));
  CHECK_MIOPEN(miopenDestroyTensorDescriptor(in_desc));
  CHECK_MIOPEN(miopenDestroyTensorDescriptor(filt_desc));

  CHECK_MIOPEN(miopenDestroyConvolutionDescriptor(conv_desc));

  CHECK_MIOPEN(miopenDestroy(handle));

  return EXIT_SUCCESS;
}
