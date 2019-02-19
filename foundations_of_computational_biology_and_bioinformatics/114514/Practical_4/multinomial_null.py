'''
Team: Saki Fujita (sfujita2), Vorada Sakulsaengprapha (vsakuls1), Chuheng Chen (cchen217)
First of two scripts that generates decoy ESE binding site sequences.
python3 multinomial_null.py -o multinomial_null_ese.txt
'''

import sys
import numpy


def main():
	output_file = sys.argv[2]
	f_out = open(output_file,'w')
	# multinomial
	count = 0;
	nuc_table={0:'A',1:'C',2:'G',3:'U'}

	while count <= 238:
		count = count+1
		a = numpy.random.multinomial(6,[1/4.]*4,(1,6))
		n = a.tolist()[0]
		nuc_list = '';
		for i in range(0,6):
			multinom = n[i].index(max(n[i]))
			nuc_list = nuc_list+nuc_table[multinom]
		nuc_list = nuc_list+'\n'
		f_out.write(nuc_list)
	f_out.close()
	
if __name__=="__main__":
    main()
