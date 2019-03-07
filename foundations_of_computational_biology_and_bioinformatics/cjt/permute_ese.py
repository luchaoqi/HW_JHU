'''
JHED: jcai14

Description:
This is a script for permuting the sequence

Input:
-f, --inputfile: the sequence file needed to be permuted
-o, --outputfile: the permuted file name
-t, --trustedfile: the trusted sequence file believed to be positive sample, permuted sequence which is supposed to be negetive sample should not overlap with it.

Output:
The permuted sequence file
'''

#!/usr/bin/env python
import argparse
import sys
from random import shuffle
from random import seed

seed(101)

inputfile = 'ese_training.txt'
outputfile = 'ese_training_shuffle.txt'

def main():
	parser = argparse.ArgumentParser(description='Shuffle the sequence')
	parser.add_argument('-f','--inputfile',help='input file path',default='ese_test.txt',required=True)
	parser.add_argument('-o','--outputfile',help='output file path', default='permuted_ese.txt',required=True)
	parser.add_argument('-t','--trustedfile',help='trusted sequence file to ensure the decoys truly decoys', default='trusted_ESE.txt',required=True)
	args = parser.parse_args()

	try:
		# read in files
		filehandle = open(args.inputfile,'r')
		dat = filehandle.readlines()
		filehandle.close()

		filehandle = open(args.trustedfile,'r')
		trustdat = filehandle.readlines()
		trustseq = [s.replace('\n','') for s in trustdat]
	except Exception as error:
		sys.stderr.write('Input error:{0}'.format(str(error)))
		return

	# open out files
	try:
		outhandle = open(args.outputfile,'w')
	except Exception as error:
		sys.stderr.write('Output error:{0}'.format(str(error)))
		return

	for seq in dat:
		seqlist = list(seq.rstrip())
		shuffle(seqlist)
		seqshuffle = ''.join(seqlist)

		if seqshuffle in trustseq:
            #print('shuffled sequence ',seqshuffle,' has existed in trusted_ESE.txt')
			continue
		outhandle.write(seqshuffle)
		outhandle.write('\n')

	outhandle.close()
	return

if __name__=='__main__':
	main()
