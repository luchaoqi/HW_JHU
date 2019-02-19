"""
Homework 1 Question 2

Group members:
Saki Fujita (sfujita2)
Chuheng Chen (cchen217)
Vorada Sakulsaengprapha (vsakuls1)

This script evaluates the performance of a zero-order Markov chain model (output_model_file.txt, which is included in the submission) to discriminate between experimentally determined ESE binding sites and decoys (multinomial.txt or permutation.txt, which are included).

To run this scipt, type in command line:
python3 evaluator.py -m output_model_files.txt -t ese_test.txt -d decoys.txt (use one of the two decoys)

output_model_file.txt can be run with ESE_training.txt as input using trainer.py. This script also include pseudocount in case of p(x_i) = 0. It can be run using the following in the command line:
python3 trainer.py -f ESE_training.txt -o output_model_file.txt

multinomial.txt can be run with ESE_test.txt as input using multinomial_null.py, using the following in the command line:
python3 multinomial_null.py -o multinomial.txt

permutation.txt can be run with ESE_test.txt as input using permute_ese.py, using the following in the command line:
python3 permute_ese.py -f ese_test.txt -o permutation.txt

"""

import sys
import numpy as np
import pandas as pd
import argparse

#read in input and output arguments
    
"""
file_model = open(args.m)
lines_model = file_model.readlines()
file_test = open(args.t)
lines_test = file_test.readlines()
file_decoy = open(args.d)
lines_decoy = file_decoy.readlines()
"""

def main():
    #take in input files    
    parser = argparse.ArgumentParser()
    parser.add_argument('-m','--infile',type=argparse.FileType('r'),required=True)
    parser.add_argument('-t','--esefile',type=argparse.FileType('r'),required=True)
    parser.add_argument('-d','--decoyfile',type=argparse.FileType('r'),required=True)

    args = parser.parse_args()
    infile = args.infile
    lines = infile.readlines()

    #count length (no. of columns in output_model_file.txt)
    row1 = lines[0]
    numcols = row1.count("\t") + 1
    probs = np.zeros(shape=(4,numcols), dtype=float)    
    

    for (line, i) in zip(lines, range(len(lines))):
        data = line.split()
        probs[i] = [float(d) for d in data]

    map_ = {'A': 0, 'G': 1, 'C': 2, 'T': 3}

    ese_scores = []
    decoy_scores = []
    esefile = args.esefile
    decoyfile = args.decoyfile

    #calculate S using S = sum(log2(p(x_i)) for ese and decoy files
    for seq in esefile:
        seq = seq.strip()
        if len(seq) != numcols:
            raise IndexError
        s = sum([np.log2(probs[map_[seq[i]],i]) for i in range(len(seq))])
        ese_scores.append(s)

    for seq in decoyfile:
        seq = seq.strip()
        if len(seq) != numcols:
            raise IndexError
        s = sum([np.log2(probs[map_[seq[i]],i]) for i in range(len(seq))])
        decoy_scores.append(s)

    #to make it easier to look at, we will sort the scores in increasing order before calculating other columns
    sys.stdout.write("#thresh TP FP TN FN FDR \n")
    merged_thresh = ese_scores + decoy_scores
    merged_thresh.sort()
    
    #comparing the thresholds, we can figure out TP, FP, TN, FN, and in effect FDR
    for thresh in merged_thresh:
        true_pos, false_pos, true_neg, false_neg = 0, 0, 0, 0
        for score in ese_scores:
            if score >= thresh:
                true_pos += 1
            else:
                false_neg += 1
        for score in decoy_scores:
            if score >= thresh:
                false_pos += 1
            else:
                true_neg += 1
        fdr = float(false_pos) / (false_pos + true_pos)
        sys.stdout.write("%.3f %d %d %d %d %.3f \n" % (thresh, true_pos, 
                                false_pos, true_neg, false_neg, fdr))

#error handling - part of this is handled by argparse, and the rest we will throw an InconsistentLengthError or a General Exception
if __name__ == '__main__':
    try:
        main()
    except IndexError:
        sys.stdout.write('Error: length of sequences inconsistent. Please try again.\n')
        sys.exit(0)
    except Exception:
        sys.stdout.write('Error other than in argparse and index error. Please try again.\n')
        sys.exit(0)

