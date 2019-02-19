#Practical 4 - Exercise 1 - binomial.R
#sfujita2, cchen217, vsakuls1

#Code samples 1000 values from a binomial distribution,
#computes p-values and plots a histogram of the p-values.
#It shows that p-values under the null are uniformly distributed.
#The code should output an image file of the histogram.

set.seed(101) #pseudo random number generator seed to 101
numbers  = rbinom(1000,500,0.5) #N = 1000, n = 500, p = 0.5

pvalues = (1-pbinom(numbers, 500, 0.5)) #calculate p-values

png(file='PvalueHistogram.png')
hist(pvalues) #add freq = false to get density for y-axis

dev.off()