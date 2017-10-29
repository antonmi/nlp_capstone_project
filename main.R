source('ngrams.R')

build_ngrams('news', 'en_US/en_US.news.txt')


twitter_1 <- read.csv('data/ngrams/twitter_ngrams1.txt')
twitter_2 <- read.csv('data/ngrams/twitter_ngrams2.txt')
twitter_3 <- read.csv('data/ngrams/twitter_ngrams3.txt')
twitter_5 <- read.csv('data/ngrams/twitter_ngrams5.txt')

library(ggplot2)
source('multiplot.R')

n = 20
p1 <- ggplot(head(twitter_1, n=n), aes(x=reorder(ngrams, Freq), y=Freq)) + geom_bar(stat="identity") + coord_flip()
p2 <- ggplot(head(twitter_2, n=n), aes(x=reorder(ngrams, Freq), y=Freq)) + geom_bar(stat="identity") + coord_flip()
p3 <- ggplot(head(twitter_3, n=n), aes(x=reorder(ngrams, Freq), y=Freq)) + geom_bar(stat="identity") + coord_flip()
p5 <- ggplot(head(twitter_5, n=n), aes(x=reorder(ngrams, Freq), y=Freq)) + geom_bar(stat="identity") + coord_flip()

multiplot(p1, p2, p3, p5, cols=2)