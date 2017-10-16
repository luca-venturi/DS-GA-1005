import numpy as np 
import networkx as nx
from fglib import graphs, nodes, rv

def get_graph(H):
	
	(N,dN) = H.shape
	
	# Create factor graph
	fg = graphs.FactorGraph()
	
	# Create variable nodes
	vNodes = []
	for n in range(dN):
		vNodes.append( nodes.VNode('v' + str(n)) )
	
	# Create factor nodes    
	fNodes = []
	for n in range(N):
		fNodes.append( nodes.FNode('f' + str(n)) )
	
	# Add nodes to factor graph
	fg.set_nodes([vNodes[n] for n in range(dN)])
	fg.set_nodes([fNodes[n] for n in range(N)])
	
	# Add edges to factor graph
	for v in range(dN):
		for f in range(N):
			if H[f,v] == 1:
				fg.set_edge(vNodes[v], fNodes[f])
	
	# Add potentials
	for f in range(N):
		tmp = np.eye(2)
		index = np.argwhere(H[f,:])
		tmpx = vNodes[index[0][0]]
		tmpy = vNodes[index[1][0]]
		fNodes[f].factor = rv.Discrete(tmp,tmpx,tmpy)
	
	return fg
