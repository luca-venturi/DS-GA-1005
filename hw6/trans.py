import random
import numpy as np
import pickle
from pystruct.models import ChainCRF
from pystruct.learners import OneSlackSSVM

# load the stored model

with open('data_python/cv_learned_model', 'rb') as _file:
    ssvm = pickle.load(_file)
w = ssvm.w      

# choose classes and print transition parameter

k = 10
tag = np.array(['verb','noun','adjective','adverb','preposition','pronoun',
	'determiner','number','punctuation','other'])
cl = random.sample(range(k),3)
cl.sort()
print('Chosen classes: ',tag[cl])
trans = w[-k**2:]
print('Transition weights:')
for i in cl:
	for j in cl:
		print(tag[i],' -> ',tag[j],' : ',w[i*k + j])

# load features names

names = ['Bias','Not Initial Capital','Initial Capital',
	'Not All Capitals','All Capitals']
with open('prefixes.txt') as _file:
    tmp = _file.readlines()
pre = [x.strip() for x in tmp]
for i in range(len(pre)):
	names.append('Prefix: '+pre[i]) 
with open('suffixes.txt') as _file:
    tmp = _file.readlines()
suf = [x.strip() for x in tmp] 
for i in range(len(pre)):
	names.append('Suffix: '+suf[i]) 

# look for most relevant features

feat = w[:-k**2]
m = int(len(feat) / k)
feat = [feat[i*m:(i+1)*m] for i in range(k)]
for i in cl:
	tmp = np.abs(np.array(feat[i]))
	tmp = np.argsort(tmp)[-10:][::-1]
	print('Most relevant features for tag ',tag[i],' :')
	print([names[j] for j in tmp]) 

