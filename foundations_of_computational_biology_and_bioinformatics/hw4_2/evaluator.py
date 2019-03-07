'''

LuchaoQi 
JHED ID:lqi9
Pratical04
Usage: python3 evaluator.py -m output_model_file.txt -t ese_test.txt -d permuted_ese.txt
Evaluate the performance of discriminating between trusted ESEs and decoys. It will also give give FDRs. 


'''

#!/usr/bin/env python

import pandas as pd
import numpy as np
import argparse
import math
import sys
from fractions import Fraction

#input error checking
if len(sys.argv) != 7 or not sys.argv[1].startswith('-') or not sys.argv[3].startswith('-') or not sys.argv[5].startswith('-'):
        sys.stdout.write('Usage: python3 evaluator.py -m output_model_file.txt -t ese_test.txt -d permuted_ese.txt\n')
        sys.exit()
if not sys.argv[2].endswith('.txt'):
        sys.stdout.write('Please input .txt file\n')
        sys.exit()
if not sys.argv[4].endswith('.txt'):
        sys.stdout.write('Please input .txt file\n')
        sys.exit()
if not sys.argv[6].endswith('.txt'):
        sys.stdout.write('Please input .txt file\n')
        sys.exit()





def get_score(inputfile,model):
	# read in files
	try:
		filehandle = open(inputfile,'r')
		dat = filehandle.readlines()
		filehandle.close()

		modellen = model.shape[1]
		scorelist = []
		for seq in dat:
			seqlist = list(seq.rstrip())

			# error detection
			if len(seqlist)!=modellen:
				sys.stderr.write('Sequence error: Input sequence {0} length is not consistant with model\n'.format(seq.rstrip()))
				continue
			if len(set(seqlist)|set(['A','G','C','T']))>len(['A','G','C','T']):
				sys.stderr.write('Sequence error: Input sequence {0} contains unrecognized base\n'.format(seq.rstrip()))
				continue
			prob = 0
			for pos in range(len(seqlist)):
				base = seqlist[pos]
				fracstr = model.ix[base,pos].split('/')
				frac = (float(fracstr[0])+1)/(float(fracstr[1])+4)
				prob = prob + math.log2(frac)
			scorelist.append(prob)
		return(scorelist)

	except Exception as error:
		sys.stderr.write('Input sequence file error:{0}\n'.format(str(error)))
		return

def get_fdr(testscore,permutescore):
	testlabel = [1]*len(testscore)
	permutelabel = [0]*len(permutescore)
	wholescore = np.array(testscore + permutescore)
	wholelabel = np.array(testlabel + permutelabel)
	sortindex = np.argsort(wholescore)
	sortscore = wholescore[sortindex]
	sortlabel = wholelabel[sortindex]
	tplist = []
	fplist = []
	tnlist = []
	fnlist = []
	fdrlist = []
	for i in range(len(sortscore)):
		tn = sortlabel[0:i].tolist().count(1)
		fn = sortlabel[0:i].tolist().count(0)
		tp = sortlabel[i:].tolist().count(1)
		fp = sortlabel[i:].tolist().count(0)
		tplist.append(tp)
		fplist.append(fp)
		tnlist.append(tn)
		fnlist.append(fn)
		fdrlist.append(fp/(tp+fp))
	ret = {'#thresh':sortscore,'TP': tplist,'FP':fplist,'TN':tnlist,'FN':fnlist,'FDR':fdrlist}
	ret = pd.DataFrame(ret)
	return(ret)



def main():
	parser = argparse.ArgumentParser(description='Assess model')
	parser.add_argument('-m','--modelfile',required=True)
	parser.add_argument('-t','--testfile',required=True)
	parser.add_argument('-d','--permutefile',required=True)
	args = parser.parse_args()
	
	try:
		model = pd.read_csv(args.modelfile,sep='\t',header=None)
		model.index=['A','G','C','T']
	except Exception as error:
		sys.stderr.write('Input model error:{0}\n'.format(str(error)))
		return

	testscore = get_score(args.testfile,model)
	permutescore = get_score(args.permutefile,model)

	fdrtable = get_fdr(testscore,permutescore)
	print(fdrtable)
#	sys.stdout.write('#thresh\tTP\tFP\tTN\tFN\tFDR\n')
#	for index, row in fdrtable.iterrows():
#		sys.stdout.write('{0}\t{1}\t{2}\t{3}\t{4}\t{5}\n'.format(row[0],row[1],row[2],row[3],row[4],row[5]))

	return

if __name__=='__main__':
	main()

