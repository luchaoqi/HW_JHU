import pandas as pd
f = open('1a.txt','r')
a = []
for lines in f:
	line = lines.strip().rstrip('\n').split('\t')
	a.append(line[0])
dat = pd.Series(a)
print(dat.value_counts())
