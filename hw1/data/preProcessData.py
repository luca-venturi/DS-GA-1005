import numpy as np
import pickle as pc

def preProcessTrainData(filename):

# read the file in a list mailSet

	mail = []
	with open(filename, "r") as trainFile:
		for line in trainFile:
			mail.append(line.split())
	nMail = len(mail)
	
# erase the first line
	
	old = mail
	mail = []
	for n in range(nMail):
		mail.append(old[n][1:])

# order: first spam, second ham

	nHam = 0
	for n in range(nMail):
		if mail[n][0] == 'ham':
				nHam += 1
	nSpam = nMail - nHam
	mail.sort(key=lambda x: x[0])
	
	old = mail
	mail = []
	for n in range(nMail):
		mail.append(old[n][1:])
	
# create a vocabulary
	
	voc = []
	for i in range(nMail):
		wordIndex = [2*k for k in range(len(mail[i])/2)]
		for j in wordIndex: 
			word = mail[i][j]
			voc.append(word)
	voc = list(set(voc))
	voc.sort()
	nVoc = len(voc)

# re-arrange the data as number of occurences of words in voc

	mailWord = []
	mailCount = []
	for i in range(nMail):
		wordLine = [mail[i][2*k] for k in range(len(mail[i])/2)]
		countLine = [int(mail[i][2*k+1]) for k in range(len(mail[i])/2)]
		mailWord.append(wordLine)
		mailCount.append(countLine)
	mail = []
	for i in range(nMail):
		wordCount = []
		for j in range(nVoc):
			try:
				pos = mailWord[i].index(voc[j])
			except ValueError:
				pos = -1
			if pos == -1:
				wordCount.append(0)
			else:
				wordCount.append(mailCount[i][pos])
		mail.append(wordCount)
	#	
	print mailCount[0][mailWord[0].index('enron')]
	print mail[0][voc.index('enron')]

	return voc, mail, nHam, nSpam, nVoc

# preProcess 'train'

voc, mail, nHam, nSpam, nVoc = preProcessTrainData('train')

#print mail[:][voc.index('enron')]

# write 'trainVoc'

with open('trainVoc', 'wb') as trainVocFile:
    pc.dump(voc, trainVocFile)

# write 'trainMail'

with open('trainMail', 'wb') as trainMailFile:
    pc.dump(mail, trainMailFile)

# write 'trainHSV'

with open('trainHSV', 'wb') as trainHSVFile:
    pc.dump([nHam, nSpam, nVoc], trainHSVFile)
