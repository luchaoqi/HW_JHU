s1 = [0.25]                                                                                     
s2 = [0.45]

seq = 'TTTHH'

dic1 = {'T':0.5,'H':0.5}
dic2 = {'T':0.9,'H':0.1}

#viterbi
for i in range(len(seq)):
	s12s1 = s1[i]*0.85
	s22s1 = s2[i]*0.1
	s12s2 = s1[i]*0.1
	s22s2 = s2[i]*0.85
	s1.append(max(s12s1,s22s1)*dic1[seq[i]])
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

#forward
seq = 'TTTHH'
s1 = [0.25]
s2 = [0.45]
for i in range(len(seq)):
	s12s1 = s1[i]*0.85*dic1[seq[i]]
	s22s1 = s2[i]*0.1*dic1[seq[i]]
	s12s2 = s1[i]*0.1*dic2[seq[i]]
	s22s2 = s2[i]*0.85*dic2[seq[i]]
	sum1 = s12s1 + s22s1
	sum2 = s12s2 + s22s2
	s1.append(sum1)
	s2.append(sum2)


s3 = []
for i in range(len(s1)):
    if s1[i] >s2[i]:
        s3.append('F')
    else:
        s3.append('L')
print(s1)
print(s2)
print(s3)
#backward
seq = 'HTTTT'
s1 = [0.05]
s2 = [0.05]
s3 = []

for i in range(len(seq)):
	s12s1 = s1[i]*0.85*dic1[seq[i]]
	s22s1 = s2[i]*0.1*dic2[seq[i]]
	sum1 = s12s1 + s22s1
	s12s2 = s1[i]*0.1*dic1[seq[i]]
	s22s2 = s2[i]*0.85*dic2[seq[i]]
	sum2 = s12s2 + s22s2
	s1.append(sum1)
	s2.append(sum2)
	
print(s1)
print(s2)
