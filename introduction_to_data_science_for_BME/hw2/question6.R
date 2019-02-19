birthday = function(n){
  #PAbar = (1/365^n)*(prod((365-(n-1)):365))
  PAbar = (prod(1:n)*choose(365,n)/(365^n))
  PA = 1 - PAbar
  return(PA)
}

n = 2:50    #set the number of people
i = 0
a = matrix()
for (x in n){
  i = i+1
  a[i] = birthday(x)
}
plot(n,a,xlab='Number of people',ylab = 'Probability')
