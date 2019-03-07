import math
import sys
import argparse
import pandas as pd
import numpy as np
import random
from scipy.stats import norm

parser = argparse.ArgumentParser()

parser.add_argument('-m', dest="model", required=True, metavar="FILE") # model 

parser.add_argument('-t', dest="test", required=True, metavar="FILE") # test 
parser.add_argument('-d', dest="decoy", required=True, metavar="FILE") # decoy  

args = parser.parse_args()

model = open(args.model, 'rb')
test = open(args.test, 'rb')
decoy = open(args.decoy, 'rb')

model_tab = np.loadtxt(model, delimiter='\t') # model seems to be loaded in properly 

# calculate the fuckings score
def calcSeqScore(line, model_tab):
   seqScore = 0 
   rowIndex = ['A', 'G', 'C', 'T']

   for col in range(0, len(line)): # looping through position --> column in the training matrix 
      row = rowIndex.index(line[col])
      nucScore = model_tab[row][col]
      
      nucScore = math.log2(nucScore)
      seqScore = seqScore + nucScore
   
   return seqScore


# to the the fucking test array 
testArray = []
testScoreArray = []
for line in test.readlines():
   line = line.strip()
   line = line.decode("utf-8")

   testArray.append(line)
   seqScore = calcSeqScore(line, model_tab)
   
   testScoreArray.append(seqScore)
 
# decoy lines 
decoyArray = []
# totalArray = []
decoyScoreArray = []
for line in decoy.readlines():
   line = line.strip()
   line = line.decode("utf-8")

   if line not in testArray:
      decoyArray.append(line)
      seqScore = calcSeqScore(line, model_tab)
   
      decoyScoreArray.append(seqScore)

totalScore = testScoreArray + decoyScoreArray

uniqueScore = list(set(totalScore))
uniqueScore.sort()
# Finding the scores 
TP = []
FP = []

TN = []
FN = []
FDR = []

testScoreArray = np.array(testScoreArray)
decoyScoreArray = np.array(decoyScoreArray)

#pvalsList = []
#s = np.std(decoyScoreArray) # use the decoy to draw the norm 
#m = np.mean(decoyScoreArray) # use the decoy to draw the norm 

for score in uniqueScore: 
   TP.append(sum(testScoreArray > score))
   FP.append(sum(decoyScoreArray > score))
   
   TN.append(len(decoyScoreArray) - sum(decoyScoreArray > score))
   FN.append(len(testScoreArray)- sum(testScoreArray > score))
   #pval = 1 - norm.cdf(score, m, s)
   #pvalsList.append(pval)

   FDR.append(FP[-1] / (FP[-1] + TP[-1]))

dataframe_dict = {"#thresh":uniqueScore, "TP":TP, "FP":FP, "TN":TN, "FN":FN, "FDR":FDR}

dataframe_return = df = pd.DataFrame(dataframe_dict)
print(dataframe_return)
