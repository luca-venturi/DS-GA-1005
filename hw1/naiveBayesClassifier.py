from __future__ import division
import numpy as np
import pickle as pc

# load the (preProcessed) train files

with open('data/trainMail', 'rb') as trainMailFile:
	trMail = pc.load(trainMailFile)
with open('data/trainVoc', 'rb') as trainVocFile:
	voc = pc.load(trainVocFile)
with open('data/trainHSV', 'rb') as trainHSVFile:
	trHSV = pc.load(trainHSVFile)
trNham = trHSV[0]
trNspam = trHSV[1]
nVoc = trHSV[2]
trNmail = trNham + trNspam
trHam = trMail[:trNham]
trSpam = trMail[-trNspam:]

# compute the prior probabilities pSpam = P(spam) and pHam = P(ham)

pSpam = trNspam / trNmail
pHam = trNham / trNmail

print pSpam

# compute the conditional probabilities pGivenSpam = P(w_i|spam) and pGivenHam = P(w_i|ham)

pGivenSpam = np.zeros((nVoc))
pGivenHam = np.zeros((nVoc))
nTot = np.sum(np.sum(trMail))
m = 1
for n in range(nVoc):
	ncS = 0
	ncH = 0 
	for k in range(trNspam):
		ncS += trSpam[k][n]
	for k in range(trNham):
		ncH += trHam[k][n]
	pGivenSpam[n] = (m + ncS) / (nTot + nVoc*m)
	pGivenHam[n] = (m + ncH) / (nTot + nVoc*m)

# print the 5 most likely words given spam/ham

mostLikeGivenSpamIndex = np.argsort(pGivenSpam)[-5:][::-1]
mostLikeGivenSpam = [voc[n] for n in mostLikeGivenSpamIndex]

print mostLikeGivenSpam

mostLikeGivenHamIndex = np.argsort(pGivenHam)[-5:][::-1]
mostLikeGivenHam = [voc[n] for n in mostLikeGivenHamIndex]

print mostLikeGivenHam

# load the (preProcessed) test files

with open('data/testMail', 'rb') as testMailFile:
	teMail = pc.load(testMailFile)
with open('data/testHSV', 'rb') as testHSVFile:
	teHSV = pc.load(testHSVFile)
teNham = teHSV[0]
teNspam = teHSV[1]
teHam = teMail[:teNham]
teSpam = teMail[-teNspam:]

# classify the test file and compute the accuracy of the algorithm

def classify(mail):
	
	spam = np.log(pSpam)	
	ham = np.log(pHam)
	for n in range(nVoc):	
		if mail[n] == 0:
			spam += np.log(1-pGivenSpam[n])
			ham += np.log(1-pGivenHam[n])
		else:			
			spam += np.log(pGivenSpam[n])
			ham += np.log(pGivenHam[n])
	if spam > ham:
		return 1
	else:
		return 0

def accuracy(testSpam,testHam):
	
	nS = len(testSpam)
	nH = len(testHam)
	acc = 0
	for n in range(nS):
		if classify(testSpam[n]) == 1:
			acc += 1
	for n in range(nH):
		if classify(testHam[n]) == 0:
			acc += 1

	return (acc / (nS + nH))

print accuracy(teSpam,teHam)

