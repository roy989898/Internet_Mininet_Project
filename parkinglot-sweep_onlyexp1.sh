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
#exp1 change link h1-s1 vary delay  0ms to 300ms step=10
for i in {0..300..30}
do
    d_delay=$i
    echo $d_delay
    dir=$rootdir/exp1/vary_delay/$d_delay
    python exp1.py --bw $bw \
        --dir $dir \
        -t 60 \
	--de $d_delay \
      
    python util/plot_rate.py --rx \
        --maxy $bw \
        --xlabel 'Time (s)' \
        --ylabel 'Rate (Mbps)' \
        -i 's[1]-eth[2]' \
        -f $dir/bwm.txt \
        -o $dir/rate_eth2.png
   
		
    python util/plot_tcpprobe.py \
        -f $dir/tcp_probe.txt \
        -o $dir/cwnd.png

done	 

#exp1 vary delay	

#exp1 vary loss rate	
for i in {0..8..2}
do
    loss_rate=$i
    echo $loss_rate
    dir=$rootdir/exp1/vary_lossrate/$loss_rate
    python exp1.py --bw $bw \
        --dir $dir \
        -t 60 \
		--lo $loss_rate \
      
    python util/plot_rate.py --rx \
        --maxy $bw \
        --xlabel 'Time (s)' \
        --ylabel 'Rate (Mbps)' \
        -i 's[1]-eth[2]' \
        -f $dir/bwm.txt \
        -o $dir/rate_eth2.png
   
		
    python util/plot_tcpprobe.py \
        -f $dir/tcp_probe.txt \
        -o $dir/cwnd.png
done	
	
#exp1 vary loss rate


echo "Started at" $start
echo "Ended at" `date`
echo "Output saved to $rootdir"