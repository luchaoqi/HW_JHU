#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# numericInput(inputId="text1", label = "Your height (meters)", value = 0),
# numericInput(inputId="text2", label = "Your weight (kgs)", value = 0),
# numericInput(inputId="text3", label = "Your height (feet)", value = 0),
# numericInput(inputId="text4", label = "Your weight (lbs)", value = 0),

library(shiny)

BMI = function(height,weight){
  weight = as.numeric(weight)
  height = as.numeric(height)
  return(weight/(height)^2)
  
}

shinyServer(
  
  function(input, output) {
    h = reactive({as.numeric(input$text1) + 0.0254*as.numeric(input$text3)*12})
    w = reactive({as.numeric(input$text2) + 0.45455*as.numeric(input$text4)})
    output$text1 <- eventReactive(input$goButton,{
      BMI(h(),w())
    })
  }
)




???