ppv = function(sens,spec,prev){
  a = sens*prev  
  b = sens*prev+(1-spec)*(1-prev)
  return(a/b)
}