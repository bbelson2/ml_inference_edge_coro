#!/bin/bash

# Note - this runs leaf over all models 

# Shell script to iterate the chain test, varying task count and then width.
# Command line is e.g.:
# ./leaf.out -e 10 -b 100 -c 4 -s 256 -n 200 -d -p 1 -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o - -w -x -g -f >> ../results/../results/${fn}_dropout.csv
# Note that -x is used only on the first line of each file, so that only one header line appears. 

short=-d
coro=8
dims=1
tool=gcc
run=071

for height in {800..800..100}
do
  fn=rndleaf_op_${run}_n${height}_rndleaf_${tool}
  echo Writing ${fn}_*.csv
  hdr=-x
  for tasks in {8..8..1}
  do
    width=176
    for clustering in {0..800..1}
    do
      echo ${height}/${tasks}/${clustering} of 800/8/0-800
      ../output/${tool}/rndleaf.out -e 10 -b 100 -c $tasks -s $width -n $height ${short} -p ${dims} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o - -w $hdr -g -f -l ${clustering} >> ../results/../results/${fn}.csv
      # touch ../results/${fn}_f.csv
      hdr=
    done
  done
done
