# There is some problem with initialization

import numpy as np 
import networkx as nx
from fglib import graphs, nodes, rv

def bp_loop(graph,variables_nodes,factor_nodes):
		
	for f in variables_nodes:
		for v in nx.all_neighbors(graph, f):
			message = f.spa(v)
			graph[f][v]['object'].set_message(f, v, message)	
	
	for v in variables_nodes:
		for f in nx.all_neighbors(graph, v):
			message = v.spa(f)
			graph[v][f]['object'].set_message(v, f, message)

def get_beliefs(graph, max_iter=1000, infer_node=None):
	
	if infer_node == None:
		infer_node = graph.get_vnodes()

	# get vertex/factor nodes
	
	variable_nodes = []
	factor_nodes = []
	for x in graph.nodes(data=True):
		if x[1]["type"] == "vn":
			variable_nodes.append(x[0])
		else:
			factor_nodes.append(x[0]) 

	# set initial variable-to-factor messages to 1

	for v in graph.get_vnodes():
		for f in nx.all_neighbors(graph, v):
			graph[v][f]['object'].set_message(v, f, rv.Discrete(np.ones((2,2)),v,f))
	
	all_beliefs = {v: [] for v in infer_node}
	
	# run the bp loop

	for i in range(max_iter):
		bp_loop(graph,variable_nodes,factor_nodes)
		for v in infer_node:
			all_beliefs[v].append(v.belief())
	
	beliefs = {v: all_beliefs[v][-1] for v in infer_node}
	
	return beliefs, all_beliefs
