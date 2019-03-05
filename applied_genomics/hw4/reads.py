import pysam
chr22 = pysam.FastaFile("chr22.fa")
seq = chr22.fetch("chr22",21000000,22000000)

sub = open("sub.fa","w")
sub.write(">chr22:21000000,22000000 \n")
sub.write(seq + '\n')
sub.close()

reads = open("reads.fa","w")
for i in range(len(seq)-35+1):
	number  = ">"+str(i+1)
	subseq	= seq[i:i+35]
	reads.write(number + "\n")
	reads.write(subseq + "\n")
reads.close() 
