from __future__ import division
import numpy as np
from scipy.sparse import csr_matrix
from scipy.sparse.csgraph import minimum_spanning_tree

count = np.load('data/count.npy') 
nType = count.shape[0]

# comput the mutual information

weight = np.zeros((nType,nType))

def mutualInformation(couple,x,y):
	(nx,ny) = couple.shape
	tmp = np.zeros((nx,ny)) 
	for i in range(nx):
		for j in range(ny):
			if couple[i,j] != 0.:
				tmp[i,j] = couple[i,j] * np.log( couple[i,j] / (x[i] * x[j]) )
			else:
				tmp[i,j] = couple[i,j]
	return np.sum(tmp)

for i in range(nType):
	for j in range(nType):
		weight[i][j] = mutualInformation(count[i,j,:,:],[count[i,i,k,k] for k in range(2)],[count[j,j,k,k] for k in range(2)])

weight_sparse = csr_matrix(-weight)
tree = minimum_spanning_tree(weight_sparse)

edges = np.array(tree.nonzero()).T
nEdges = edges.shape[0]
potential = np.zeros((nEdges,2,2))

for k in range(nEdges):
	for i in range(2):
		for j in range(2):
			potential[k,i,j] = count[edges[k,0],edges[k,1],i,j] / (count[edges[k,0],edges[k,0],i,i] * count[edges[k,1],edges[k,1],j,j])

print potential[0,:,:]
np.save('data/potential.npy', potential)
np.save('data/edges.npy', edges)
