#!/usr/bin/python



from mininet.topo import Topo
from mininet.net import Mininet
from mininet.log import lg, output
from mininet.node import CPULimitedHost
from mininet.link import TCLink
from mininet.util import custom, quietRun, dumpNetConnections
from mininet.cli import CLI
from time import sleep, time
from multiprocessing import Process
from subprocess import Popen
import termcolor as T
import argparse
import sys
import os
from util.monitor import monitor_devs_ng


def cprint(s, color, cr=True):
    """Print in color
       s: string to print
       color: color to use"""
    if cr:
        print T.colored(s, color)
    else:
        print T.colored(s, color),


parser = argparse.ArgumentParser(description="Parking lot tests")
parser.add_argument('--bw', '-b',
                    type=float,
                    help="Bandwidth of network links",
                    required=True)

parser.add_argument('--de',
                    type=float,
                    help="The delay value of link",
                    default=0)
					
parser.add_argument('-n',
                    type=int,
                    help=("Number of senders in the parking lot topo."
                          "Must be >= 1"),
                    )

parser.add_argument('--lo',
                    type=float,
                    help="The loss rate of link",
                    default=0)

parser.add_argument('--dir', '-d',
                    help="Directory to store outputs",
                    default="results_pom")



parser.add_argument('--cli', '-c',
                    action='store_true',
                    help='Run CLI for topology debugging purposes')

parser.add_argument('--time', '-t',
                    dest="time",
                    type=int,
                    help="Duration of the experiment.",
                    default=60)

# Expt parameters
args = parser.parse_args()

if not os.path.exists(args.dir):
    os.makedirs(args.dir)

lg.setLogLevel('info')


# Topology to be instantiated in Mininet
class CreateTopo(Topo):
    # Topology change at here
    "Parking Lot Topology"

    def __init__(self, cpu=.1, bw=10, delay=None,
                 max_queue_size=None, **params):
        """Parking lot topology with one receiver
           and n clients.
           n: number of clients
           cpu: system fraction for each host
           bw: link bandwidth in Mb/s
           delay: link delay (e.g. 10ms)"""

        # Initialize topo
        Topo.__init__(self, **params)

        # m_Host and link configuration
        # ref self.addLink(receiver, switch, bw=args.bw, delay=str(args.de/2)+'ms', loss=args.lo/2, max_queue_size=200)
        hconfig = {'cpu': cpu}
        lconfig_h1_s1 = {'bw': bw, 'delay': str(args.de) + 'ms', 'max_queue_size': max_queue_size, 'loss': args.lo}
        lconfig_h2_s1 = {'bw': bw, 'delay': str(0) + 'ms', 'max_queue_size': max_queue_size, 'loss': 0}
        lconfig_h3_s2 = {'bw': bw, 'delay': str(0) + 'ms', 'max_queue_size': max_queue_size, 'loss': 0}
        lconfig_s1_s2 = {'bw': bw, 'delay': str(0) + 'ms', 'max_queue_size': max_queue_size, 'loss': 0}


        # m_add 3 host ,h1 h2 h3
        h1 = self.addHost('h1', **hconfig)
        h2 = self.addHost('h2', **hconfig)
        h3 = self.addHost('h3', **hconfig)

        # Switch ports 1:uplink 2:hostlink 3:downlink
        uplink, hostlink, downlink = 1, 2, 3

 
        # m_add two switch
        s1 = self.addSwitch('s1')
        s2 = self.addSwitch('s2')



        # m_Wire up Host:
        self.addLink(h1, s1, port1=0, port2=2, **lconfig_h1_s1)
        self.addLink(h2, s1, port1=0, port2=3, **lconfig_h2_s1)
        self.addLink(h3, s2, port1=0, port2=2, **lconfig_h3_s2)

        # m_Wire up Switch:

        self.addLink(s1, s2, port1=4, port2=4, **lconfig_s1_s2)



