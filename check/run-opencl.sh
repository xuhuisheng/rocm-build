
mkdir -p build

g++ -std=c++17 -o build/test_opencl src/test_opencl.cpp -g -lOpenCL -L/opt/rocm/opencl/lib -I/opt/rocm/opencl/include -O3

ROC_ENABLE_PRE_VEGA=1 ./build/test_opencl

