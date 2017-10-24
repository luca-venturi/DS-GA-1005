"""
Inference & Representation HW3
Question 2 PCA and Non-negative matrix factorization.

"""

"""
Tools for loading the MNIST Data.
From Optimization Based Data Analysis HW1
@author: Brett
"""

import numpy as np
from mnist_tools import *
from plot_tools import *
from scipy.linalg import orth
import matplotlib.pyplot as plt

"""
Given train (in the format returned by load_train_data in mnist_tools), 
and a 1d numpy array testImage you should return a tuple (digit,imageIdx).  digit is
an integer giving the numerical digit value of the training image closest 
to the testImage in Euclidean distance.  imageIdx is the row number of the closest 
training image in the 2d array train[digit].
"""

"""
Assumes the data file is in 'mnist_all.mat'.
"""

datafile = "mnist_all.mat" #Change if you put the file in a different path
train = load_train_data(datafile)

trainarr = np.asarray(train)
trainarr = np.reshape(trainarr, (trainarr.shape[0]*trainarr.shape[1],-1))
trainarr = trainarr.astype(float)
print np.max(trainarr)
# trainarr = trainarr-trainarr.mean(axis=0)
'''
"""
Plot of the singular vectors corresponding 
to top 10 singular values of the data.
@author: Vlad 
"""
U, s, V = np.linalg.svd(trainarr-trainarr.mean(axis=0), full_matrices=True)
n = 10
imgs = [V[i,:] for i in range(n)]
plot_image_grid(imgs,"Singular vectors corresponding to top 10 singular values of the data")

"""
Plot of the results of the nearest neighbour test applied 
to a principal component projection.
@author: Vlad 
"""
'''
def project(V, Images) :
	return np.dot(V.T, np.dot(V, Images))
    
def compute_nearest_neighbors(train, testImage, V) :
	train = [np.array(i, dtype=float) for i in train]
	testImage = np.array(testImage, dtype=float)
	digit = 0
	imageIdx = 0
	dist = np.linalg.norm(project(V,train[digit][imageIdx])-project(V,testImage))
	for i in range(len(train)):
		for j in range(train[i].shape[0]):
			tempDist = np.linalg.norm(project(V,train[i][j])-project(V,testImage))
			if tempDist<dist:
				digit = i
				imageIdx =j
				dist = tempDist
	return digit, imageIdx
'''
n = 8
U, s, V = np.linalg.svd(trainarr, full_matrices=False)
V = V[0:n,:]

test,testLabels = load_test_data(datafile)

imgs = []
TestLabels = []
for i in range(len(testLabels)):
	trueDigit = testLabels[i]
	testImage = test[i]
	(nnDig,nnIdx) = compute_nearest_neighbors(train,testImage,V)
	imgs.extend( [testImage,train[nnDig][nnIdx,:]] )
	TestLabels.append(nnDig)

row_titles = ['Test','Nearest']
col_titles = ['%d vs. %d'%(i,j) for i,j in zip(testLabels,testLabels)]
plot_image_grid(imgs,"Image-NearestNeighbor",(28,28),len(testLabels),2,True,row_titles=row_titles,col_titles=col_titles)
'''
"""
Exercise 2
@author: Luca 
"""

def KLd(a,b):
	(n,m) = a.shape
	tmp = 0
	for i in range(n):
		for j in range(m):
			tmp += a[i,j] * np.log(a[i,j] / b[i,j]) - a[i,j] + b[i,j]
	return tmp	 

def nmf(x,r):
	eps = 1e-10
	nIter = 2000
	(n,p) = x.shape
	w = np.random.normal(size=(n,r))
	h = np.random.normal(size=(r,p))
	for i in range(nIter):
		p = x / (np.dot(w,h) + eps)
		hs = np.sum(h,axis=1) + eps
		hp = np.dot(p, h.T)
		ws = np.sum(w,axis=0) + eps
		wp = np.dot(w.T, p)
		w = w * hp / hs
		h = ((h * wp).T / ws).T
		print 'it -> ', i
	return w, h
	
def nmf2(x,r):
	eps = 1e-10
	nIter = 2000
	(n,p) = x.shape
	w = np.random.normal(size=(n,r))
	h = np.random.normal(size=(r,p))
	for i in range(nIter):
		w = w * np.dot(x / (np.dot(w,h) + eps), h.T) / (np.sum(h,axis=1) + eps)
		h = ((h * np.dot(w.T, x / (np.dot(w,h) + eps))).T / (np.sum(w,axis=0) + eps)).T
		print 'it -> ', i
	return w, h
	
def nmf3(x,r):
	eps = 1e-7
	nIter = 2000
	(n,p) = x.shape
	w = np.random.choice(range(1,256),size=(n,r))
	h = np.random.choice(range(1,256),size=(r,p))
	for i in range(nIter):
		h = h * np.dot(w.T,x + eps) / (np.dot(w.T,np.dot(w,h))) 
		w = w * np.dot(x + eps,h.T) / (np.dot(w,np.dot(h,h.T)))
		print 'it -> ', i
	return w, h
'''
def nmf(x,r): # matrix notation 
	x += 1.
	(n,p) = x.shape
	w = np.ones((n,r))
	h = np.ones((r,p))
	w_update = np.zeros((n,r))
	h_update = np.zeros((r,p))
	it_max = 100
	#wh = np.dot(w, h)
	eps = 1e-7
	#it = 0
	for it in range(it_max): # better stopping criteria?
	#while KLd(x, wh) > eps:
		#it += 1
		wh = np.dot(w, h)
		print 'Iteration -> ', it + 1
		for k in range(r):
			tmp1 = np.sum(h[k,:])
			for i in range(n):
				tmp2 = np.sum(h[k,:] * x[i,:] / wh[i,:]) 
				w_update[i,k] = w[i,k] * tmp2 / tmp1
		hs = np.sum(h,axis=1)
		w = w_old * np.dot(x / (wh + eps), h.T) / (hs + eps) # hs_ik = sum(h[k,:])
		for k in range(r):
			tmp1 = np.sum(w[:,k])
			for j in range(p):
				tmp2 = np.sum(w[:,k] * x[:,j] / wh[:,j])
				h_update[k,j] = h[k,j] * tmp2 / tmp1
		w = w_update[:]
		h = h_update[:]
		# wh = np.dot(w, h)
	return w - 1., h - 1.
'''
r_values = [3,6,10]
for r in r_values:
	w, h = nmf3(trainarr,r)
	#h = orth(h.T).T
	print h.shape
	imgs = [h[i,:] for i in range(r)]
	plot_image_grid(imgs,"Singular vectors corresponding to top 10 singular values of the data")
	
	test,testLabels = load_test_data(datafile)

	imgs = []
	TestLabels = []
	for i in range(len(testLabels)):
		trueDigit = testLabels[i]
		testImage = test[i]
		(nnDig,nnIdx) = compute_nearest_neighbors(train,testImage,orth(h.T).T)
		imgs.extend( [testImage,train[nnDig][nnIdx,:]] )
		TestLabels.append(nnDig)
		
	row_titles = ['Test','Nearest']
	col_titles = ['%d vs. %d'%(i,j) for i,j in zip(testLabels,testLabels)]
	plot_image_grid(imgs,"Image-NearestNeighbor",(28,28),len(testLabels),2,True,row_titles=row_titles,col_titles=col_titles)
