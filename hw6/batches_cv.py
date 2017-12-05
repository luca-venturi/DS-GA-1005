import numpy as np
import pickle
from pystruct.models import ChainCRF
from pystruct.learners import OneSlackSSVM
from sklearn.model_selection import cross_val_score
import matplotlib.pyplot as plt

# load data

with open ('data_python/train', 'rb') as _file:
    [xTrain,yTrain] = pickle.load(_file)
with open ('data_python/test', 'rb') as _file:
    [xTest,yTest] = pickle.load(_file)
xVal = xTrain[-50:]
yVal = yTrain[-50:]
xTrain = xTrain[:4500]
yTrain = yTrain[:4500]
    
# cross validation

chain = ChainCRF(n_states=10,inference_method='max-product',directed=True)
K = 10
cRange = [2**(i-K) for i in range(2*K+1)]
error = {}
bC = {}

bRange = [100,200,500,1000,4500]
for b in bRange[:-1]:
	score = {}
	for C in cRange:
		ssvm = OneSlackSSVM(chain, max_iter=200, C=C)
		ssvm.fit(xTrain[:b],yTrain[:b])
		score[C] = ssvm.score(xVal,yVal)
		print('b = ', b, 'C = ', C, ' -> ', score[C])
	bC[b] = min(score, key=score.get)
	error['train',b] = 1. - score[bC[b]]
	
# test error

for b in bRange[:-1]:
	ssvm = OneSlackSSVM(chain, max_iter=200, C=bC[b])
	ssvm.fit(xTrain[:b],yTrain[:b])
	error['test',b] = 1. - ssvm.score(xTest,yTest)

# get 4500 batch size scores 

tmp = bRange[-1]
with open ('data_python/cv_results', 'rb') as _file:
    [bC[tmp],error['train',tmp],error['test',tmp]] = pickle.load(_file)

# plot

plt.title('CV and test error vs. training set size')
plt.xlabel('training set size')
plt.ylabel('misclassification error')
plt.plot(bRange,[error['train',b] for b in bRange],label='cv')
plt.plot(bRange,[error['test',b] for b in bRange],label='test')
plt.legend()
plt.show() #
plt.savefig('cv_test_error', bbox_inches='tight')
