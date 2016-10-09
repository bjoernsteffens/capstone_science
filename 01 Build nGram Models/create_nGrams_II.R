##############################################
# Quanteda Approach
# https://cran.r-project.org/web/packages/quanteda/vignettes/quickstart.html
# http://kbenoit.github.io/quanteda/intro/overview.html
# http://rstudio-pubs-static.s3.amazonaws.com/151199_c31c3aa978614a889f938f993065450b.html
# http://rpackages.ianhowson.com/cran/quanteda/man/ngrams.html
# https://cran.r-project.org/web/packages/quanteda/quanteda.pdf
# https://54.225.166.221/DMW29/194887
# http://www.modsimworld.org/papers/2015/Natural_Language_Processing.pdf
#install.packages("quanteda")


rm(list=ls())
dev.off()
require(quanteda)
#library(tm)
#library(RWeka)
#library(SnowballC)
library(wordcloud)
library(data.table)
library(parallel)

#Preparing the parallel cluster using the cores
cl <- makeCluster(detectCores())
invisible(clusterEvalQ(cl, library(quanteda)))
options(mc.cores=24)

##############################################
# Corpus Stuff

df_twitter <- readLines("../data/final/en_US/en_US.twitter.txt", skipNul = T, encoding = "UTF-8")
df_news <- readLines("../data/final/en_US/en_US.news.txt", skipNul = T, encoding = "UTF-8")
df_blogs <- readLines("../data/final/en_US/en_US.blogs.txt", skipNul = T, encoding = "UTF-8") 
doclib <- c(sample(df_blogs,500000),sample(df_news,500000),sample(df_twitter,1000000))

myCorpus <- corpus(doclib)  # build the corpus

dfm.create <- function(corpus, ngrams) {
    dfm <- dfm(myCorpus, 
               ngrams = ngrams,
               concatenator = " ",
               #ignoredFeatures = stopwords("english"),
               toLower = T,
               removeNumbers = T, 
               removePunct = T,
               removeSeparators = T,
               removeTwitter = T,
               stem = F,
               language = "english")
    
    return(dfm)
}

##############################################
# Create the ngrams
d1 <- Sys.time()
df_1gram <- data.frame(as.matrix(topfeatures(dfm.create(myCorpus, 1), 50000)))
df_2gram <- data.frame(as.matrix(topfeatures(dfm.create(myCorpus, 2), 50000)))
df_3gram <- data.frame(as.matrix(topfeatures(dfm.create(myCorpus, 3), 50000)))
df_4gram <- data.frame(as.matrix(topfeatures(dfm.create(myCorpus, 4), 50000)))
d2 <- Sys.time()
difftime(d2,d1, units = "min")

dfm.fixwrite <- function(Docs, string) {
    
    Docs$Word <- rownames(Docs)
    colnames(Docs) <- c("Count", "Words")
    write.csv(Docs, string)
    return(Docs)
    
}

df_1gram <- dfm.fixwrite(df_1gram, "df_1gram.csv")
df_2gram <- dfm.fixwrite(df_2gram, "df_2gram.csv")
df_3gram <- dfm.fixwrite(df_3gram, "df_3gram.csv")
df_4gram <- dfm.fixwrite(df_4gram, "df_4gram.csv")
