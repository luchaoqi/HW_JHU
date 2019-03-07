#!/usr/bin/env python

"""
Modified trainer.py for pratical04 about Marcov Chain
Usage: python3 trainer.py -f ese_training.txt -o output_model_file.txt
"""

import pandas as pd
import numpy as np
import sys
import argparse


def main():
    
    parser = argparse.ArgumentParser()
    parser.add_argument('-f','--inputfile')
    parser.add_argument('-o','--outputfile')

    args = parser.parse_args()
    inputfile = args.inputfile
    outputfile = args.outputfile

    # read in files
    filehandle = open(inputfile,'r')
    dat = filehandle.readlines()
    filehandle.close()

    f = open(inputfile)
    dattxt = f.read()
    f.close()

    # count the majority length of the sequence
    seqlenlist = []
    for seq in dat:
        seqlen = len(seq.rstrip())
        seqlenlist.append(seqlen)
    counts = np.bincount(seqlenlist)
    seqlen = np.argmax(counts)

    # count all of the letters apears in the file
    dattxt = dattxt.replace('\n','')
    indcounts = {}
    for i in dattxt:
        indcounts[i] = dattxt.count(i)
    indletter = sorted(indcounts.keys())

    # count for every position
    countmatrix = np.zeros((len(indletter),seqlen))
    countframe = pd.DataFrame(countmatrix,index=sorted(indletter),columns=range(seqlen))
    for i in range(len(dat)):
        read = list(dat[i].rstrip())
        if len(read)==seqlen:
            for j in range(len(read)):
                countframe.ix[read[j],j] = countframe.ix[read[j],j] + 1
        else:
            sys.stderr.write('Error: wrong input sequence number, line {0} \n'.format(i+1))
            continue

    # get the probmatrix with fraction
    probframe = pd.DataFrame(0,index=sorted(indletter),columns=range(seqlen))
    countframesum = countframe.sum(0)
    for i in range(len(countframesum)):
        for j in sorted(indletter):
            probframe.ix[j,i] = str(int(countframe.ix[j,i])) + '/' + str(int(countframesum[i]))
            #probframe.ix[j,i] = countframe.ix[j,i]/countframesum[i]

    probframe.columns = range(1,seqlen+1)
    probframe.index.name = 'Position'
    probframe = probframe.reindex(['A','G','C','T'])
    probframe.to_csv(outputfile,sep='\t',header=False ,index=False)
    #probframe.to_csv(outputfile,sep='\t')
    return

if __name__=='__main__':
    main()

