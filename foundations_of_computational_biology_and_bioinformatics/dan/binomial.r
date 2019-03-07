set.seed(101)

randomNumber = rbinom(n = 500, size = 1000, prob = 0.5)

P = ecdf(randomNumber) 
pval = 1 - pbinom((randomNumber - 1), size = 1000, prob = 0.5)
hist(pval)
