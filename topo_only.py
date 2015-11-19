from mininet.topo import Topo

class MyTopo( Topo ):
    "Simple topology example."

    def __init__( self ):
        "Create custom topo."

        # Initialize topology
        Topo.__init__( self )
		h1 = self.addHost('h1')
		h2 = self.addHost('h2')
		h3 = self.addHost('h3')
        # Switch ports 1:uplink 2:hostlink 3:downlink
        #uplink, hostlink, downlink = 1, 2, 3

        # The following template code creates a parking lot topology
        # for N = 1
        # TODO: Replace the template code to create a parking lot topology for any arbitrary N (>= 1)
        # Begin: Template code
		#m_add two switch
        s1 = self.addSwitch('s1')
		s2 = self.addSwitch('s2')
        

        # Wire up receiver
        #self.addLink(receiver, s1,
        #              port1=0, port2=uplink, **lconfig)

        # m_Wire up Host:
        self.addLink(h1, s1,port1=0, port2=2)
		self.addLink(h2, s1,port1=0, port2=3)
		self.addLink(h3, s2,port1=0, port2=2)
					  
		# m_Wire up Switch:
		
		self.addLink(s1, s2,
                      port1=4, port2=4, **lconfig_s1_s2)


topos = { 'mytopo': ( lambda: MyTopo() ) }
