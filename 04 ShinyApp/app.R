library(shiny)
library(dplyr)

# Define UI for application that draws a histogram
ui <- shinyUI(pageWithSidebar(
  headerPanel('Word Prediction'),
  sidebarPanel(
    p('This is a word predictor that takes your input and predicts the next word you want to type'),
    p(' '),
    p('Press spacebar when you are done typing'),
    p(' '),
    textInput('txt_input','Enter your text here and I will predict a word for you', value = "My name")
  ),
  mainPanel(
    #h3('This is the text you provided'),
    #textOutput('txt_output'),
    #p(' '),
    p('The next word is likely this one'),
    h3(textOutput('txt_predict')),
    p(' '),
    p(' '),
    p('Other alternatives could be'),
    h4(textOutput('txt_other'))
  )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
  
  source("./predict.R")
  # Grab what is coming from the panel input
  output$txt_output <- renderText({input$txt_input})
  output$txt_predict <- renderText({predict.word(input$txt_input)[1]})
  output$txt_other <- renderText({predict.word(input$txt_input)[2:5]})

  })

# Run the application 
shinyApp(ui = ui, server = server)

