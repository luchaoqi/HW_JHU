library(mvnmle)
x = matrix(c(10.9,7.6,11.7,11.8,12.5,8.7,10.8,10.3,10.9,9.3))
y = matrix(c(15.6,15.1,19.4,17.1,17.2,15.5,17.6,17.6,14.4,14.6))
dat = as.data.frame(cbind(x,y))
mlest(dat)



