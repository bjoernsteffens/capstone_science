require(shiny)
require(dplyr)
require(stringr)

# Define UI for application that draws a histogram
ui <- shinyUI(pageWithSidebar(
  
  headerPanel('Word Prediction with RStudio & ShinyApp'),
  
  sidebarPanel(
    p('This is a word predictor that takes your input and predicts the next word you may have been thinking about typing'),
    h4(' '),
    textInput('txt_input','Key in your text here', value = "What is")
  ),
  
  mainPanel(
      tabsetPanel(
          tabPanel("Word Predictor",
            p(' '),
            p('This is the text you provided'),
            h3(textOutput('txt_output')),
            p(' '),
            p('The next word is likely this one'),
            h3(textOutput('txt_predict')),
            p(' '),
            p(' '),
            p('Other alternatives could be'),
            h3(textOutput('txt_other'))
        ),
        tabPanel("Application Description",
            p(' '),
            p('The solution I have implemented is based on Natural Language Processing (NLP) research 
              leveraging various R-libraries working on large quantities of text or Corpuses. Such activities 
              are also referred to as text mining.'),
            p(' '),
            p('The implementation is absolute minimalsitic and does not explore and further features of Shiny. The main function for text processing creating the ngrams can be found here'),
            p(' '),
            p('The main function for text processing creating the ngrams can be found here'),
            a('Quanteda Example code creating the ngrams', href="https://github.com/bjoernsteffens/capstone_science/blob/master/01%20Build%20nGram%20Models/create_nGrams_II.R"),
            p(' '),
            p('Here is an example of how the ngrams can be scanned when text is entered'),
            a('Word prediction example using the pre-processed ngram model', href="https://github.com/bjoernsteffens/capstone_science/blob/master/02%20Prediction%20Prototype/predict_Words.R"),  
            p(' '),
            p('The code for this ShinyApp is here'),
            a('app.R', href="https://github.com/bjoernsteffens/capstone_science/blob/master/04%20ShinyApp/app.R"),
            p(' '),
            a('predict.R', href="https://github.com/bjoernsteffens/capstone_science/blob/master/04%20ShinyApp/predict.R")
        )
      )
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

