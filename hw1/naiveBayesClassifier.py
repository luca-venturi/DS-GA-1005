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

#### pGS, pGH

pGivenSpam = np.zeros((nVoc))
pGivenHam = np.zeros((nVoc))
nTot = np.sum(np.sum(trMail))
for n in range(nVoc):
	ncS = 0
	ncH = 0 
	for k in range(trNspam):
		ncS += trSpam[k][n]
	for k in range(trNham):
		ncH += trHam[k][n]
	pGivenSpam[n] = (1 + ncS) / (nTot + nVoc) #
	pGivenHam[n] = (1 + ncH) / (nTot + nVoc) #

#### most likely 5

mostLikeGivenSpamIndex = np.argsort(pGivenSpam)[-5:][::-1]
mostLikeGivenSpam = [voc[n] for n in mostLikeGivenSpamIndex]

print mostLikeGivenSpam

mostLikeGivenHamIndex = np.argsort(pGivenHam)[-5:][::-1]
mostLikeGivenHam = [voc[n] for n in mostLikeGivenHamIndex]

print mostLikeGivenHam
