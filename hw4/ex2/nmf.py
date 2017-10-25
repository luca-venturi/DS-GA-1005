"""
Inference & Representation HW3
Question 2 Non-negative matrix factorization.

@author: Luca
"""

import numpy as np
from mnist_tools import *
from plot_tools import *
import matplotlib.pyplot as plt
from scipy.linalg import orth

# Load datas

datafile = "mnist_all.mat" #Change if you put the file in a different path
train = load_train_data(datafile)

trainarr = np.asarray(train)
trainarr = np.reshape(trainarr, (trainarr.shape[0]*trainarr.shape[1],-1))
trainarr = trainarr.astype(float)

test, testLabels = load_test_data(datafile)

# Nearest Neighbor algorithm

def compute_nearest_neighbors(train, testImage) :
	return np.argmin(np.array([np.linalg.norm(train[n,:]-testImage) for n in range(len(list(train)))],dtype=np.float))

# Non-Negative Matrix Factorization algorithm 

def nmf(x,r):
	eps = 1e-10
	nIter = 2000
	(n,p) = x.shape
	x_range = np.arange(1,np.max(x)+1)
	w = np.random.choice(x_range,size=(n,r))
	h = np.random.choice(x_range,size=(r,p))
	for _ in range(nIter):
		h = h * np.dot(w.T,x + eps) / np.dot(w.T,np.dot(w,h))
		w = w * np.dot(x + eps,h.T) / np.dot(w,np.dot(h,h.T))
	return w, h

# Ex. 2 - NMF

r_values = [3,6,10]
for r in r_values:
	w, h = nmf(trainarr,r)
	imgs = [h[i,:] for i in range(r)]
	plot_image_grid(imgs,'Rows of H - NMF (n = '+str(r)+")") # title changed
	h = orth(h.T)
	pTrain = np.dot(trainarr, h)
	print(pTrain.shape)
	pTest = np.dot(test, h)

	imgs = []
	nearestLabels = []
	for i in range(len(testLabels)):
		index = compute_nearest_neighbors(pTrain,pTest[i])
		imgs.extend([test[i],trainarr[index,:]])
		nearestLabels.append(index / 100)
		
	row_titles = ['Test','Nearest']
	col_titles = ['%d vs. %d'%(i,j) for i,j in zip(testLabels,nearestLabels)]
	plot_image_grid(imgs,"Image-NearestNeighbor- NMF (n = "+str(r)+")",(28,28),len(testLabels),2,True,row_titles=row_titles,col_titles=col_titles) # title changed

# Ex. 2.3

tmp = np.arange(10)
for d in tmp:
	plt.plot(tmp+1,pTrain[d * 100,:],label=str(d))
plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
plt.xlabel('principal components')
plt.savefig('NMF 10 top components', bbox_inches='tight')
plt.show()
