library(tm)
library(stringr)
library(stylo)

## Load the data
uni <- readRDS('./data/uni.rds')
bi <- readRDS('./data/bi.rds')
tri <- readRDS('./data/tri.rds')
quad<- readRDS('./data/quad.rds')


clean.text <- function(x, lowercase=TRUE, numbers=TRUE, punctuation=TRUE, spaces=TRUE)
{
  # x: character string
  
  # lower case
  if (lowercase)
    x = tolower(x)
  # remove numbers
  if (numbers)
    x = gsub("[[:digit:]]", "", x)
  # remove punctuation symbols
  if (punctuation)
    x = gsub("[[:punct:]]", "", x)
  # remove extra white spaces
  if (spaces) {
    x = gsub("[ \t]{2,}", " ", x)
    x = gsub("^\\s+|\\s+$", "", x)
  }
  # return
  cleanText <- txt.to.words.ext(cleanText, language="English.all",  preserve.case = TRUE)
  cleanText
}


some_text = "I am!!!"

cleanText <- clean.text(some_text)

cleanText <- txt.to.words.ext(cleanText, language="English.all",  preserve.case = TRUE) #I am using stylo package for this





nextWordPrediction <- function(wordCount, text){
  
  ## If number of words is equal or more than 3, then just take the last 3 words.
  if (wordCount >= 3) {
    text <- text[(wordCount-2):wordCount]
    
    # Predict using quadgrams
    wordPrediction <- as.character(quad[quad$uni==text[1] & quad$bi==text[2] & quad$tri==text[3],][1,]$quad)
    wordPrediction2 <- as.character(quad[quad$uni==text[1] & quad$bi==text[2] & quad$tri==text[3],][2,]$quad[2])
    wordPrediction3 <- as.character(quad[quad$uni==text[1] & quad$bi==text[2] & quad$tri==text[3],][3,]$quad[3])
    # If no prediction, then back-off to predict using trigrams.
    if (is.na(wordPrediction)) {
      return (nextWordPrediction(2,text[2:3]))
    } 
  }
  
  # Predict using trigrams
  if (wordCount == 2) {
    wordPrediction <- as.character(tri[tri$uni==text[1] &  tri$bi==text[2],][1,]$tri)
    wordPrediction2 <- as.character(tri[tri$uni==text[1] &  tri$bi==text[2],][2,]$tri)
    wordPrediction3 <- as.character(tri[tri$uni==text[1] &  tri$bi==text[2],][3,]$tri)
    # If no prediction, then back-off to predict using bigrams
    if (is.na(wordPrediction)) {
      return (nextWordPrediction(1,text[3:3]))
    }
  }
  
  # Predict using bigrams
  if (wordCount == 1) {
    wordPrediction <- as.character(bi[bi$uni==text[1],][1,]$bi)
    wordPrediction2 <- as.character(bi[bi$uni==text[1],][2,]$bi)
    wordPrediction3 <- as.character(bi[bi$uni==text[1],][3,]$bi)
  }
  
  if (wordCount == 0) {
    wordPrediction <- NA
  }
  
  print(wordPrediction)
  print(wordPrediction2)
  print(wordPrediction3)
}


