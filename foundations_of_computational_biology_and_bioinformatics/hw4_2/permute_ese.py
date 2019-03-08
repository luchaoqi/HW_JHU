'''
JHED ID: lqi9
Pratical number: p04
Script that generates decoy ESE binding site sequences.
Usage: python3 permute_ese.py -f ese_test.txt -o permuted_ese.txt (-t ese_test.txt/ trusted_ESE.txt)
'''

import argparse
import sys
import numpy

#error checking
if not sys.argv[1].startswith('-') or not sys.argv[2].endswith('.txt') or not sys.argv[3].startswith('-') or not sys.argv[4].endswith('.txt'):
	sys.stdout.write('Usage: python3 permute_ese.py -f ese_test.txt -o permuted_ese.txt (-t ese_test.txt/ trusted_ESE.txt) if needed \n')
	sys.exit()

parser = argparse.ArgumentParser()
parser.add_argument("-f",required = True,type=str)
parser.add_argument("-o",required = True,type=str)
parser.add_argument("-t",default = 'ese_test.txt',type=str)
args = parser.parse_args()

def main():
	
	numpy.random.seed(101)
    
#take in as input ESE.txt
	input_file = args.f
	output_file = args.o
	f_in = open(input_file,'r')
	f_out = open(output_file,'w')

#read in reach sequence and permute the nucleotides
	for line in f_in:
		dna = line.strip('\n')
        
        #separate nucleotides by comma 
		nuc_list = []
		for i in dna:
        		nuc_list.append(i)

        #convert python list to numpy array
		nuc_list_numpy = numpy.array(nuc_list)
		numpy.random.shuffle(nuc_list_numpy)

        #join strings into one sequence         
		permuted_nuc = ''.join(nuc_list_numpy)
        #write the permuted sequence to the output file named permuted_ese.txt
		f_out.write('{}\n'.format(permuted_nuc))
	f_in.close()
	f_out.close()

#skip the repeated seq that appear in trusted ESE
	f1 = open(args.t,'r')
	f2 = open(args.o,'r+')
	a = []
	b = []
	for line in f1:
		a.append(line.strip('\n'))
	for line in f2:
		b.append(line.strip('\n'))
	f2.seek(0)
	f2.truncate()

	for i in b:
		if i not in a:
			f2.write( i+ '\n')
	f1.close()
	f2.close()
	return()
if __name__=='__main__':
        main()




