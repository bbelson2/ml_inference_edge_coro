# ML_INFERENCE_EDGE_CORO

Contains code used for paper "Speeding up Machine Learning Inference on Edge Devices by Improving Memory
Access Patterns using Coroutines" by B. Belson & B. Philippa 2022

License - see LICENSE file in this repo.

## Requirements

- Linux
- GCC 10 or above
- LLVM/Clang 12 or above
- Support for PERF 5.10 or above
- Python 3

## ARM A72 setup

### Distribution

https://downloads.raspberrypi.org/raspios_full_armhf/images/raspios_full_armhf-2021-03-25/2021-03-04-raspios-buster-armhf-full.zip

### GCC 10.2.0

https://sourceforge.net/projects/raspberry-pi-cross-compilers/

### LLVM

## Dell Alienware setup

### Distribution

https://releases.ubuntu.com/18.04/ubuntu-18.04.6-desktop-amd64.iso

### GCC

```
sudo add-apt-repository ppa:ubuntu-toolchain-r/ppa
sudo apt update
sudo apt install g++-10
```

### LLVM

```
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
apt-get install clang-11 lldb-11 lld-11
apt-get install libc++-11-dev libc++abi-11-dev
```
## Dell Optiplex setup

### Distribution

http://old-releases.ubuntu.com/releases/20.04.1/ubuntu-20.04-beta-desktop-amd64.iso

### GCC

```bash
sudo apt update && sudo apt dist-upgrade
sudo apt-get install build-essential gawk gcc g++ gfortran git texinfo bison  wget bzip2 libncurses-dev libssl-dev openssl zlib1g-dev
sudo apt install g++-10
```

### LLVM

```
printf "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-12 main" |sudo tee /etc/apt/sources.list.d/llvm-toolchain-xenial-12.list
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key |sudo apt-key add -
sudo apt update
sudo apt install llvm-12 --install-suggests
sudo apt install clang-12
sudo apt-get install libc++-12-dev
sudo apt-get install libc++abi-12-dev
```

### perf

```bash
sudo apt install linux-tools-common
sudo apt install linux-tools-5.11.0-41-generic
sudo sh -c 'echo -1 >/proc/sys/kernel/perf_event_paranoid'
```

## Build

```bash
cd v2
make TOOLSET=gcc
make TOOLSET=llvm
```

## Tests

See the test scripts in `v2_scripts`.

Script names contain particles as detailed below:

| Particle | Section | Meaning |
|---|---|---|
| cnn | Model | CNN fixed-point 16-bit |
| cnn32 | Model | CNN fixed-point 32-bit |
| cnnf32 | Model | CNN floating-point 32-bit |
| cnnf64 | Model | CNN floating-point 64-bit |
| leaf | Model | B+ Tree with fully random leaf layout |
| rndleaf | Model | B+ Tree with varied randomness in leaf layout |
| norm | Model | Normalisation fixed-point 16-bit |
| norm32 | Model | Normalisation fixed-point 32-bit |
| normf32 | Model | Normalisation floating-point 32-bit |
| normf64 | Model | Normalisation floating-point 64-bit |
| svm | Model | SVM fixed-point 16-bit |
| svm32 | Model | SVM fixed-point 32-bit |
| svmf32 | Model | SVM floating-point 32-bit |
| svmf64 | Model | SVM floating-point 64-bit |
| aw | Platform | Alienware |
| op | Platform | Optoplex |
| pi | Platform | Raspberry Pi 4 |
| long | Test | Longer test over large range and/or lower granularity |
| rpt | Test | Repeat of earlier test to confirm unexpected outcomes |
| stats | Test | All models in single run |
| gcc | Toolchain | GCC |
| llvm | Toolchain | Clang/LLVM |

Results are in `results/v2`.

## Further results

If you create new results of interest or if you have any questions, please feel free to email bruce.belson-at-my.jcu.edu.au.

