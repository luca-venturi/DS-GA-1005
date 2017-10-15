import numpy as np

# get the data

data_file = open('data/chowliu-input.txt','r')
data = np.array([line.split() for line in data_file])
data = data.astype(np.int32)
(nImages, nTypes) = data.shape
np.savetxt('data/data.txt', data)

# evaluate weights

weights = np.zeros((nTypes,nTypes))
for i in range(nTypes):
	for j in range(i+1,nTypes):
		weights[i,j] = sum([(data[k][i]+data[k][j])/2 for k in range(nImages)])
weights = weights + weights.T
np.savetxt('data/weights.txt', weights)

weights_single = np.array([sum([data[k,n] for k in range(nImages)]) for n in range(nTypes)])
np.savetxt('data/weights_single.txt', weights_single)
