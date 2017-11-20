# Hamiltonian Monte Carlo simulations of X ~ N(0,S)
# S = [[1,0.998],[0.998,1]]

import numpy as np

cov = [[1.,0.998],[0.998,1.]]
A = [[250.25, -249.75],[-249.75, 250.25]] # approximate of cov^{-1}
n = A.shape[0]

def E(x):
	return np.dot(x,np.dot(A,x)) / 2.
	
def G(x):
	return np.dot(A,x)

x = [-1.,1.5]
_iter = 20
eps = 0.3
step = 12
for i in range(_iter):
	p = np.random.randn(n)
	H = np.dot(p,p) / 2. + E(x)
	
	x_new = x
	G_new = G(x)
	
	for tau in range(step):
		p -= eps * G_new / 2.
		x_new += eps * p
		G_new = G(x_new)
		p -= eps * G_new / 2.
		
	E_new = E(x_new)
	H_new = np.dot(p,p) / 2. + E_new
	dH = H_new - H
	
	if np.random.rand() < np.exp(-dH):
		G = G_new
		x = x_new
		E = E_new
