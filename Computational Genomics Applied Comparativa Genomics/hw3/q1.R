set.seed(100)
s = 1000000
n = 5
a = sample(1:s, n*s,replace=TRUE)
coverage = rep(0,s)
for (i in a ){coverage[i] = coverage[i]+1}
hist(coverage,prob=T,col="light blue")
xfit<-seq(min(coverage),max(coverage))
yfit<-dpois(xfit,n)
lines(xfit,yfit,col="red",lwd=3)

length(which(coverage==0))


set.seed(100)
s = 1000000
n = 15
a = sample(1:s, n*s,replace=TRUE)
coverage = rep(0,s)
for (i in a ){coverage[i] = coverage[i]+1}
hist(coverage,prob=T,col="light blue")
xfit<-seq(min(coverage),max(coverage))
yfit<-dpois(xfit,n)
lines(xfit,yfit,col="red",lwd=3)

length(which(coverage==0))
