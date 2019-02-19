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
parser.add_argument("--X", action='store', dest="traindata", help="training data ")
parser.add_argument("--Y", action='store', dest="trainresult", help="training data result")
parser.add_argument("--testX", action='store', dest="testdata", help="testing data")
parser.add_argument("--testY", action='store', dest="testresult", help="testing data result")
args = parser.parse_args()


# train model
train_expression = pd.read_csv(args.traindata,header=0) # train_expression.csv
#train_expression = pd.read_csv('train_expression.csv',header=0)
X = np.array(train_expression.T.iloc[1:,:])
phen_train = pd.read_csv('phen_train.csv',header=0) # phen_train.csv
Y = np.array(phen_train.iloc[:,1:]).reshape(145,)
model = LogisticRegression()
model.fit(X,Y)

# test model
test_expression = pd.read_csv(args.testdata, header=0) # test_expression.csv
#test_expression = pd.read_csv('test_expression.csv',header=0)
x = np.array(test_expression.T)[1:]
y_predic = model.predict(x).tolist()
phen_test = pd.read_csv('phen_test.csv',header = 0) # phen_test.csv
y = np.array(phen_test.iloc[:,1:])
y = list(map(int, y))

#evaluate model
TP = 0
TN = 0
FP = 0
FN = 0
for i in range(len(y)):
    if y[i] == 0 and y_predic[i] ==0:
        TN += 1
    if y[i] == 0 and y_predic[i] == 1:
        FP += 1
    if y[i] == 1 and y_predic[i] == 1:
        TP += 1
    if y[i] == 1 and y_predic[i] == 0:
        FN += 1
precision = TP/(TP+ FP)
recall = TP/(TP + FN)
print("Precision:", precision)
print("Recall:", recall)

#first 10 features
X2 = np.array(train_expression.T.iloc[1:,:10])
Y2 = np.array(phen_train.iloc[:,1:]).reshape(145,)
model.fit(X2,Y2)

# test model
test_expression = pd.read_csv(args.testdata, header=0) # test_expression.csv
#test_expression = pd.read_csv('test_expression.csv',header=0)
x = np.array(test_expression.T.iloc[1:,:10])
y_predic = model.predict(x).tolist()
phen_test = pd.read_csv('phen_test.csv',header = 0) # phen_test.csv
y = np.array(phen_test.iloc[:,1:])
y = list(map(int, y))

#evaluate model
TP = 0
TN = 0
FP = 0
FN = 0
for i in range(len(y)):
    if y[i] == 0 and y_predic[i] ==0:
        TN += 1
    if y[i] == 0 and y_predic[i] == 1:
        FP += 1
    if y[i] == 1 and y_predic[i] == 1:
        TP += 1
    if y[i] == 1 and y_predic[i] == 0:
        FN += 1
precision2 = TP/(TP+ FP)
recall2 = TP/(TP + FN)
print("Precision2:", precision2)
print("Recall2:", recall2)
