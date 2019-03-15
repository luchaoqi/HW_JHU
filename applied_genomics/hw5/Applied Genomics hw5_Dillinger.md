## Q 1a
Shell:
```
awk '$3 == "gene"&& /protein_coding/' Homo_sapiens.GRCh38.87.gtf > 1a.txt
python3 1a.py | sort -nk1
```
Python:
```
  1 import pandas as pd
  2 f = open('1a.txt','r')
  3 a = []
  4 for lines in f:
  5         line = lines.strip().rstrip('\n').split('\t')
  6         a.append(line[0])
  7 dat = pd.Series(a)
  8 print(dat.value_counts())
```
Result:
```
Genes        Numbers
1             2052
2             1255
3             1076
4              751
5              876
6             1045
7              906
8              676
9              781
10             732
11            1276
12            1034
13             327
14             623
15             597
16             866
17            1197
18             270
19            1470
20             544
21             233
22             438
```

## Q 1b  
Shell:
```
awk '$3 == "gene" && /protein_coding/' Homo_sapiens.GRCh38.87.gtf > protein_coding.txt
```
Python:
```
  1 import numpy as np
  2 f = open('protein_coding.txt','r')
  3 a  = []
  4 for lines in f:
  5         line  = lines.strip().rstrip('\n').split('\t')
  6         a.append(int(line[4])-int(line[3])+1)
  7 print('Max: {0}'.format(np.max(a)))
  8 print('Min: {0}'.format(np.min(a)))
  9 print('Mean: {0}'.format(np.mean(a)))
 10 print('Std: {0}'.format(np.std(a)))
```
Results:
```
Max: 2304997
Min: 78
Mean: 67025.36280747458
Std: 130396.57914493038
```

## Q 1c
Shell:
```
awk '$3 == "exon" && /transcript_name/' Homo_sapiens.GRCh38.87.gtf | tr ';' '\t'| cut -f 11 > exon.txt
```
Python:
```
  1 #awk '$3 == "transcript" && /protein_coding/' Homo_sapiens.GRCh38.87.gtf | t    r ';' '\t'| cut -f 9 > exon.txt
  2 import numpy as np
  3 import pandas as pd
  4 
  5 f = open('exon.txt','r')
  6 
  7 
  8 a = []
  9 for lines in f:
 10         line = lines.strip().rstrip('\n').split("\"")
 11         a.append(line[1])
 12 dat = pd.Series(a)
 13 #print(dat.value_counts())
 14 b = dat.value_counts().tolist()
 15 print('Max: {0}'.format(np.max(b)))
 16 print('Min: {0}'.format(np.min(b)))
 17 print('Mean: {0}'.format(np.mean(b)))
 18 print('Std: {0}'.format(np.std(b)))
```
Result:
```
Max: 363
Min: 1
Mean: 5.9704598943445015
Std: 6.78526409135388
```
## Q 2a




