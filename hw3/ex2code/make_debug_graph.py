import numpy as np 
import networkx as nx
from fglib import graphs, nodes, rv

def make_debug_graph():

    # Create factor graph
    fg = graphs.FactorGraph()

    # Create variable nodes
    x1 = nodes.VNode("x1")
    x2 = nodes.VNode("x2")
    x3 = nodes.VNode("x3")
    x4 = nodes.VNode("x4")

    # Create factor nodes
    f12 = nodes.FNode("f12")
    f234 = nodes.FNode("f234")
    f3 = nodes.FNode("f3")
    f4 = nodes.FNode("f4")

    # Add nodes to factor graph
    fg.set_nodes([x1, x2, x3, x4])
    fg.set_nodes([f12, f234, f3,f4 ])

    # Add edges to factor graph
    fg.set_edge(x1, f12)
    fg.set_edge(f12, x2)
    fg.set_edge(x2, f234)
    fg.set_edge(f234, x3)
    fg.set_edge(f234, x4)
    fg.set_edge(x3, f3)
    fg.set_edge(x4, f4)

    #add potential for f_3: p(x3)
    dist_f3 = [0.5, 0.5]
    f3.factor = rv.Discrete(dist_f3,x3)
    
    #add potential for f_4: p(x4)
    dist_f4 = [0.4,0.6]
    f4.factor = rv.Discrete(dist_f4,x4)
    
    # add potential for f_{234}: p(x2, x3, x4) = p(x2|x3,x4) p(x3,x4)
    px3x4=np.outer(dist_f3,dist_f4)
    px3x4=np.reshape(px3x4, np.shape(px3x4)+(1,))
    px2_conditioned_x3x4=[[[0.2,0.8],
                         [0.25,0.75],],
                         [[0.7,0.3],
                         [0.3,0.7]]]
    
    dist_f234 =px3x4*px2_conditioned_x3x4
    f234.factor = rv.Discrete(dist_f234,x3,x4,x2)
   
    # add potential for f_{12}:  p (x1,x2) = p(x1 | x2) p(x2)
    px1_conditioned_x2 = [[0.5,0.5],
                         [0.7,0.3]]
    px2= np.sum(dist_f234, axis=(0,1))
    dist_f12 =px2[:,np.newaxis]*px1_conditioned_x2
    f12.factor = rv.Discrete(dist_f12,x2,x1)

    # Perform sum-product algorithm on factor graph
    # and request belief of variable node x1
    belief = inference.sum_product(fg, x3)
    return (fg)

def get_beliefs(fg):
 ##TO DO
	return 0

fg=make_debug_graph()
beliefs = get_beliefs(fg)
# Print belief of variable nodes
print("Belief of variable nodes ")
print(beliefs)
