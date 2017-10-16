from __future__ import division
import numpy as np

potential = np.load('data/potential.npy')
edges = np.load('data/edges.npy')
nEdges = potential.shape[0]
nVar = nEdges + 1

f = open('data/output.txt','w')
f.write('MARKOV\n')
f.close()
f = open('data/output.txt','a')
f.write('%d\n' % nVar)
for _ in range(nVar-1): 
	f.write('2 ')
f.write('2\n')	
f.write('%d\n' % nEdges)
for k in range(nEdges):
	f.write('2 %d %d\n' % (edges[k,0],edges[k,1]))
for k in range(nEdges):
	f.write('4\n')
	for i in range(2):
		f.write(' %f %f\n' % (potential[k,i,0],potential[k,i,1]))
f.close()
