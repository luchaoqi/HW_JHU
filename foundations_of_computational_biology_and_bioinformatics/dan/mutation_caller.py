'''
Da Peng 
dpeng5
Practical 4

The script will first take in the argument parse 
iterate through the normal bam and cancer bam via identifying the low coverage position 
iterate normal to identify the log(likelihood) that is -50
iterate cancer to identify ones with log likelihood that is -75 to identify the candidate somatic mutation 
'''
import pysam
import math
import sys
import argparse
import numpy as np

# yo lazy fuck, write some error catching mechanism 
# use try and except for the fucking unexpected shit 

parser = argparse.ArgumentParser()
parser.add_argument('-n', dest="normal", required=True, metavar="FILE") # normal 
parser.add_argument('-c', dest="cancer", required=True, metavar="FILE") # cancer 
args = parser.parse_args()

cancerBamfile = pysam.AlignmentFile(args.cancer, "rb")
normalBamfile = pysam.AlignmentFile(args.normal, "rb")

# let's figure out the fucking cancer pile up first 
badPileUp_cancer = []
goodPileUp_cancer = {}

# first do the cancer one 
for pileupcolumn in cancerBamfile.pileup():
   if pileupcolumn.n < 20:
      badPileUp_cancer.append(pileupcolumn.pos)

   else: 
      tempCol = []
      for pileupread in pileupcolumn.pileups:

         if not pileupread.is_del and not pileupread.is_refskip:
            tempCol.append(pileupread.alignment.query_sequence[pileupread.query_position])
      goodPileUp_cancer[pileupcolumn.pos] = tempCol


# the below is to figure out the normal pileup 
badPileUp_normal = []
goodPileUp_normal = {}

for pileupcolumn in normalBamfile.pileup():
   if pileupcolumn.n < 20:
      badPileUp_normal.append(pileupcolumn.pos)
   else:
      tempCol = []
      for pileupread in pileupcolumn.pileups:
         if not pileupread.is_del and not pileupread.is_refskip:
            tempCol.append(pileupread.alignment.query_sequence[pileupread.query_position])
      goodPileUp_normal[pileupcolumn.pos] = tempCol

# pop bad cancer in normal dictionary
for item in badPileUp_cancer:
   if item in goodPileUp_normal.keys():
      goodPileUp_normal.pop(item)


# pop bad normal in cancer dictionary 
for item in badPileUp_normal:

   if item in goodPileUp_cancer.keys():
      goodPileUp_cancer.pop(item)

combinedPos = badPileUp_cancer + badPileUp_normal
for pos in np.unique(combinedPos):
   print("Insufficient coverage at position ", pos)

# this is for calculating all the 
def calc_likelihood (querySeq):
   e = 0.1
   nucPairs = ['AA', 'CC', 'GG', 'TT', 'AC', 'AG', 'AT', 'CG', 'CT', 'GT']
   returnArray = []

   for nuc_pair in nucPairs: 
      nuc1 = nuc_pair[0]
      nuc2 = nuc_pair[1]

      tempAns = 1
      for nuc in querySeq:
         if nuc1 == nuc:
            prob1 = (1 - e)
         elif nuc1 != nuc:
            prob1 = (e/3)
         
         if nuc2 == nuc: 
            prob2 = (1 -e)
         elif nuc2 != nuc:
            prob2 = (e/3)
         
         tempAns = tempAns * ((1/2) * prob1 + (1/2) * prob2)
      returnArray.append(tempAns)

   return returnArray

normal_maxProb = {}

nucPairs = ['AA', 'CC', 'GG', 'TT', 'AC', 'AG', 'AT', 'CG', 'CT', 'GT']
for key in goodPileUp_normal.keys():
   tempLikelihood = calc_likelihood(goodPileUp_normal[key])

   # just to print out the number of positions that are not that good 
   if math.log(max(tempLikelihood)) < -50:
      print("Position ", key, " has ambiguous genotype.")
   else:
     normal_maxProb[key] =  nucPairs[tempLikelihood.index(max(tempLikelihood))]


for key in normal_maxProb.keys():
   # get the index of the nucleotide 
   index = nucPairs.index(normal_maxProb[key])
   tempLikelihood = calc_likelihood(goodPileUp_cancer[key])

   if math.log(tempLikelihood[index]) < -75:
      print("Position ", key, " has a candidate somatic mutation (Log-likelihood=", math.log(tempLikelihood[index]), ")")





   

