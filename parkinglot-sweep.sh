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




#sudo python parkinglot.py --bw 10 --dir test -t 60
#exp1 change link h1-s1 vary delay  0ms to 300ms step=10
#h1 send to h2
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

#exp2 change link s1-s2 vary delay
#h1 send to h3
for i in {0..300..30}
do
    d_delay=$i
    echo $d_delay
    dir=$rootdir/exp2/vary_delay/$d_delay
    python exp2.py --bw $bw \
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
#exp2 vary delay

#exp2 vary loss rate	
for i in {0..8..2}
do
    loss_rate=$i
    echo $loss_rate
    dir=$rootdir/exp2/vary_lossrate/$loss_rate
    python exp2.py --bw $bw \
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
	
#exp2 vary loss rate

#exp3 change link h1-s1 vary delay  0ms to 300ms step=10
#h1 send to h3
for i in {0..300..30}
do
    d_delay=$i
    echo $d_delay
    dir=$rootdir/exp3/vary_delay/$d_delay
    python exp3.py --bw $bw \
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

#exp3 vary delay	

#exp3 vary loss rate	
for i in {0..8..2}
do
    loss_rate=$i
    echo $loss_rate
    dir=$rootdir/exp3/vary_lossrate/$loss_rate
    python exp3.py --bw $bw \
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
	
#exp3 vary loss rate
echo "Started at" $start
echo "Ended at" `date`
echo "Output saved to $rootdir"