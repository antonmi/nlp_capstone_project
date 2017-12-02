library(dplyr)
library(stringr)
library(purrr)
library(hash)


put_phrase <- function(top_hash, phrase, count) {
  words <-  strsplit(phrase, ' ')[[1]]
  hash = top_hash
  
  for (word in words) {
    hash <- if (is.null(hash[[word]])) {
      hash[[word]] <- c(hash(), as.integer(count))
      hash
    } else {
      hash[[word]][[1]]
    }
  }
  top_hash
}
  
find <- function(top_hash, phrase) {
  words <-  strsplit(phrase, ' ')[[1]]
  result <- c(top_hash, 0)
  for (word in words) {
    hash <- result[[1]]
    result <- if (is.null(hash[[word]])) {
      c(hash(), 0)
    } else {
      hash[[word]]
    }
  }  
  result
}

hash <- hash()

print(Sys.time())
for(i in c(1:10)) {
  print(paste("Import", i))
  file <- paste('data/ngrams/total', i, '.txt', sep = '')
  set <- read.csv(file)
  
  for (i in c(1:dim(set)[[1]])) {
    hash <- put_phrase(hash, as.character(set[[i, 1]]), set[[i, 2]])
  }
}

print(Sys.time())
