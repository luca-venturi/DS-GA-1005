import numpy as np
import pickle
from pystruct.models import ChainCRF
from pystruct.learners import OneSlackSSVM
from sklearn.model_selection import cross_val_score

# load data

with open ('data_python/train', 'rb') as _file:
    [xTrain,yTrain] = pickle.load(_file)
with open ('data_python/test', 'rb') as _file:
    [xTest,yTest] = pickle.load(_file)
   
# cross validation

chain = ChainCRF(n_states=10,inference_method='max-product',directed=True)
K = 10
cRange = [2**(i-K) for i in range(2*K+1)]
score = {}

for C in cRange:
	ssvm = OneSlackSSVM(chain, max_iter=200, C=1)
	ssvm.fit(xTrain[:450],yTrain[:450])
	score[C] = ssvm.score(xTrain[-50:],yTrain[-50:])
	print( 'C = ', C, ' -> ', score[C])

bC = min(score, key=score.get)
print(bC)

# test error

ssvm = OneSlackSSVM(chain, max_iter=200, C=1)
ssvm.fit(xTrain,yTrain)
error = 1. - ssvm.score(xTest,yTest)    
