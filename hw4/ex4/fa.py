import numpy as np

def FactorAnalysis(data,n_components,nIter=20):
	
	n_samples, n_features = data.shape
	variances = np.ones(n_features, dtype=data.dtype)
	dataVariance = np.var(data, axis=0)
	eps = 1e-12
	for _ in range(nIter):
		std_deviations = np.sqrt(variances) + eps
		_, s, v = np.linalg.svd(data / std_deviations)
		s = s[:n_components] ** 2
		components = np.sqrt(np.maximum(s - 1., 0.))[:, np.newaxis] * v[:n_components]
		components *= std_deviations
		variances = np.maximum(dataVariance - np.sum(components ** 2, axis=0), eps)
		
	return components, variances, components.T
