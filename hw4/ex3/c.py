import numpy as np
from sklearn import decomposition  

def generate_data_c(n_smpl,n_ftr):
	tmp = np.random.normal(size=(n_smpl,n_ftr))
	data = np.zeros((n_smpl,n_ftr))
	data[:,0] = tmp[:,0]
	data[:,1] = tmp[:,0] + 1e-4 * tmp[:,1]
	data[:,2] = 1e2 * tmp[:,2] 
	return data
	
data = generate_data_c(int(1e5),3)
print(np.cov(data.T))
n_components = 2

# FA

fa = decomposition.FactorAnalysis(n_components=n_components, max_iter=200)
fa.fit(data)
fa_comp = fa.components_
print(fa_comp)

# PCA

pca = decomposition.PCA(n_components=n_components)
pca.fit(data)
pca_comp = pca.components_
print(pca_comp)
