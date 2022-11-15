#!/bin/bash

# Note - this runs leaf over all models 

# Shell script to iterate the chain test, varying task count and then width.
# Command line is e.g.:
# ./leaf.out -e 10 -b 100 -c 4 -s 256 -n 200 -d -p 1 -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o - -w -x -g -f >> ../results/../results/${fn}_dropout.csv
# Note that -x is used only on the first line of each file, so that only one header line appears. 

id=191
plat=aw
op=cnn
exe=cnn
dims=2
unitsize=2
repeats=10
epochs=10
batch=100
height=200
tasks=2

out_dir=../results/v2/
short=-d
toolset=llvm

fn=rpt_${id}_${plat}_${op}_${repeats}_${epochs}_${batch}_${dims}_0_${tasks}_${height}_varwidth_${unitsize}_0_${toolset}_0.csv

tmpfn=rpt_${id}_${plat}_${op}_tmp.csv

echo Writing ${fn}
rm ${out_dir}${fn}
hdr=
for width in {1..480..1}
do
  echo ${plat} ${op}: ${width}/480
  ../output/${toolset}/${exe}.out -r ${repeats} -e ${epochs} -b ${batch} -p ${dims} -c ${tasks} -n ${height} -s ${width} ${short} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o ${out_dir}${tmpfn} ${hdr} -f
  cat ${out_dir}${tmpfn} >> ${out_dir}${fn}
  hdr=-z
done
