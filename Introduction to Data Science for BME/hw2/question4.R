corner = function(a,b){
  X = dim(a)[1]
  Y = dim(a)[2]
  x = b[1]
  y = b[2]
  if (x <= X && y <= Y){
    newmatrix = a[1:x,1:y]
    return(newmatrix)
  }
  else {
    print('Error: out of range')
  }
}

# A = matrix(1:20,4,5,byrow = TRUE)
# print(corner(A,c(3,4)))
# print(corner(A,c(10,11)))
