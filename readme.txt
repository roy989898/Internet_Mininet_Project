1.ina mininet system create a new folder(e.g. projectv1/)
2.put all the  file  into projectv1
2copy util folder from gt-cs6250/parking_lot_assignment_3 to projectv1

run:
cd ~/projectv1/
if u want to run the hole EXP 

call

sudo bash parkinglot-sweep.sh


if u only want to run the exp1

sudo bash parkinglot-sweep_onlyexp1.sh


if u only want to run the exp2

sudo bash parkinglot-sweep_onlyexp2.sh

Explain***********

Topology

h1
|
s1-s2-h3
|
h2

h1 :port0 to s1 port2

h2 :port0 to s1 port3

h3 :port0 to s1 port2

s1 port 4 to s2 port 4

EXP1~~~~~~~~~~

h1 send to h2

h1-s1 vary

s1-h2 0ms delay 0%loss reate
s1-s2 0ms delay 0%loss reate
s2-h3 0ms delay 0%loss reate

vary delay 0-300 step=30ms

vary loss rate 0-8 step=2%

EXP2~~~~~~~~~~
h1 send to h3

s1-s2 vary

s1-h2 0ms delay 0%loss reate
h1-s1 0ms delay 0%loss reate
s2-h3 0ms delay 0%loss reate

vary delay 0-300 step=30ms

vary loss rate 0-8 step=2%

EXP3~~~~~~~~~~

h1 send to h3

h1-s1 vary

s1-h2 0ms delay 0%loss reate
s1-s2 0ms delay 0%loss reate
s2-h3 0ms delay 0%loss reate

vary delay 0-300 step=30ms

vary loss rate 0-8 step=2%