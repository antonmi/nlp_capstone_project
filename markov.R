library(dplyr)
library(stringr)

twitter_sets <- list()
for(i in c(1:10)) {
  file <- paste('data/ngrams/twitter_ngrams', i, '.txt', sep = '')
  data <- read.csv(file)
  twitter_sets[[i]] <- as.character(data[,1])
}

get_first_words <- function(string) {
  words = strsplit(as.character(string), " ")[[1]]
  first = head(words, n=-1)
  paste(first, collapse = ' ')
}

find_phrases <- function(generated, intersection_set, phrases_set) {
  size <- length(phrases_set)
  for (i in c(1:size)) {
    phrase <- as.character(phrases_set[i])
    first <- get_first_words(phrase)
    if (is.element(first, intersection_set)) {
      intersection_set <- setdiff(intersection_set, first)
      position <- which(generated == first)
      generated[position] <- phrase
    }
  
    if (i %% 1000 == 0) {
      print(paste("i = ", i))
      print(paste("set size = ", length(intersection_set)))
    }
  }
  
  return(generated)
}


first_words <- sapply(twitter_sets[[2]], get_first_words)
intersection_set <- intersect(twitter_sets[[1]], first_words)
generated <- intersection_set
generated <- find_phrases(generated, intersection_set, twitter_sets[[2]])   

con <- file('data/generated.txt', 'w')
for (sentence in generated) { write(sentence, con, append = TRUE) }
close(con)

for (i in c(3:10)) {
  print(paste("For i =", i))
  first_words <- sapply(twitter_sets[[i]], get_first_words)
  intersection_set <- intersect(generated, first_words)
  generated <- find_phrases(generated, intersection_set, twitter_sets[[i]])  
}


con <- file('data/generated_news.txt', 'w')
for (sentence in generated) { write(sentence, con, append = TRUE) }
close(con)
