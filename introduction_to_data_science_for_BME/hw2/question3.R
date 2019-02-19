#run Hogwart() in the console
Hogwarts = function(){
  
  continue = TRUE
  
  while (continue) {
    
    response = readline(prompt = "Enter response (q to quit) >")
    
    if (response == 'brave'){
      print('Gryffindor')
    }
    else if (response == 'plants'){
      print('Hufflepuff')
    }
    else if (response == 'bookcases'){
      print('Ravenclaw')
    }
    else{
      print('Slytherin')
    }
    continue = (response != "q")
    
  }
}


