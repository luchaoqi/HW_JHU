import numpy as np
f = open('protein_coding.txt','r')
a  = []
for lines in f:
	line  = lines.strip().rstrip('\n').split('\t')
	a.append(int(line[4])-int(line[3])+1)	
print('Max: {0}'.format(np.max(a)))
print('Min: {0}'.format(np.min(a)))
print('Mean: {0}'.format(np.mean(a)))
print('Std: {0}'.format(np.std(a)))

