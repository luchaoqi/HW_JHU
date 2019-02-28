#!/user/bin/env python3
'''
JHED ID: lqi9
Pratical04
Usage: python3 mutation caller.py -n normal.bam -c cancer.bam
This python script process the normal bam file and can bam file. We tested  positions that have coverage larger t    han 20 on both normal.bam and cancer.bam files. Using simplified GATK mutation calling, we caculated the log-like    lihood of these positions and printed out the mutation results.
'''

import sys
import argparse
import pysam
import math

parser = argparse.ArgumentParser()
parser.add_argument("-n",type=str)
parser.add_argument("-c",type=str)
args = parser.parse_args()

normal  = pysam.AlignmentFile(args.n, 'rb')
cancer = pysam.AlignmentFile(args.c, 'rb')
p1 = {}#cancer
p2 = {}#normal
p = {}
cp = []#cancer pos
np = []#normal pos
pos = []
#report positions that have coverage less than 20 either in normal or cancer
#cancer positions
for pileupcolumn in cancer.pileup():
        if pileupcolumn.n < 20:
                cp.append(pileupcolumn.pos)
        else:
                for pileupread in pileupcolumn.pileups:
                        if not pileupread.is_del and not pileupread.is_refskip:
                                if pileupcolumn.pos in p1:
                                        p1[pileupcolumn.pos] = p1[pileupcolumn.pos] + pileupread.alignment.query_sequence[pileupread.query_position]
                                else:
                                        p1[pileupcolumn.pos] = pileupread.alignment.query_sequence[pileupread.query_position]
#normal positions
for pileupcolumn in normal.pileup():
        if pileupcolumn.n < 20 :
                np.append(pileupcolumn.pos)
        else:
                for pileupread in pileupcolumn.pileups:
                        if not pileupread.is_del and not pileupread.is_refskip:
                                if pileupcolumn.pos in p2:
                                        p2[pileupcolumn.pos] = p2[pileupcolumn.pos]+pileupread.alignment.query_sequence[pileupread.query_position]
                                else:
                                        p2[pileupcolumn.pos] = pileupread.alignment.query_sequence[pileupread.query_position]

#positions have coverage < 20
pos = list(set(cp+np))
numbers = [[ int(x) for x in pos ]]
for i in numbers[0]:
        sys.stdout.write("Insufficient coverage at position %s \n" %(i))




#positions have coverage >= 20
for i in p2.keys():
        if i in p1.keys():
                p[i] = p2[i]
print(p)



#likelihood function: x = pileups, y = genotype
e = 0.1
def like(x,y):
    p = 1
    for i in x:
        if i*2 == y : p = p*(1-e)
        elif i in y : p = p*(0.5*(1-e)+0.5*e/3)
        else : p = p*(e/3)
    return(p)

temp = ['AA','CC','GG','TT','AC','AG','AT','CG','CT','GT']


#identify the genotype having mle
mle ={}
for i in p:
        for j in temp:
                if like(p[i],j) == max(like(p[i],j) for j in temp):
                        mle[i] = j
print(mle)

#skip pos whoese log likelihood < -50
pos1 = [] #pos1 contains pos whoese log likelihood >= -50
for i in p:
	n = max(like(p[i],j) for j in temp)
	if math.log(n) < -50:
		sys.stdout.write("Position %s has ambiguous genotype \n" %(i))
	else:
		pos1 = pos1 + [i]

print(pos1)

for i in p1:
        if i in pos1:
                if math.log(like(p1[i],mle[i])) < -75:
                        sys.stdout.write("Position %s has a candidate somatic mutation (Log-likelihood=%s)\n"%(i,math.log(like(p1[i],mle[i]))))



normal.close()
cancer.close()

