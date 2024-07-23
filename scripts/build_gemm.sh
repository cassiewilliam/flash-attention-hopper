#!/bin/bash
mkdir -p bin

nvcc -g \
     -forward-unknown-to-host-compiler \
     -DCUTLASS_ENABLE_CUBLAS=1 \
     -I./include \
     -I./lib/  \
     -I./3rdparty/cutlass/include \
     -I./3rdparty/cutlass/examples/common \
     -I"/usr/local/cuda/include" \
     -I/include \
     -I/examples \
     -I./3rdparty/cutlass/tools/util/include \
     -O3 -DNDEBUG \
     --generate-code=arch=compute_90a,code=[sm_90a] \
     --generate-code=arch=compute_90a,code=[compute_90a] \
     -Xcompiler=-fPIE -DCUTLASS_ENABLE_TENSOR_CORE_MMA=1 \
     --expt-relaxed-constexpr \
     -DCUTLASS_TEST_LEVEL=0 \
     -DCUTLASS_TEST_ENABLE_CACHED_RESULTS=1 \
     -DCUTLASS_CONV_UNIT_TEST_RIGOROUS_SIZE_ENABLED=1 \
     -DCUTLASS_DEBUG_TRACE_LEVEL=0 \
     -Xcompiler=-Wconversion \
     -Xcompiler=-fno-strict-aliasing \
     -std=c++17 \
     -MD -MT -MF -x cu \
     ./src/cute-gemm-tma-gma/gemm.cu \
     -Wl,-rpath,'/usr/local/cuda/lib64' \
     -Wl,-rpath,'/usr/local/cuda/lib' \
     -lcuda  -lcudadevrt -lcudart_static \
     -lcublas -lrt -lpthread -ldl -o bin/cute_tma_gma_gemm
