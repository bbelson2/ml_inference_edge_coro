#!/bin/bash

# Note - this runs leaf over all models 

# Shell script to iterate the chain test, varying task count and then width.
# Command line is e.g.:
# ./leaf.out -e 10 -b 100 -c 4 -s 256 -n 200 -d -p 1 -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o - -w -x -g -f >> ../results/../results/${fn}_dropout.csv
# Note that -x is used only on the first line of each file, so that only one header line appears. 

short=-d
repeats=100
epochs=10
batch=100

plat=aw
stats_fn=stats_all_aw_145.csv
tmp_fn_root=stats_145

echo "platcode,op,repeats,epochs,batch,output_dims,output_model,tasks,height,width,unitsize,lines,coro-no-prefetch-ratio-mean,coro-no-prefetch-ratio-sd,coro-prefetch-ratio-mean,coro-prefetch-ratio-sd" > ../results/v2/${stats_fn}

op=leaf
exe=leaf
dims=1
unitsize=2

for height in 400 800
do
  for tasks in 4 8
  do
    for width in 164 168 172
    do
      tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
      echo Writing ${tmp_fn}
      ../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ../results/v2/${tmp_fn}
      python3 ./stats_from.py ../results/v2/${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ../results/v2/${stats_fn}
    done
  done
done

op=svm
exe=svm
dims=1
unitsize=2

for height in 200 400
do
  for tasks in 2 4
  do
    for width in 578 582 586
    do
      tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
      echo Writing ${tmp_fn}
      ../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ../results/v2/${tmp_fn}
      python3 ./stats_from.py ../results/v2/${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ../results/v2/${stats_fn}
    done
  done
done

op=svm32
exe=svm32
dims=1
unitsize=4

for height in 200 400
do
  for tasks in 2 4
  do
    for width in 190 194 198
    do
      tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
      echo Writing ${tmp_fn}
      ../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ../results/v2/${tmp_fn}
      python3 ./stats_from.py ../results/v2/${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ../results/v2/${stats_fn}
    done
  done
done

op=svmf32
exe=svmf32
dims=1
unitsize=4

for height in 100 200
do
  for tasks in 2 4
  do
    for width in 320 324 328
    do
      tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
      echo Writing ${tmp_fn}
      ../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ../results/v2/${tmp_fn}
      python3 ./stats_from.py ../results/v2/${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ../results/v2/${stats_fn}
    done
  done
done

op=svmf64
exe=svmf64
dims=1
unitsize=8

for height in 400 800
do
  for tasks in 2 4
  do
    for width in 92 96 100
    do
      tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
      echo Writing ${tmp_fn}
      ../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ../results/v2/${tmp_fn}
      python3 ./stats_from.py ../results/v2/${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ../results/v2/${stats_fn}
    done
  done
done

op=norm
exe=norm
dims=2
unitsize=2

for height in 80 160
do
  for tasks in 4 6
  do
    for width in 404 408 412
    do
      tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
      echo Writing ${tmp_fn}
      ../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ../results/v2/${tmp_fn}
      python3 ./stats_from.py ../results/v2/${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ../results/v2/${stats_fn}
    done
  done
done

op=norm32
exe=norm32
dims=2
unitsize=4

for height in 100 200
do
  for tasks in 4 8
  do
    for width in 92 96 100
    do
      tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
      echo Writing ${tmp_fn}
      ../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ../results/v2/${tmp_fn}
      python3 ./stats_from.py ../results/v2/${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ../results/v2/${stats_fn}
    done
  done
done

op=normf32
exe=normf32
dims=2
unitsize=4

for height in 100 200
do
  for tasks in 4 8
  do
    for width in 160 164 168
    do
      tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
      echo Writing ${tmp_fn}
      ../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ../results/v2/${tmp_fn}
      python3 ./stats_from.py ../results/v2/${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ../results/v2/${stats_fn}
    done
  done
done

op=normf64
exe=normf64
dims=2
unitsize=8

for height in 100 200
do
  for tasks in 4 8
  do
    for width in 80 84 88
    do
      tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
      echo Writing ${tmp_fn}
      ../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ../results/v2/${tmp_fn}
      python3 ./stats_from.py ../results/v2/${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ../results/v2/${stats_fn}
    done
  done
done

op=cnn
exe=cnn
dims=2
unitsize=2

for height in 100 200
do
  for tasks in 2 4
  do
    for width in 310 314 318
    do
      tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
      echo Writing ${tmp_fn}
      ../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ../results/v2/${tmp_fn}
      python3 ./stats_from.py ../results/v2/${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ../results/v2/${stats_fn}
    done
  done
done

op=cnn32
exe=cnn32
dims=2
unitsize=4

for height in 200 400
do
  for tasks in 2 4
  do
    for width in 82 86 90
    do
      tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
      echo Writing ${tmp_fn}
      ../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ../results/v2/${tmp_fn}
      python3 ./stats_from.py ../results/v2/${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ../results/v2/${stats_fn}
    done
  done
done

op=cnnf32
exe=cnnf32
dims=2
unitsize=4

for height in 200 400
do
  for tasks in 2 4
  do
    for width in 170 174 178
    do
      tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
      echo Writing ${tmp_fn}
      ../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ../results/v2/${tmp_fn}
      python3 ./stats_from.py ../results/v2/${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ../results/v2/${stats_fn}
    done
  done
done

op=cnnf64
exe=cnnf64
dims=2
unitsize=8

for height in 200 400
do
  for tasks in 2 4
  do
    for width in 82 86 90
    do
      tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
      echo Writing ${tmp_fn}
      ../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ../results/v2/${tmp_fn}
      python3 ./stats_from.py ../results/v2/${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ../results/v2/${stats_fn}
    done
  done
done

