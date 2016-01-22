library(tm)
library(tm)
library(RWeka)
library(dplyr)
library(magrittr)
library(data.table)
library(NLP)

#Here I have used readLins() function to read the text. Similarly, you can use scan() function also
blogs <- readLines("final/en_US/en_US.blogs.txt", encoding="UTF-8")
twitter <- readLines("final/en_US/en_US.twitter.txt", encoding="UTF-8")
# import the news dataset in binary mode to overcome the problem of "incomplete final line found"
con <- file("final/en_US/en_US.news.txt", open="rb")
news <- readLines(con, encoding="UTF-8")
close(con)
rm(con)

combinedText <- c(blogs, news, twitter)
sampleText <- sample(combinedText, 30000)


library(qdapRegex)
# remove twitter retweets 
sampleText <- gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", sampleText)

# remove @people
sampleText <- gsub("@\\w+", "", sampleText)

# remove http links
sampleText <- gsub("http\\w+", "", sampleText)

# remove emoticons, hash tags and urls (qdapRegex Package)
sampleText <- rm_emoticon(sampleText)
sampleText <- rm_hash(sampleText)
sampleText <- rm_url(sampleText)


# Clear the memory
rm(blogs, news, twitter, combinedText)

### Save sample
writeLines(sampleText, "sampleText.txt")



library(NLP)
library(tm)
# Convert sampleText into corpus format required by tm package
corpus <- Corpus(VectorSource(sampleText))
rm(sampleText)  # Clear memory

# Remove numbers
corpus <-tm_map(corpus, removeNumbers)
# Remove punctuation
corpus <-tm_map(corpus, removePunctuation)
# Remove unnecessary white space
corpus <-tm_map(corpus, stripWhitespace)
# Change to all lower-case
corpus <- tm_map(corpus, content_transformer(tolower))

# Remove Profanity using Google's 'badwords' (https://badwordslist.googlecode.com/files/badwords.txt)
badwords <- readLines("badwords.txt", encoding="UTF-8", warn=FALSE, skipNul=TRUE)
corpus <- tm_map(corpus, removeWords, badwords)
rm(badwords)  # Clear memory

# Remove stop words in English such as "the", "a", etc.
# Note: I decided NOT to remove stop words as they may be useful in predicting next word
# corpus <- tm_map(corpus, removeWords, stopwords("english"))

# Stem the document
# Note: I decided NOT to stem the words as they may be useful in predicting next word
# corpus <- tm_map(corpus, stemDocument)

# Save the corpus
saveRDS(corpus, file = "corpus.rds")



# Read the corpus and convert to data frame for use.
corpus <- readRDS("corpus.rds")
corpus_df <-data.frame(text=unlist(sapply(corpus,`[`, "content")), stringsAsFactors = FALSE)

library(RWeka)

# Function for nGram
ngramTokenizer <- function(theCorpus, ngramCount) {
  ngramFunction <- NGramTokenizer(theCorpus, 
                                  Weka_control(min = ngramCount, max = ngramCount, 
                                               delimiters = " \\r\\n\\t.,;:\"()?!"))
  ngramFunction <- data.frame(table(ngramFunction))
  ngramFunction <- ngramFunction[order(ngramFunction$Freq, 
                                       decreasing = TRUE),]
  colnames(ngramFunction) <- c("String","Count")
  ngramFunction
}

# Generate unigrams and save
unigrams <- ngramTokenizer(corpus_df, 1)
saveRDS(unigrams, file = "uni.rds")

# Generate bigrams and save
bigrams <- ngramTokenizer(corpus_df, 2)
saveRDS(bigrams, file = "bigrams.rds")

# Generate trigrams and save
trigrams <- ngramTokenizer(corpus_df, 3)
saveRDS(trigrams, file = "trigrams.rds")


quadgrams <- ngramTokenizer(corpus_df, 4)
saveRDS(quadgrams, file = "quadgrams.rds")


library(dplyr)
library(tidyr)

names(unigrams)<-names(unigrams)<- c("uni","count")

  
bi <- separate(data = bigrams, col = String, into = c("uni", "bi"))
tri <- separate(data = trigrams, col = String, into = c("uni", "bi","tri"))
quad <- separate(data = quadgrams, col = String, into = c("uni", "bi","tri","quad"))

saveRDS(uni, file = "uni.rds")
saveRDS(bi, file = "bi.rds")
saveRDS(tri, file = "tri.rds")

saveRDS(quad, file = "quad.rds")


