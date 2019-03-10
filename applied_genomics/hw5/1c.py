import numpy as np
import pandas as pd

f = open('exon.txt','r')


a = []
for lines in f:
	line = lines.strip().rstrip('\n').split("\"")
	a.append(line[1])
dat = pd.Series(a)
b = dat.value_counts().tolist()
print('Max: {0}'.format(np.max(b)))
print('Min: {0}'.format(np.min(b)))
print('Mean: {0}'.format(np.mean(b)))
print('Std: {0}'.format(np.std(b)))
