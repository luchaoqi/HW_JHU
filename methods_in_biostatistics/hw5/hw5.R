
#1
library(binom)
par(mfrow=c(3,1))
p=seq(0,1,length=1001)
a=b=2
like=choose(20,17)*p^17*(1-p)^3
prior=gamma(a+b)/(gamma(a)*gamma(b))*p^(a-1)*p^(b-1)
posterior=like*prior
plot(p,posterior)
binom.bayes(17, 20, type = "highest",prior.shape1 = 2,prior.shape2 = 2)
a=b=1
like=choose(20,17)*p^17*(1-p)^3
prior=gamma(a+b)/(gamma(a)*gamma(b))*p^(a-1)*p^(b-1)
posterior=like*prior
plot(p,posterior)
binom.bayes(17, 20, type = "highest",prior.shape1 = 1,prior.shape2 = 1)
a=b=0.5
like=choose(20,17)*p^17*(1-p)^3
prior=gamma(a+b)/(gamma(a)*gamma(b))*p^(a-1)*p^(b-1)
posterior=like*prior
plot(p,posterior)
binom.bayes(17, 20, type = "highest",prior.shape1 = 0.5,prior.shape2 = 0.5)
# The interval lower to  upper was constructed such that in repeated independent experiments,
# 95% of the intervals obtained would contain p.

#2
x=c(44,265,250,153,88,180,35,494,249,204,
    265,27,68,230,180,149,286,72,39,272)
y=c(44,269,256,154,83,185,36,502,249,208,
    277,39,84,228,187,155,290,80,50,271)
t.test(x,y)

#3
x=c(3.22,4.06,3.85,3.5,2.8,3.25,4.2,3.05,2.86,3.5)
y=c(2.95,3.75,4.0,3.42,2.77,3.2,3.9,2.76,2.75,3.32)
dif1=(x-y)
t.test(x,y,alternative = "g")
#fail to reject changing in FEV
a=rep(0,100)
for (i in 1:100) {
  a[i]=sample(x,1)
}
b=rep(0,100)
for (i in 1:100) {
  b[i]=sample(y,size=1)
}
t.test(a,b,alternative = "g")

#4
x=c(2.85,3.32,3.01,2.95,2.78,2.86,2.78,2.9
    ,2.76,3,3.26,2.84,2.5,3.59,3.3)
y=c(2.88,3.4,3.02,2.84,2.75,3.2,2.96,2.74
    ,3.02,3.08,3,3.4,2.59,3.29,3.32)
dif2=(x-y)
t.test(dif1,dif2,var.equal = TRUE)

#5
#z-test statistics: use the true sigma
x=matrix(rnorm(16000,5,1),1000)
y=apply(x,1,mean)
Y=rep(0,1000)
for (i in 1:1000) {
  Y[i]=(y[i]-5)/(1/sqrt(16))
}
pval=pnorm(Y,lower.tail = FALSE)
hist(pval)

#6
u=log(11/sqrt(1+20^2/11^2))
sigma2=log(1+20^2/11^2)

sp=sqrt((15*20^2+15*28^2)/30)
7+c(-1,1)*qt(0.975,30)*sp*sqrt(2/16)

#11
#null diff=0
sp=sqrt((8*1.5^2+8*1.8^2)/16)
-4+c(-1,1)*qt(0.975,16)*sp*sqrt(2/9)

