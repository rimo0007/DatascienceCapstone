library(shinyapps)
library(shiny)

source("./wordPrediction.R")
shinyServer(function(input, output) {
  
  
  
  nextWord <- reactive({
    inputText <- clean.text(input$Text)
    numWords <- length(inputText)
    
    # Attach tokenized and "cleaned" text as well as number of words
    # to the respective elements in Shiny UI.
    output$InputText <- renderPrint(inputText)
    output$NumWords <- renderText(numWords)
    # Predict the next word using the function in word_predictor.R
    nextWord <- nextWordPrediction(numWords, inputText)
    
    if(is.na(nextWord[1]) || is.na(nextWord[2]) || is.na(nextWord[3])){
      
      #prev <- reactive({
        #inputText <- clean.text(input$Text)
       # numWords <- length(inputText)
        
        # Attach tokenized and "cleaned" text as well as number of words
        # to the respective elements in Shiny UI.
      #  output$InputText <- renderPrint(inputText)
       # output$NumWords <- renderText(numWords)
        # Predict the next word using the function in word_predictor.R
        prev <- nextWordPrediction(numWords-1, inputText[1:numWords-1])
        return (prev)
      #})
    }else{
      return (nextWord)
    }
    
  })
  # Attach the predicted word to the NextWord element in Shiny UI.
 
    #output$NextWord <- renderText(prev()[1])
    #output$NextWord2 <- renderText(prev()[2])
    #output$NextWord3 <- renderText(prev()[3])
  
    output$NextWord <- renderText(nextWord()[1])
    output$NextWord2 <- renderText(nextWord()[2])
    output$NextWord3 <- renderText(nextWord()[3])
  
})

#https://kalyannandi.shinyapps.io/capstone/
#shinyapps::deployApp('F:/R_Coding/DataScienceCapstoneUI/capstone',account='kalyannadi')
