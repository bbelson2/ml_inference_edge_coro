#!/bin/bash

# Note - this runs leaf over all models 

# Shell script to iterate the CNN test, varying task count and then width.
# Command line is e.g.:
# ./leaf.out -e 10 -b 100 -c 4 -s 256 -n 200 -d -p 1 -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o - -w -x -g -f >> ../results/../results/${fn}_dropout.csv
# Note that -x is used only on the first line of each file, so that only one header line appears. 

short=
coro=8
dims=2

for height in 100 200 400
do
  fn=cnn_op_073_n${height}_llvm
  echo Writing ${fn}_*.csv
  hdr=-x
  for tasks in {2..4..2}
  do
    for width in {64..512..4}
    do
      echo ${height}/${tasks}/${width} of 100 200 400/2,4/64-512
      ../output/llvm/cnn.out -e 2 -b 10 -c $tasks -s $width -n $height ${short} -p ${dims} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o - -w $hdr -g -f >> ../results/${fn}.csv
      # touch ../results/${fn}_f.csv
      hdr=
    done
  done
done