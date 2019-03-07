#import sys
#import os
#import argparse
import numpy as np
import pandas as pd

f = open('trainSequence.txt','r')
ts = pd.DataFrame([[i for i in line.rstrip('\n')]for line in f]) #row data
f.close()
fo = []
f = open('featureOrder.txt','r')
for lines in f:
    fo.append(lines.rstrip('\n'))
f.close()

ts2 = [[0 for line in range(len(fo))] for line in range(ts.shape[0])]
for j in range(ts.shape[0]):
    i = 0
    s1 = ''.join(ts.iloc[j].values.tolist())
    for s2 in fo:
        n = s1.count(s2)
        ts2[j][i] = n
        i = i+1
ts2 = pd.DataFrame(ts2)#counted dataframe

x = np.mean(ts2)
y = np.std(ts2,ddof=1)

f = open('trainFeatures.txt','w')
for i in range(ts.shape[0]):
    for j in range(len(x)):
        c = (ts2.iloc[i,j] - x[j])/y[j]
        f.write(str(c) + '\t')
    f.write('\n')






