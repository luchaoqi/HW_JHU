s1 = [1]
s2 = [0]
seq = 'CAACATTGTCGCCATTGCTCAGGGATCTTCTGAACGCTC'
dic1 = {'A':0.15,'C':0.35,'G':0.35,'T':0.15}
dic2 = {'A':0.3,'C':0.2,'G':0.15,'T':0.35}
for i in range(len(seq)):
	s1.append(float(s1[i])*0.5*dic1[seq[i]] + float(s2[i])*0.25*dic2[seq[i]])
	s2.append(float(s1[i])*0.5*dic1[seq[i]] + float(s2[i])*0.75*dic2[seq[i]])
print(s1)
print(s2)

