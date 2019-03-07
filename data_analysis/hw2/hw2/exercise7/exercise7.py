import sys
import os
import argparse
from typing import List
import numpy as np
import pandas as pd
from sklearn.linear_model import LogisticRegression
from statsmodels.discrete.discrete_model import Logit
from statsmodels.stats.multitest import multipletests
from sklearn.linear_model import Ridge

parser = argparse.ArgumentParser()
parser.add_argument("--X", action='store')
parser.add_argument("--Y", action='store')
parser.add_argument("--testX", action='store')
parser.add_argument("--testY", action='store')
parser.add_argument("--output", action='store')
args = parser.parse_args()


a = [0,0.1,1,10,100]

x = pd.read_csv(args.X,header=0).iloc[:,1:].T
y = pd.read_csv(args.Y,header=0).iloc[:,1]
testX = pd.read_csv(args.testX,header=0).iloc[:,1:].T
testY = pd.read_csv(args.testY,header = 0).iloc[:,1]
testY = np.array(testY)
output = args.output

errors = {}
n = 0
for i in a:
    clf = Ridge(alpha=i)
    clf.fit(x, y)
    prediction = clf.predict(testX)
    prediction = np.array(prediction)
    errors[i] = sum((prediction - testY)**2)
    n +=1
amin = list(errors.keys())[list(errors.values()).index(min(errors.values()))]
print("optimal a:", amin)
clf = Ridge(alpha=amin)
clf.fit(x, y)
betas = clf.coef_
with open(output,'w') as f:
    for i in betas:
        f.write('%s \n' %(i))
f.close()




