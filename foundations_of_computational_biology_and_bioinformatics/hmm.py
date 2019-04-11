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
print('viterbi:')
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





px = s1[-1]*0.05+s2[-1]*0.05

print('px:')
print(px)




print('forward:')
print(s1)
print(s2)
print(s3)
pf1 = s1
pf2 = s2
#backward
seq = 'HHTTT'
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
s1.reverse()
#s1[::-1]
s2.reverse()
print('backward:')
print(s1)
print(s2)
s3 = []
for i in range(len(s1)):
	if s1[i] > s2[i]:
		s3.append('F')
	else:
		s3.append('L')
print(s3)



pb1 = s1
pb2 = s2

s1 = []
s2 = []
for i in range(len(pb1)):
	s1.append(pf1[i]*pb1[i]/px)
	s2.append(pf2[i]*pb2[i]/px)
print('posterio:')
print(s1)
print(s2)

s3 = []
for i in range(len(s1)):
	if s1[i] > s2[i]:
		s3.append('F')
	else:
		s3.append('L')
print(s3)




print('baum welch')
ETf = 0
for i in range(4):
	ETf = pf1[i]*pb1[i] + ETf

EHf = 0
for i in range(4,6):
	EHf = pf1[i]*pb1[i] + EHf

EHl = 0 
for i in range(4,6):
    EHl = pf2[i]*pb2[i] + EHl


ETl = 0 
for i in range(4):
	ETl = pf2[i]*pb2[i] + ETl                                                                   

ET = {'ETfair' : ETf/px,'EHfair' : EHf/px, 'ETloaded' : ETl/px, 'EHloaded' : EHl/px}
print(ET)
et = {'eTf':ETf/(ETf+EHf), 'eTl': ETl/(ETl+EHl),'eHf': EHf/(EHf+ETf),'eHl': EHl/(EHl+ETl)}
print(et)



#eTf = ETf/(ETf+EHf)
#eHl = EHl/(EHl+ETl)
#print('eTf')
#print(eTf)
#print('eHl')
#print(eHl)
