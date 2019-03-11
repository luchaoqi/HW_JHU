import pandas as pd
import numpy as np
from sklearn.cluster import KMeans

a = open('expression.txt','r')
dat = pd.read_csv(a, delimiter = '\t')





#temp =np.array([[1,2],[3,4],[5,6]])
#print(temp)
#print(dat.columns.values)
