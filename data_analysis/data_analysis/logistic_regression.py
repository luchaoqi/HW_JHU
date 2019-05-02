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
parser.add_argument("--ouput", action='store', dest="p2")
args = parser.parse_args()

phenotype = pd.read_csv('phenotype.csv',header = 0) #args.p1
#phenotype = pd.read_csv(args.p1,header = 0)
genotype = pd.read_csv('genotype.csv',header = 0)
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
    freq_A = num_A/(num_A+num_B)
    freq_B = num_B/(num_A+num_B)
    j += 1
    dic[str(i)] = min(freq_A, freq_B)
print('Number of SNPs having MAF larger than 0.03:',sum(i > 0.03 for i in dic.values()))
print('Number of SNPs having MAF larger than 0.05:',sum(i > 0.05 for i in dic.values()))
print('Number of SNPs having MAF larger than 0.1:',sum(i > 0.1 for i in dic.values()))

j = 0
ps = {}
for i in dic:
    if dic[i] >= 0.05:
        geno = np.array(genotype[i]).reshape(279,1)
        geno = np.pad(geno,((0,0),(1,0)),'constant',constant_values = ((0,0),(1,0)))
        pheno = np.array(phenotype.iloc[:,1]).reshape(279,1)
        logit_mod = Logit(pheno,geno)
        logit_res = logit_mod.fit()
        logit_res.summary()
        ps[i] = logit_res.llr_pvalue
#BH
pvalues = multipletests(list(ps.values()), alpha=0.05, method='fdr_bh')
# np.where(pvalues[0] == True)
with open('Q6_b_output.txt','w') as f:
    for i in np.where(pvalues[0] == True)[0]:
        f.write('%s \t %s\n' % (list(ps.keys())[i], list(ps.values())[i]))
f.close()


snp10 = 'rs4644459'
geno10 = np.array(genotype[snp10]).reshape(279,1)
geno10 = np.pad(geno10,((0,0),(1,0)),'constant',constant_values = ((0,0),(1,0)))
pheno10 = np.array(phenotype.iloc[:,1]).reshape(279,1)
logit_mod10 = Logit(pheno10,geno10)
logit_res10 = logit_mod10.fit()
logit_res10.summary()
beta0 = 0.1316
beta1 = -0.31

##loss function plotted in matlab
