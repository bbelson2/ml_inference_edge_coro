#!/bin/bash

# Note - this runs leaf over all models 

# Shell script to iterate the CNN test, varying task count and then width.
# Command line is e.g.:
# ./leaf.out -e 10 -b 100 -c 4 -s 256 -n 200 -d -p 1 -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o - -w -x -g -f >> ../results/../results/${fn}_dropout.csv
# Note that -x is used only on the first line of each file, so that only one header line appears. 

short=
coro=8
dims=1
repeats=2

for height in 40 80 100 200 400 800
do
  fn=svm_aw_086_n${height}_llvm
  echo Writing ${fn}_*.csv
  hdr=-x
  for tasks in {2..8..2}
  do
    for width in {2..1024..4}
    do
      echo ${height}/${tasks}/${width} of 40 80 100 200 400 800/2,4,6,8/2-1024
      ../output/llvm/svm.out -r ${repeats} -e 2 -b 10 -c $tasks -s $width -n $height ${short} -p ${dims} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o - -w $hdr -g -f >> ../results/${fn}.csv
      # touch ../results/${fn}_f.csv
      hdr=
    done
  done
done
