"""
HW3
Question 4 Factor Analsys.
@author: Vlad, Rahul
"""

from matplotlib.pylab import plt
import os,sys
import numpy as np
from sklearn import decomposition  

with open('personality0.txt') as f:
    headers = [k.strip().replace('"','') for k in f.readline().split(' ')]
print ('Headers: ',headers,len(headers))
data = np.loadtxt('personality0.txt',usecols=range(1,len(headers)+1),skiprows=1)
assert data.shape==(240,len(headers))

R = np.corrcoef(data.T)
plt.figure(figsize=(10,8))
plt.pcolor(R)
plt.colorbar()
plt.xlim([0,len(headers)])
plt.ylim([0,len(headers)])
plt.xticks(np.arange(32)+0.5,np.array(headers),rotation='vertical')
plt.yticks(np.arange(32)+0.5,np.array(headers))
plt.show()

# Lets fit both the models using PCA/FA down to two dimensions. 
# This is to test my implementation. sklearn is used

n_components = 2
U, s, V = np.linalg.svd(data-data.mean(axis=0))
pca_comp =  V[range(n_components),:].T
data_pca  = U [:,range(n_components)]
fa = decomposition.FactorAnalysis(n_components=n_components, max_iter=20)
fa.fit(data)
data_fa = fa.transform(data)
fa_comp = fa.components_.T

print(data_pca.shape, data_fa.shape)
print(pca_comp.shape, fa_comp.shape)

N = 10
def plot_scatter_annotate(data,labels,title):
    plt.figure(figsize=(10,10))
    assert data.shape[0]==len(labels),'size mismatch'
    plt.subplots_adjust(bottom = 0.1)
    plt.scatter(
        data[:, 0], data[:, 1], marker = 'o', s = 100,
        cmap = plt.get_cmap('Spectral'))
    plt.title(title)
    for label, x, y in zip(labels, data[:, 0], data[:, 1]):
        plt.annotate(
            label, 
            xy = (x, y), xytext = (-20, 20),
            textcoords = 'offset points', ha = 'right', va = 'bottom',
            bbox = dict(boxstyle = 'round,pad=0.5', fc = 'yellow', alpha = 0.5),
            arrowprops = dict(arrowstyle = '->', connectionstyle = 'arc3,rad=0'))
    plt.savefig(title, bbox_inches='tight') # added
    plt.show()
    
np.random.seed(1)
idxlist = np.random.permutation(len(headers))[:15]
dset_pca = pca_comp[idxlist]
dset_fa = fa_comp[idxlist]
hdr_sub = [headers[k] for k in idxlist.tolist()]
plot_scatter_annotate(dset_pca,hdr_sub,'Visualizing Principle Components from PCA')
plot_scatter_annotate(dset_fa,hdr_sub,'Visualizing Factor Loading Matrix from Factor Analysis - sklearn')
