# Function that evaluate count = p(x_i,x_j) for the data images

from __future__ import division
import numpy as np

data = np.loadtxt('data/chowliu-input.txt').astype(int)
(nImage,nType) = data.shape

count = np.zeros((nType,nType,2,2))

for i in range(nType):
	for j in range(nType):
		for k in range(nImage):
			count[i,j,data[k][i],data[k][j]] += 1
count = count / nImage

np.save('data/count.npy', count)
