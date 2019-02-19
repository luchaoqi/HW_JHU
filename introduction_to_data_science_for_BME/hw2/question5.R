#Methods in Biostatistics is pretty helpful
a = apply(matrix(sample(1:6,6000,replace = TRUE),1000),1,mean)
hist(a, xlab="Sample Average", main = "Average of 6 die rolls")
mean(a)
var(a)
