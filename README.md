# nyu-gpu-lab-1

NYU GPU Lab 1: Implement a vector processor in CUDA.

## Getting Started

### Switch Modules on CIMS Machines

```bash
module load cmake-3
module load cuda-11.4
module load gcc-9.2

```

### Build

```bash
mkdir -p cmake-build-release
cmake -B cmake-build-release -DCMAKE_BUILD_TYPE=Release
cmake --build cmake-build-release --config Release
```
