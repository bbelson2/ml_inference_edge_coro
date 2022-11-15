#!/bin/bash

# Fixing script to replace the suspicious SVM-16 collection

# Changes from 146 - added -f, based run off the parameters for the best unsmoothed results,
# rather than smoothed

# Changes from 153 - changed batch & epochs to be in line with original runs

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
stats_fn=stats_all_op_156_repl.csv
tmp_fn_root=stats_156_repl

echo "platcode,op,repeats,epochs,batch,output_dims,output_model,tasks,height,width,unitsize,lines,coro-no-prefetch-ratio-mean,coro-no-prefetch-ratio-sd,coro-prefetch-ratio-mean,coro-prefetch-ratio-sd" > ${out_dir}${stats_fn}

# SVM

op=svm
exe=svm
dims=1
unitsize=2
epochs=2
batch=10

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

echo !!COMPLETE!!
