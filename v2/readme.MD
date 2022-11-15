# v2 

## Exploratory command lines

```bash
sudo ../output/gcc/leaf.out -e 10 -b 100 -c 2 -s 256 -n 200 -p 1 -o - -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -f 
sudo ../output/gcc/svm.out -e 10 -b 100 -c 2 -s 256 -n 200 -p 1 -o - -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -f 
sudo ../output/gcc/svm32.out -e 10 -b 100 -c 2 -s 128 -n 200 -p 1 -o - -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -f 
sudo ../output/gcc/visit.out -e 10 -b 100 -c 2 -s 256 -n 200 -p 1 -o - -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -f 
sudo ../output/gcc/norm.out -e 10 -b 100 -c 2 -s 256 -n 200 -p 2 -o - -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -f 
sudo ../output/gcc/norm32.out -e 10 -b 100 -c 2 -s 256 -n 200 -p 2 -o - -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -f 
```


## Specific outcomes

```
sudo ../output/llvm/cnn.out -e 2 -b 10 -c 2 -s 256 -n 202 -p 2 -o - -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -f

test,cpu_cycles,instructions,d_cache_reads,d_cache_misses
control,5591440,18978208,172581,55581
managed-no-prefetch,5000686,16904566,179727,53226
managed-prefetch,5025903,17116629,160063,51034
proto-no-prefetch,5023453,17013308,179991,53308
proto-prefetch,5003720,17247348,157647,52677
coro-no-prefetch,5009591,17068205,178553,54218
coro-prefetch,5015928,17274237,157934,53727

sudo ../output/gcc/cnn.out -e 2 -b 10 -c 2 -s 256 -n 202 -p 2 -o - -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -f

test,cpu_cycles,instructions,d_cache_reads,d_cache_misses
control,8555734,21657725,172419,57120
managed-no-prefetch,8599486,21523957,177656,57056
managed-prefetch,8683986,22063281,163966,52667
proto-no-prefetch,8663378,21963317,182473,55015
proto-prefetch,8715135,22496597,163082,54186
coro-no-prefetch,8691370,22015949,184035,55353
coro-prefetch,8746710,22549119,163136,55596
```
