"""
Homework 1 part 1
Team: Saki Fujita(sfujita2), Chuheng Chen(cchen217), Vorada Sakulsaengprapha(vsakuls1)
Usage:  python3 mutation_caller.py -n normal.bam -c cancer.bam
Describtion: function get_args will get the fuction input files as required
fuction likelihood will calculate the likelihood of input sequence pileup has the genotype provided in genotypes(the input has to be a list.)
fuction main will:
1.read in files provided by input and output arguments
2.Check coverage at each position of the bam file
3.gets genotype for sequence normal bam
4.use the genotype identified to predict possible somatic mutations
"""
import pysam
import argparse
import sys
import numpy as np
import math
#read in input and output arguments
def get_args():
	parser = argparse.ArgumentParser()
	parser.add_argument("-n",type=str)
	parser.add_argument("-c",type=str)
	args = parser.parse_args()
	
	return args

#function that returns a list of likelihoods for the 10 genotypes
def getLikelihood(pileup,genotypes):
	likelihoods = []
	e = 0.1
	for genotype in genotypes:
		alleles = [genotype[0],genotype[1]]
		likelihood = 0
		for i in "ATGC":
			base_count = pileup.count(i)
			if i == alleles[0]:
				prob_1 = 1-e
			else:
				prob_1 = e/3
			if i == alleles[1]:
				prob_2 = 1-e
			else:
				prob_2 = e/3
			base_prob = 0.5*prob_1 + 0.5*prob_2
			likelihood += base_count*math.log(base_prob)
		likelihoods.append(likelihood)
	return likelihoods

def main():
	args = get_args()
	cancerbam = pysam.AlignmentFile(args.c, "rb")
	normalbam = pysam.AlignmentFile(args.n, "rb")
	ref = cancerbam.get_reference_name(0)
	normalList = list()
	cancerList = list()
	# Check coverage at each position 
	for normCol in normalbam.pileup():
		if normCol.n < 20:
			sys.stdout.write("Insufficient coverage at normal position %s \n"%(normCol.pos))
		else:
			normalList.append(normCol.pos)
	for cancerCol in cancerbam.pileup():
		if cancerCol.n < 20:
			sys.stdout.write("Insufficient coverage at cancer position %s \n"%(cancerCol.pos))
		else:
			cancerList.append(cancerCol.pos)
	nl = np.array(normalList)
	cl = np.array(cancerList)
	mask = np.in1d(nl,cl)
	coList = nl[mask]
	ten_genotypes = ["AA","CC","GG","TT","AC","AG","AT","CG","CT","GT"]
	true_type = []
	normList = []
	nsq = []
	for normCol in normalbam.pileup():
		if np.in1d(normCol.pos,coList): # position is not in the coList->continue the loop
			normSequence = ""
			for normRead in normCol.pileups:
				if not normRead.is_del and not normRead.is_refskip:
					normSequence += normRead.alignment.query_sequence[normRead.query_position]
			# gets likehoods for normal bam
			likelihoods = getLikelihood(normSequence,ten_genotypes)
			#print(len(likelihoods))
			# identify max likelihood
			max_pos = likelihoods.index(max(likelihoods))
			G = ten_genotypes[max_pos]
			likelihood = likelihoods[max_pos]
			nsq.append(normSequence)
			#print("normal at position %s has likelihood = %s"%(normCol.pos,likelihood))
			# if prob with that pos < -50 skip
			if likelihood <-50:
				print("Position {} has ambiguous genotype".format(normCol.pos))
			else:
				# using that pos, analyze cancer bam
				true_type.append(G)
				normList.append(normCol.pos)
	
	idex = 0
	for cancerCol in cancerbam.pileup():
		if np.in1d(cancerCol.pos,normList) and cancerCol.pos == normList[idex]:
			cancerSequence = ""
			for cancerRead in cancerCol.pileups:
				if not cancerRead.is_del and not cancerRead.is_refskip:
					cancerSequence += cancerRead.alignment.query_sequence[cancerRead.query_position]
			likelihoods = getLikelihood(cancerSequence,[true_type[idex]])
			likelihood = likelihoods[0]
			#print("cancer likelihood is {}".format(likelihood))
			idex += 1
			# if prob < -75 print to stdout
			if likelihood <-75:
				print("Position {} has a candidate cancer somatic mutation with log likelihood of %s".format(cancerCol.pos)%(likelihood))

if __name__=="__main__":
    main()
