import pandas as pd
from sklearn.preprocessing import OneHotEncoder
import numpy as np
from pystruct.models import ChainCRF
from pystruct.learners import OneSlackSSVM
import pickle

# load train data

xTrain = []
yTrain = []
for f in ['data/train-%d.txt' % (i+1) for i in range(5000)]:
    data = pd.read_csv(f, header=None, quoting=3)
    labels = data[1]
    features = data.values[:, 2:].astype(np.int)
    for f_idx in range(len(features)):
      f1 = features[f_idx]
      features[f_idx] = [f1[0]-1, f1[1], f1[2], f1[3]-1, f1[4]-1]
    yTrain.append(labels.values - 1)
    xTrain.append(features)

# load test data

xTest = []
yTest = []
for f in ['data/test-%d.txt' % (i+1) for i in range(1000)]:
    data = pd.read_csv(f, header=None, quoting=3)
    labels = data[1]
    features = data.values[:, 2:].astype(np.int)
    for f_idx in range(len(features)):
      f1 = features[f_idx]
      features[f_idx] = [f1[0]-1, f1[1], f1[2], f1[3]-1, f1[4]-1]
    yTest.append(labels.values - 1)
    xTest.append(features)

# encode features

encoder = OneHotEncoder(n_values=[1,2,2,201,201],sparse=False).fit(np.vstack(xTrain))                 
xTrain = [encoder.transform(x) for x in xTrain]
xTest = [encoder.transform(x) for x in xTest]  

# save data

trainList = [xTrain,yTrain]
with open('data_python/train', 'wb') as _file:
    pickle.dump(trainList, _file)
testList = [xTest,yTest]
with open('data_python/test', 'wb') as _file:
    pickle.dump(testList, _file)
