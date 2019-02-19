import sys
import os
import argparse
import numpy as np
import pandas as pd
from sklearn.linear_model import LogisticRegression

from statsmodels.discrete.discrete_model import Logit
from statsmodels.stats.multitest import multipletests
from sklearn.linear_model import Ridge


parser = argparse.ArgumentParser()
parser.add_argument("--X", action='store', dest="p1")
parser.add_argument("--output", action='store', dest="p2")
args = parser.parse_args()

#phenotype = pd.read_csv('phenotype.csv',header = 0) #args.p1
#phenotype = pd.read_csv(args.p1,header = 0)
genotype = pd.read_csv(args.p1,header = 0)
dataname = genotype.columns.values[1:]
#genotype = np.array(genotype.iloc[:,1:])
n = 279*2
dic = {}
j = 0
for i in dataname:
    num_A = 0
    num_B = 0
    num_A += 2*sum(genotype[dataname[j]] == 0) + sum(genotype[dataname[j]] == 1)
    num_B += 2*sum(genotype[dataname[j]] == 2) + sum(genotype[dataname[j]] == 1)
    freq_A = num_A/n
    freq_B = num_B/n
    j += 1
    dic[str(i)] = min(freq_A, freq_B)
print('Number of SNPs having MAF larger than 0.03:',sum(i > 0.03 for i in dic.values()))
print('Number of SNPs having MAF larger than 0.05:',sum(i > 0.05 for i in dic.values()))
print('Number of SNPs having MAF larger than 0.1:',sum(i > 0.1 for i in dic.values()))


#with open('Q6_a_output.txt','w') as f: #args.p2
with open(args.p2,'w') as f: #args.p2
    for key, value in dic.items():
        f.write('%s \t %s\n' %(key, value))
f.close()



