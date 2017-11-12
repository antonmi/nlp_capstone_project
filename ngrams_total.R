library(hash)
library(dplyr)

for(i in c(1:10)) {
  print("======")
  print(i)
  
  file <- paste('data/ngrams/twitter_ngrams', i, '.txt', sep = '')
  twitter_set <- read.csv(file)
  file <- paste('data/ngrams/blogs_ngrams', i, '.txt', sep = '')
  blogs_set <- read.csv(file)
  file <- paste('data/ngrams/news_ngrams', i, '.txt', sep = '')
  news_set <- read.csv(file)

  fill_stats <- function(stats, set) {
    size <- length(set[,1])
    for (i in c(1:size)) {
      row <- set[i,]
      phrase <- as.character(row[[1]])
      count <- as.integer(row[[2]])
      if (is.null(stats[[phrase]])) {
        stats[[phrase]] = count
      } else {
        stats[[phrase]] = stats[[phrase]] + count
      }
    } 
    return(stats)
  }
  
  stats <- hash()
  print("twitter_set")
  stats <- fill_stats(stats, twitter_set)
  print("blogs_set")
  stats <- fill_stats(stats, blogs_set)
  print("news_set")
  stats <- fill_stats(stats, news_set)
  
  stats <- as.list(stats)

  data_frame <- data.frame(names(stats), unlist(stats))
  names(data_frame) <- c("ngrams","Freq")
  data_frame <- arrange(data_frame, desc(Freq))
  
  file <- paste('data/ngrams/total', i, '.txt', sep = '')
  write.csv(data_frame, file, row.names = FALSE)
}
