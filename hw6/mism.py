import random
import numpy as np
import pickle
import pandas as pd
from pystruct.models import ChainCRF
from pystruct.learners import OneSlackSSVM

# load the stored model

with open('data_python/cv_learned_model', 'rb') as _file:
    ssvm = pickle.load(_file)
with open ('data_python/test', 'rb') as _file:
    [xTest,yTest] = pickle.load(_file)
yPred = ssvm.predict(xTest)

# choose sentences 

tag = np.array(['verb','noun','adjective','adverb','preposition','pronoun',
	'determiner','number','punctuation','other'])
ch = np.sort(np.array(random.sample(range(1000),10)))
print('Chosen sentences: ', ch+1)
for i in ch:
	print('Sentence',i,':')
	_file = 'data/test-%d.txt' % (i+1)
	tmp = pd.read_csv(_file, header=None, quoting=3)
	sentence = np.array(tmp[0])
	wordCount = sentence.shape[0]
	print(sentence)
	real_tag = np.array(tmp[1])-1
	pred_tag = yPred[i]
	misCount = np.sum(real_tag != pred_tag)
	real_tag = np.array([tag[j] for j in real_tag])
	pred_tag = np.array([tag[j] for j in pred_tag])
	print('Real tag: ', real_tag)
	print('Predicted tag: ', pred_tag)
	print('Percentage of mismatches: ', misCount,'/',wordCount)
	

