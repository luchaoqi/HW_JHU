#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

a = c('courage', 'honor', 'daring', 'chivalry')
b = c('fairness', 'loyalty', 'tolerance','hard work')
c = c('wit', 'intelligence', 'learning')
d = c('cunning', 'ambition','ruthlessness')


# Define server logic required to draw a histogram
shinyServer(
  function(input, output) {
    x = reactive(input$text1)
    y = reactive({
    if (x() %in% a)
      {y = 'Gryffindor'}
    else if (x() %in% b)
      {y = 'Hufflepuff'}
    else if (x() %in% c)
      {y ='Ravenclaw'}
    else
      y = 'Slytherin'
    return(y)
    })
    output$text1 = renderText({y()})
  }
)

