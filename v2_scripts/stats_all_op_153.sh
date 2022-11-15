#!/bin/bash

# Shell script to run all tests repeatedly, using task count, height and width of best-performing cases.
# A Python script is then used to calculate the standard deviation of the results.

# Settings shared by all tests on all platforms
short=-d
repeats=100
epochs=10
batch=100
out_dir=../results/v2/

# Settings for this platform
plat=op
stats_fn=stats_all_op_153.csv
tmp_fn_root=stats_153

echo "platcode,op,repeats,epochs,batch,output_dims,output_model,tasks,height,width,unitsize,lines,coro-no-prefetch-ratio-mean,coro-no-prefetch-ratio-sd,coro-prefetch-ratio-mean,coro-prefetch-ratio-sd" > ${out_dir}${stats_fn}

# B+ Tree

op=leaf
exe=leaf
dims=1
unitsize=2

height=800
tasks=4
width=200

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=800
tasks=4
width=168

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# SVM

op=svm
exe=svm
dims=1
unitsize=2

height=200
tasks=6
width=938

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=400
tasks=2
width=514

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# SVM32

op=svm32
exe=svm32
dims=1
unitsize=4

height=100
tasks=8
width=354

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=800
tasks=2
width=170

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# SVM Float

op=svmf32
exe=svmf32
dims=1
unitsize=4

height=100
tasks=2
width=512

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=800
tasks=2
width=320

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# SVM double

op=svmf64
exe=svmf64
dims=1
unitsize=8

height=200
tasks=2
width=512

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=800
tasks=4
width=52

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# Norm

op=norm
exe=norm
dims=2
unitsize=2

height=40
tasks=4
width=656

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=100
tasks=4
width=152

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# Norm 32

op=norm32
exe=norm32
dims=2
unitsize=4

height=40
tasks=6
width=852

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=40
tasks=6
width=852

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# Norm float

op=normf32
exe=normf32
dims=2
unitsize=4

height=80
tasks=2
width=484

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=200
tasks=4
width=124

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# Norm double

op=normf64
exe=normf64
dims=2
unitsize=8

height=200
tasks=2
width=72

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=200
tasks=4
width=60

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# CNN

op=cnn
exe=cnn
dims=2
unitsize=2

height=200
tasks=8
width=114

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=200
tasks=8
width=114

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# CNN 32

op=cnn32
exe=cnn32
dims=2
unitsize=4

height=400
tasks=4
width=674

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=400
tasks=2
width=206

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# CNN float

op=cnnf32
exe=cnnf32
dims=2
unitsize=4

height=100
tasks=2
width=774

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=400
tasks=4
width=166

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# CNN double

op=cnnf64
exe=cnnf64
dims=2
unitsize=8

height=100
tasks=2
width=474

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=400
tasks=2
width=70

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

echo !!COMPLETE!!
