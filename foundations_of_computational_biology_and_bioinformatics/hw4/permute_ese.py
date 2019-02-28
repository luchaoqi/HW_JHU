'''
Team: Saki Fujita (sfujita2), Vorada Sakulsaengprapha (vsakuls1), Chuheng Chen (cchen217)
First of two scripts that generates decoy ESE binding site sequences.
'''


import sys
import numpy

def main():
    numpy.random.RandomState(101)
    
    #take in as input ESE.txt
    input_file = sys.argv[2]
    output_file = sys.argv[4]
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

if __name__=="__main__":
    main()

