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
	ssvm = OneSlackSSVM(chain, max_iter=200, C=C)
	ssvm.fit(xTrain[:4500],yTrain[:4500])
	score[C] = ssvm.score(xTrain[-500:],yTrain[-500:])
	print( 'C = ', C, ' -> ', score[C])

bC = max(score, key=score.get)
print('best C = ', bC)

# test error

ssvm = OneSlackSSVM(chain, max_iter=200, C=bC)
ssvm.fit(xTrain,yTrain)
with open('data_python/learned_model', 'wb') as _file:
    pickle.dump(testList, ssvm)
error = 1. - ssvm.score(xTest,yTest)
print('test error -> ', error)   
