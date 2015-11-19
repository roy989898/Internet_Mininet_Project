#!/bin/bash

# Function: run the parking lot topology for various
# value of N

# Exit on any failure
set -e

# Check for uninitialized variables
set -o nounset

ctrlc() {
	killall -9 python
	mn -c
	exit
}

trap ctrlc SIGINT

start=`date`
exptid=`date +%b%d-%H:%M`
rootdir=parkinglot-$exptid
bw=100

# Note: you need to make sure you report the results
# for the correct port!
# In this example, we are assuming that each
# client is connected to port 2 on its switch.

#for n in 1 2 3 4 5; do
#   dir=$rootdir/n$n
#    python parkinglot.py --bw $bw \
#        --dir $dir \
#        -t 30 \
#        -n $n
#    python util/plot_rate.py --rx \
#        --maxy $bw \
#        --xlabel 'Time (s)' \
#        --ylabel 'Rate (Mbps)' \
#        -i 's.*-eth2' \
#        -f $dir/bwm.txt \
#        -o $dir/rate.png
#    python util/plot_tcpprobe.py \
#       -f $dir/tcp_probe.txt \
#        -o $dir/cwnd.png
#done

#sudo python parkinglot.py --bw 10 --dir test -t 60 
dir=$rootdir/exp1
    python parkinglot.py --bw $bw \
        --dir $dir \
        -t 30 \
		--de 1 \
      
    python util/plot_rate.py --rx \
        --maxy $bw \
        --xlabel 'Time (s)' \
        --ylabel 'Rate (Mbps)' \
        -i 's[123456789]-eth[123456789]' \
        -f $dir/bwm.txt \
        -o $dir/rate_eth2.png
   
		
    python util/plot_tcpprobe.py \
        -f $dir/tcp_probe.txt \
        -o $dir/cwnd.png
		
	
		
 

echo "Started at" $start
echo "Ended at" `date`
echo "Output saved to $rootdir"