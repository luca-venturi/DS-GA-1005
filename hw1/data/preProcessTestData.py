import numpy as np
import pickle as pc

def preProcessTestData(filename):

# read the file in a list mailSet

	mail = []
	with open(filename, "r") as testFile:
		for line in testFile:
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
	
# import the (training set) vocabulary
	
	with open('trainVoc', 'rb') as trainVocFile:
		voc = pc.load(trainVocFile)
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

	return voc, mail, nHam, nSpam, nVoc

# preProcess 'test'

voc, mail, nHam, nSpam, nVoc = preProcessTestData('test')

# write 'testVoc'

with open('testVoc', 'wb') as testVocFile:
    pc.dump(voc, testVocFile)

# write 'testMail'

with open('testMail', 'wb') as testMailFile:
    pc.dump(mail, testMailFile)

# write 'testHSV'

with open('testHSV', 'wb') as testHSVFile:
    pc.dump([nHam, nSpam, nVoc], testHSVFile)
