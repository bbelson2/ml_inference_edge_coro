#!/bin/bash

# Changes from 148 to 152 - added -f, based run off the parameters for the best unsmoothed results,
# rather than smoothed

# Changes in 155 - changed batch & epochs to be in line with original runs

# Changes in 158 - unique names for output files (_0/_1 suffix)

# Changes in 161 - Selected params based on chart inspection (exclding outliers)

# Shell script to run all tests repeatedly, using task count, height and width of best-performing cases.
# A Python script is then used to calculate the standard deviation of the results.

# Settings shared by all tests on all platforms
short=-d
repeats=100
epochs=10
batch=100
out_dir=../results/v2/

# Settings for this platform
plat=aw
stats_fn=stats_all_aw_161.csv
tmp_fn_root=stats_161

echo "platcode,op,repeats,epochs,batch,output_dims,output_model,tasks,height,width,unitsize,lines,coro-no-prefetch-ratio-mean,coro-no-prefetch-ratio-sd,coro-prefetch-ratio-mean,coro-prefetch-ratio-sd" > ${out_dir}${stats_fn}

# B+ Tree

op=leaf
exe=leaf
dims=1
unitsize=2
epochs=10
batch=100

height=800
tasks=4
width=280

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_0.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=800
tasks=4
width=336

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_1.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# SVM

op=svm
exe=svm
dims=1
unitsize=2
epochs=2
batch=10

height=400
tasks=2
width=590

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_0.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=400
tasks=2
width=942

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_1.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# SVM32

op=svm32
exe=svm32
dims=1
unitsize=4
epochs=2
batch=10

height=400
tasks=2
width=162

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_0.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=400
tasks=2
width=342

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_1.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# SVM Float

op=svmf32
exe=svmf32
dims=1
unitsize=4
epochs=2
batch=10

height=200
tasks=2
width=268

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_0.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=200
tasks=2
width=512

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_1.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# SVM double

op=svmf64
exe=svmf64
dims=1
unitsize=8
epochs=2
batch=10

height=800
tasks=2
width=136

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_0.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=800
tasks=2
width=512

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_1.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# Norm

op=norm
exe=norm
dims=2
unitsize=2
epochs=10
batch=100

height=80
tasks=6
width=164

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_0.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=80
tasks=6
width=444

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_1.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# Norm 32

op=norm32
exe=norm32
dims=2
unitsize=4
epochs=10
batch=100

height=100
tasks=4
width=120

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_0.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=100
tasks=4
width=700

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_1.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# Norm float

op=normf32
exe=normf32
dims=2
unitsize=4
epochs=10
batch=100

height=100
tasks=4
width=120

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_0.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=100
tasks=4
width=700

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_1.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# Norm double

op=normf64
exe=normf64
dims=2
unitsize=8
epochs=10
batch=100

height=100
tasks=4
width=60

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_0.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=100
tasks=4
width=504

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_1.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# CNN

op=cnn
exe=cnn
dims=2
unitsize=2
epochs=2
batch=10

height=200
tasks=2
width=326

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_0.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=200
tasks=2
width=714

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_1.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# CNN 32

op=cnn32
exe=cnn32
dims=2
unitsize=4
epochs=2
batch=10

height=400
tasks=2
width=230

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_0.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=400
tasks=2
width=666

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_1.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# CNN float

op=cnnf32
exe=cnnf32
dims=2
unitsize=4
epochs=2
batch=10

height=400
tasks=2
width=194

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_0.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=400
tasks=2
width=278

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_1.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

# CNN double

op=cnnf64
exe=cnnf64
dims=2
unitsize=8
epochs=2
batch=10

height=400
tasks=2
width=90

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_0.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

height=400
tasks=2
width=822

tmp_fn=${tmp_fn_root}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_${width}_${unitsize}_0_llvm_1.csv
echo Writing ${tmp_fn}
../output/llvm/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -f -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmp_fn}
python3 ./stats_from.py ${out_dir}${tmp_fn} ${plat} ${op} ${repeats} ${epochs} ${batch} ${dims} 0 ${tasks} ${height} ${width} ${unitsize} 0 >> ${out_dir}${stats_fn}

echo !!COMPLETE!!
