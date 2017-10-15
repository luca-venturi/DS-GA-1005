from __future__ import division
import numpy as np
from scipy.sparse import csr_matrix
from scipy.sparse.csgraph import minimum_spanning_tree

weights = np.loadtxt('data/weights.txt')
weights_single = np.loadtxt('data/weights_single.txt')

weights_sparse = csr_matrix(weights)
tree = minimum_spanning_tree(weights_sparse) # sparse matrix of the tree

edges = np.array(tree.nonzero()).T
nEdges = edges.shape[0]
potential = np.zeros((nEdges))

for k in range(nEdges):
	potential[k] = weights[edges[k,0],edges[k,1]] / (weights_single[edges[k,0]] * weights_single[edges[k,1]])

nVar = weights.shape[0] 

f = open('output.txt','w')
f.write('MARKOV\n')
f.close()

f = open('output.txt','a')

f.write('%d\n' % nVar)

for _ in range(nVar-1): 
	f.write('2 ')
f.write('2\n')	

f.write('%d\n' % nEdges)

for k in range(nEdges):
	f.write('2 %d %d\n'%(edges[k,0],edges[k,1]))

for k in range(nEdges):
	f.write('4\n ')
	
