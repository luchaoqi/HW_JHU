import pandas as pd
import numpy as np
from sklearn.cluster import KMeans

a = open('expression.txt','r')
dat = pd.read_csv(a, delimiter = '\t')
kmeans = KMeans(n_clusters=2)
kmeans.fit(dat.drop(dat.columns[0],axis=1))



#temp =np.array([[1,2],[3,4],[5,6]])
#print(temp)
#print(dat.columns.values)
