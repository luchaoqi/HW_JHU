s1 = [0.25]                                                                                     
s2 = [0.45]

seq = 'TTTHH'

dic1 = {'T':0.5,'H':0.5}
dic2 = {'T':0.9,'H':0.1}

#fcbb viterbi
for i in range(len(seq)):
	s12s1 = float(s1[i])*0.85
	s22s1 = float(s2[i])*0.1
	s1.append(max(s12s1,s22s1)*dic1[seq[i]])
	s12s2 = float(s1[i])*0.1
	s22s2 = float(s2[i])*0.85
	s2.append(max(s12s2,s22s2)*dic2[seq[i]])
s3 = []
for i in range(len(s1)):
	if s1[i] >s2[i]:
		s3.append('F')
	else:
		s3.append('L')
print(s1)
print(s2)
print(s3)
