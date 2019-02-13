mylag = function(x,y){
  Y = paste("L",y, sep = "")
  a = matrix(nrow = length(x))
  colnames(a) = 'L0'
  a[] = x                   #origiinal column
  for (i in y){
    b = matrix(nrow = length(x))
    colnames(b)  = Y[i]
    b[] = c(rep(NA,i),x)[1:length(x)]
    a = cbind(a,b)
  }                         #use for loop to get the new matrix
  return(a)
}

mylag(c(1,2,3,4),c(1,2,3,4))