def waitListening(client, server, port):
    "Wait until server is listening on port"
    if not 'telnet' in client.cmd('which telnet'):
        raise Exception('Could not find telnet')
    cmd = ('sh -c "echo A | telnet -e A %s %s"' %
           (server.IP(), port))
    while 'Connected' not in client.cmd(cmd):
        output('waiting for', server,
               'to listen on port', port, '\n')
        sleep(.5)


def progress(t):
    while t > 0:
        cprint('  %3d seconds left  \r' % (t), 'cyan', cr=False)
        t -= 1
        sys.stdout.flush()
        sleep(1)
    print


def start_tcpprobe():
    os.system("rmmod tcp_probe 1>/dev/null 2>&1; modprobe tcp_probe")
    Popen("cat /proc/net/tcpprobe > %s/tcp_probe.txt" % args.dir, shell=True)


def stop_tcpprobe():
    os.system("killall -9 cat; rmmod tcp_probe")


def run_parkinglot_expt(net, n):
    "Run experiment"

    seconds = args.time

    # Start the bandwidth and cwnd monitors in the background
    monitor = Process(target=monitor_devs_ng,
                      args=('%s/bwm.txt' % args.dir, 1.0))
    monitor.start()
    start_tcpprobe()

    # Get receiver and clients
    recvr = net.getNodeByName('h2')
    sender1 = net.getNodeByName('h1')

    # Start the receiver
    port = 5001
    recvr.cmd('iperf -s -p', port,
              '> %s/iperf_server.txt' % args.dir, '&')

    waitListening(sender1, recvr, port)

    # TODO: start the sender iperf processes and wait for the flows to finish
    # Hint: Use getNodeByName() to get a handle on each sender.
    # Hint: Use sendCmd() and waitOutput() to start iperf and wait for them to finish iperf -c %s -p %s -t %d -i 1 -yc > %s/iperf_%s.txt' % (recvr.IP(), 5001, seconds, args.dir, node_name)
    # Hint (not important): You may use progress(t) to track your experiment progress


    sender1.sendCmd('iperf -c %s -p %s -t %d -i 1 -yc > %s/iperf_h1.txt' % (recvr.IP(), 5001, seconds, args.dir))

    # for i in range(1,n):
    #    sender = net.getNodeByName('h%s' % (i+1))
    #    sender.sendCmd('iperf -c %s -p %s -t %d -i 1 -yc > %s/iperf_h%s.txt' % (recvr.IP(), 5001, seconds, args.dir, (i+1)))



    sender1.waitOutput()



    progress(seconds)

    recvr.cmd('kill %iperf')

    # Shut down monitors
    monitor.terminate()
    stop_tcpprobe()


def check_prereqs():
    "Check for necessary programs"
    prereqs = ['telnet', 'bwm-ng', 'iperf', 'ping']
    for p in prereqs:
        if not quietRun('which ' + p):
            raise Exception((
                                'Could not find %s - make sure that it is '
                                'installed and in your $PATH') % p)


def main():
    "Create and run experiment"
    start = time()

    topo = CreateTopo(n=args.n)

    host = custom(CPULimitedHost, cpu=.15)  # 15% of system bandwidth
    # link = custom(TCLink, bw=args.bw, delay='1ms',max_queue_size=200)
    link = custom(TCLink, bw=args.bw, max_queue_size=200)
    net = Mininet(topo=topo, host=host, link=link)

    net.start()

    cprint("*** Dumping network connections:", "green")
    dumpNetConnections(net)

    cprint("*** Testing connectivity", "blue")

    net.pingAll()

    if args.cli:
        # Run CLI instead of experiment
        CLI(net)
    else:
        cprint("*** Running experiment", "magenta")
        run_parkinglot_expt(net, n=args.n)

    net.stop()
    end = time()
    os.system("killall -9 bwm-ng")
    cprint("Experiment took %.3f seconds" % (end - start), "yellow")


if __name__ == '__main__':
    check_prereqs()
    main()
