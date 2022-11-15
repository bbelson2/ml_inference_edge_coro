#!/bin/bash

# Note - this runs norm 9a 1d over all models 

# Shell script to iterate the chain test, varying task count and then width.
# Command line is e.g.:
# ./svm.out -e 10 -b 100 -c 4 -s 256 -n 200 -d -p 1 -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o - -w -x -g -f >> ../results/../results/${fn}_dropout.csv
# Note that -x is used only on the first line of each file, so that only one header line appears. 

# op2 runs sum & svm
# op2 adds -f flood

short=-d
coro=8
dims=1

for height in 5 10 20 40 80 
do
  fn=svm_pi_042_n${height}
  echo Writing ${fn}_*.csv
  hdr=-x
  for tasks in {2..8..2}
  do
    for width in {4..1024..4}
    do
      echo ${height}/${tasks}/${width} of 5 10 20 40 80/2,4,6,8/4-1024
      ./svm.out -e 10 -b 100 -c $tasks -s $width -n $height -d -p ${dims} -u cpu_cycles,instructions,d_cache_reads,d_cache_misses -o - -w $hdr -g -f >> ../results/../results/${fn}_svm.csv
      # touch ../results/${fn}_f.csv
      hdr=
    done
  done
done
