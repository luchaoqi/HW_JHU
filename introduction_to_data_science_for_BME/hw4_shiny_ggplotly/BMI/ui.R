#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("BMI calculator: please set values that you don't need to 0(default)"),
  sidebarPanel(
    numericInput(inputId="text1", label = "Your height (meters)", value = 0),
    numericInput(inputId="text2", label = "Your weight (kgs)", value = 0),
    numericInput(inputId="text3", label = "Your height (feet)", value = 0),
    numericInput(inputId="text4", label = "Your weight (lbs)", value = 0),
    actionButton("goButton", "Compute")
  ),
  mainPanel(
    p('Your BMI'),
    textOutput('text1')
  )
))