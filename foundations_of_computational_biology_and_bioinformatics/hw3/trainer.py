"""
Practical 3, Exercise 1

This code uses a training set of sequences to train a zero-order Markov chain model. This trainer will write its model to disk in a tab-delimited format (.txt file).

To run trainer.py the following can be typed into the terminal:
python3 trainer.py -f input_sequence_file.fa -o output_model_file.txt
where "input_sequence_file.fa" can be, for example, ESE.txt
Run as python3 trainer.py -f ESE.txt -o output_model_file.txt
Our submission folder also includes the ESE.txt file for convenience.
"""

import sys
import numpy as np
import pandas as pd
import argparse

#read in input and output arguments
def get_args():
	parser = argparse.ArgumentParser()
	parser.add_argument("-o",type=str)
	parser.add_argument("-f",type=str)
	args = parser.parse_args()
	
	return args

args = get_args()

file = open(args.f)
lines = file.readlines()
outFileName = args.o

#lines = sys.stdin.readlines()

#count how many ESEs are in training set and length of ESE (assume uniform length)
num_ESE = 0
ESE_length = 0

for line in lines:
	num_ESE += 1
	ESE_length = len(line) - 1 # account for newline character

aa_map = {'A': 0, 'T': 1, 'G': 2, 'C': 3}

out_table = np.zeros(shape=(4,ESE_length))
for line in lines:
	line = line.strip()
	for i in range(ESE_length):
		out_table[aa_map[line[i]],i] += 1

"""
Table format:
	1	2	3	4	...	# of final position on ESE
A
T
G
C
"""
probtable = out_table/num_ESE

#creating labels for table (rows = ATGC, columns = position in ESE)
row_labels = (["A","T","G","C"])
column_labels = list(range(1,ESE_length+1))

#convert into data frame
out_probtable = pd.DataFrame(probtable, columns = column_labels, index = row_labels)

pd.DataFrame(out_probtable).to_csv(outFileName,sep="\t")

#print(out_probtable)


