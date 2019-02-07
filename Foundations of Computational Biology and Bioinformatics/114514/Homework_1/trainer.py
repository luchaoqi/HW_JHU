"""
Practical 3, Exercise 1 - EDITED FOR HOMEWORK TO REMOVE HEADERS, CHANGE ORDER (now A, G, C, T), ADD PSEUDOCOUNT

Group members:
Saki Fujita (sfujita2)
Chuheng Chen (cchen217)
Vorada Sakulsaengprapha (vsakuls1)

This code uses a training set of sequences to train a zero-order Markov chain model. 
New: we also edited the table to account for p(x_i) = 0 by using pseudocount.
This trainer will write its model (with pseudocount) to disk in a tab-delimited format (.txt file).

To run trainer.py the following can be typed into the terminal:
python3 trainer.py -f input_sequence_file.fa -o output_model_file.txt
where "input_sequence_file.fa" for this case is "ese_training.txt"
Run as python3 trainer.py -f ese_training.txt -o output_model_file.txt
Our submission folder also includes the ese_training.txt and output_model_file.txt files for convenience.
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

def main():
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

	aa_map = {'A': 0, 'G': 1, 'C': 2, 'T': 3}

	out_table = np.zeros(shape=(4,ESE_length))
	for line in lines:
		line = line.strip()
		for i in range(ESE_length):
			out_table[aa_map[line[i]],i] += 1

	"""
	Table format:
		1	2	3	4	...	# of final position on ESE
	A
	G
	C
	T
	"""
	probtable = out_table/num_ESE
	pseudocountnum = out_table[:] + 1
	pseudocounttable = pseudocountnum/(num_ESE + 4)


	#creating labels for table (rows = ATGC, columns = position in ESE)
	#row_labels = (["A","G","C","T"])
	#column_labels = list(range(1,ESE_length+1))

	#convert into data frame
	#out_probtable = pd.DataFrame(probtable, columns = column_labels, index = row_labels)
	out_probtable = pd.DataFrame(pseudocounttable)
	pd.DataFrame(out_probtable).to_csv(outFileName,sep="\t",header=False, index=False)



	#print(out_probtable)

main()

