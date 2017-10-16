# my implementation of the loopy belief propagation algorithm
# it uses functions/classes from fglib modules 'graphs', 'nodes', 'rv'
# no functions from 'inference' module are used (as prescribed)

import numpy as np 
import networkx as nx
from fglib import graphs, nodes, rv

def get_message(g,a,b):
	return g[a][b]['object'].get_message(a, b)

def set_message(g,a,b,value):
	g[a][b]['object'].set_message(a, b, value)

def spa(g,f,v):
	return f.spa(v)

def get_beliefs(fg, nIter, query_node):
	# initialization variable to factor messages
	for v in fg.get_vnodes():
		for f in nx.all_neighbors(fg, v):
			msg = rv.Discrete(np.array([1,1]),v)
			set_message(fg,v,f,msg)
	# bp loop
	for _ in range(nIter):
		# factor to variables messages
		for f in fg.get_fnodes():
			for v in nx.all_neighbors(fg, f):
				set_message(fg,f,v,spa(fg,f,v))
		# variable to factor messages
		for v in fg.get_vnodes():
			for f in nx.all_neighbors(fg, v):
				set_message(fg,v,f,spa(fg,v,f))
	
	return query_node.belief()
