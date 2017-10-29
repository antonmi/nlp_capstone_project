library(stringr)
library(parallel)
library(dplyr)

words <- function(str) { unlist(strsplit(str, ' ')) }

ngrams <- function(str, n) {
  ws <- words(str)
  word_count <- length(ws)
  if (word_count < n) { return(NULL) }
  if (word_count == n) { return(str) }
  
  result <- NULL
  for (i in c(1:(word_count-n+1))) {
    result <- c(result, paste(ws[i:(i+n-1)], collapse = ' '))
  }
  result
}

filter_sentences <- function(raw_lines, sentences_path) {
  con <- file(sentences_path, 'w')
  for (line in raw_lines) {
    ss <- str_match_all(line, "[\\w\\s']+")
    ss <- unlist(ss)
    ss <- lapply(ss, trimws)
    ss <- lapply(ss, tolower)
    ss <- ss[lapply(ss, nchar) > 0]
    write(unlist(ss), con, append = TRUE)
  }
  close(con)
}

build_ngrams <- function(name, file_path) {
  con <- file(file_path)
  raw_lines <- readLines(con)
  close(con)
  
  sentences_path <- paste('data/', name, '_sentences.txt', sep = '')
  print("Filtering sentences")
  filter_sentences(raw_lines, sentences_path)
  
  con <- file(sentences_path)
  sentences <- readLines(con)
  close(con)
  
  create_ngrams <- function(n) {
    ngrams_path = paste('data/ngrams/', name, '_ngrams', n, '.txt', sep = '')
    
    con <- file(ngrams_path, 'w')
    for (sentence in sentences) {
      ng <- ngrams(sentence, n)
      if (!is.null(ng)) {
        write(ng, con, append = TRUE)
      }
    }
    close(con)
    do_stats(ngrams_path)
  }
  
  do_stats <- function(ngrams_path) {
    con <- file(ngrams_path)
    ngrams <- readLines(con)
    close(con)
    
    stats <- table(ngrams)
    stats <- stats[order(-unlist(stats))]
    data_frame <- data.frame(unlist(stats))
    data_frame <- data_frame %>% filter(Freq >= 5)
    write.csv(data_frame, file = ngrams_path, row.names=FALSE)
  }
  
  jobs <- lapply(1:4, function(n) { 
    print(paste("Calculating - ", n))
    mcparallel(create_ngrams(n))
  })
  mccollect(jobs)
  
  jobs <- lapply(5:7, function(n) { 
    print(paste("Calculating - ", n))
    mcparallel(create_ngrams(n))
  })
  mccollect(jobs)
  
  jobs <- lapply(8:10, function(n) { 
    print(paste("Calculating - ", n))
    mcparallel(create_ngrams(n))
  })
  mccollect(jobs)
}


