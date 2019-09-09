cltTester = function(rolls,samples = 1000){
  a = sample(1:6,rolls*samples,replace =TRUE) #create the vector
  b = matrix(a,samples) #create the matrix
  c = apply(b,1,mean) #get the avg of each row
  return(c)
}
# cltTester(1)
# cltTester(3)
# cltTester(6)
# is.vector(a)
# dim(b)

