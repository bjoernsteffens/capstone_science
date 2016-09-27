
#install.packages("RWeka")

rm(list=ls())
dev.off()
library(tm)
library(RWeka)
library(SnowballC)
library(wordcloud)
library(data.table)
library(parallel)

#Preparing the parallel cluster using the cores
cl <- makeCluster(detectCores())
invisible(clusterEvalQ(cl, library(tm)))
invisible(clusterEvalQ(cl, library(RWeka)))
options(mc.cores=24)

######################################
# Corpus Stuff

df_twitter2 <- read.csv("../data/final/en_US/en_US.twitter.txt", sep = " " ,header = F, stringsAsFactors = F)
# Take 33K random Samples
df_twitter3 <- df_twitter2[sample(1:nrow(df_twitter2),33000),]
df_twitter3 <- df_twitter3[complete.cases(df_twitter3),]

df_news2 <- read.csv("../data/final/en_US/en_US.news.txt", sep = " " ,header = F, stringsAsFactors = F)
# Take 16K random Samples
df_news3 <- df_news2[sample(1:nrow(df_news2),30000),]
df_news3 <- df_news3[complete.cases(df_news3),]

df_blogs2 <- read.csv("../data/final/en_US/en_US.blogs.txt", sep = " " ,header = F, stringsAsFactors = F)
# Take 10K random Samples
df_blogs3 <- df_blogs2[sample(1:nrow(df_blogs2),20000),]
df_blogs3 <- df_blogs3[complete.cases(df_blogs3),]


tdm.create <- function(string, ng){
    
    # Create ngrams in the tdm instead of single words.
    # tutorial on rweka - http://tm.r-forge.r-project.org/faq.html
    
    # 
    corpus <- Corpus(VectorSource(string)) # create corpus for TM processing
    corpus <- tm_map(corpus, content_transformer(tolower))
    corpus <- tm_map(corpus, removeNumbers) 
    corpus <- tm_map(corpus, removePunctuation)
    corpus <- tm_map(corpus, stripWhitespace)
    corpus <- tm_map(corpus, removeWords, c(stopwords("english"),"ass", "ass ass", "ass ass ass", "jobs jobs jobs jobs"))
    #options(mc.cores=1) # http://stackoverflow.com/questions/17703553/bigrams-instead-of-single-words-in-termdocument-matrix-using-r-and-rweka/20251039#20251039
    BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = ng, max = ng)) # create n-grams
    tdm <- TermDocumentMatrix(corpus, control = list(tokenize = BigramTokenizer)) # create tdm from n-grams
    
}

######################################
# Wordcloud Stuff

# 1 words
d1 <- Sys.time()
tdm1 <- tdm.create(c(df_twitter3,df_blogs3, df_news3), 1)
d2 <- Sys.time()
difftime(d2,d1, units = "min")

# 2 words
d1 <- Sys.time()
tdm2 <- tdm.create(c(df_twitter3,df_blogs3, df_news3), 2)
d2 <- Sys.time()
difftime(d2,d1, units = "min") 

# 3 words
d1 <- Sys.time()
tdm3 <- tdm.create(c(df_twitter3,df_blogs3, df_news3), 3)
d2 <- Sys.time()
difftime(d2,d1, units = "min")

# 4 words
d1 <- Sys.time()
tdm4 <- tdm.create(c(df_twitter3,df_blogs3, df_news3), 4)
d2 <- Sys.time()
difftime(d2,d1, units = "min")

# Find pairs ocurring more than X times in the corpus
findFreqTerms(tdm1, lowfreq = 200)
findFreqTerms(tdm2, lowfreq = 30)
findFreqTerms(tdm3, lowfreq = 5)
findFreqTerms(tdm4, lowfreq = 4)


# Find the top terms and export to disk
tdm1.matrix <- as.matrix(tdm1)
topwords1 <- rowSums(tdm1.matrix)
head(sort(topwords1, decreasing = TRUE))
df_twitter_1gram <- data.frame(head(sort(topwords1, decreasing = TRUE),500))
df_twitter_1gram$Words <- row.names(df_twitter_1gram)
colnames(df_twitter_1gram) <- c("Count","Words")
write.csv(df_twitter_1gram, "df_twitter_1gram.csv")

tdm2.matrix <- as.matrix(tdm2)
topwords2 <- rowSums(tdm2.matrix)
head(sort(topwords2, decreasing = TRUE))
df_twitter_2gram <- data.frame(head(sort(topwords2, decreasing = TRUE),500))
df_twitter_2gram$Words <- row.names(df_twitter_2gram)
colnames(df_twitter_2gram) <- c("Count","Words")
write.csv(df_twitter_2gram, "df_twitter_2gram.csv")

tdm3.matrix <- as.matrix(tdm3)
topwords3 <- rowSums(tdm3.matrix)
head(sort(topwords3, decreasing = TRUE))
df_twitter_3gram <- data.frame(head(sort(topwords3, decreasing = TRUE),500))
df_twitter_3gram$Words <- row.names(df_twitter_3gram)
colnames(df_twitter_3gram) <- c("Count","Words")
write.csv(df_twitter_3gram, "df_twitter_3gram.csv")

tdm4.matrix <- as.matrix(tdm4)
topwords4 <- rowSums(tdm4.matrix)
head(sort(topwords4, decreasing = TRUE))
df_twitter_4gram <- data.frame(head(sort(topwords4, decreasing = TRUE),500))
df_twitter_4gram$Words <- row.names(df_twitter_4gram)
colnames(df_twitter_4gram) <- c("Count","Words")
write.csv(df_twitter_4gram, "df_twitter_4gram.csv")

par(mfrow=c(4,1))
# 1-Wordcloud
freq1.df = data.frame(word=names(topwords1), freq=topwords1)
freq1.df <- freq1.df[complete.cases(freq1.df),]
pal=brewer.pal(8,"Reds")
pal=pal[-(1:3)]
wordcloud(freq1.df$word,freq1.df$freq,max.words=30,random.order = F, colors=pal)

# 2-Wordcloud
freq2.df = data.frame(word=names(topwords2), freq=topwords2)
freq2.df <- freq2.df[complete.cases(freq2.df),]
pal=brewer.pal(8,"Greens")
pal=pal[-(1:3)]
wordcloud(freq2.df$word,freq2.df$freq,max.words=30,random.order = F, colors=pal)

# 3-Wordcloud
freq3.df = data.frame(word=names(topwords3), freq=topwords3)
freq3.df <- freq3.df[complete.cases(freq3.df),]
pal=brewer.pal(8,"Blues")
pal=pal[-(1:3)]
wordcloud(freq3.df$word,freq3.df$freq,max.words=30,random.order = F, colors=pal)

# 4-Wordcloud
freq4.df = data.frame(word=names(topwords4), freq=topwords4)
freq4.df <- freq4.df[complete.cases(freq4.df),]
pal=brewer.pal(8,"Dark2")
pal=pal[-(1:3)]
wordcloud(freq4.df$word,freq4.df$freq,max.words=30,random.order = F, colors=pal)

