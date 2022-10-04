cmake_minimum_required(VERSION 3.0)
project(vectors CUDA)

set(CMAKE_CUDA_STANDARD 17)

add_executable(vectors vectors.cu)

set_target_properties(vectors PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)
