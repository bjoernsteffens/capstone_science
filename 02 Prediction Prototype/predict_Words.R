####################################
# Prediction Stuff
# 
# Caveats:  This model only
#           considers ngrams
#           and does not include
#           any contextual
#           analysis

rm(list=ls())

require(RColorBrewer)
library(wordcloud)
library(RColorBrewer)
library(dplyr)
library(tm)
library(stringr)

d1 <- Sys.time()
freq2.df = read.csv("df_2gram.csv", header = T, sep = ",")
freq2.df <- freq2.df[complete.cases(freq2.df),][,2:3]
freq3.df = read.csv("df_3gram.csv", header = T, sep = ",")
freq3.df <- freq3.df[complete.cases(freq3.df),][,2:3]
freq4.df = read.csv("df_4gram.csv", header = T, sep = ",")
freq4.df <- freq4.df[complete.cases(freq4.df),][,2:3]
d2 <- Sys.time()
difftime(d2,d1, units = "auto")



####################################
# Check if there are words returned
# from searching the model
words.returned <- function(wordframe) {
    
    words <- as.integer(colSums(is.na(wordframe[1]))) +
             as.integer(colSums(is.na(wordframe[2])))
    
    if ( words > 0 ) {
        return ( FALSE )
    } else {
        return ( TRUE )
    }

}

####################################
# Fetch the matches of the previous
# 1,2 or 3 words depending on the
# length of what is passed in
predict.word <- function (sentence) {
    
    sentence <- tolower(sentence)
    the_words <- str_match_all(sentence, "\\S+")
    num_words <- length(the_words[[1]])
    
    ####################################
    # Grab only the last two words if
    # the sentence is longer than 3.
    # It is not very likely that
    # you will find the beginning
    # of the whole sentence in the 
    # model and you need to go back
    # to something more likely
    # that you can predict.
    if ( num_words > 3 ) {
        num_words <- 2
        sentence <- paste(
                    #the_words[[1]][[length(the_words[[1]]) - 2]],
                    the_words[[1]][[length(the_words[[1]]) - 1]],
                    the_words[[1]][[length(the_words[[1]])]],
                    sep = " ")
    }
    
    search_for <- paste("^",sentence, " ", sep = "")
    
    ####################################
    # Predict using the 2grams
    if ( num_words == 1 ) {
        
        df_pred2gram <- (filter(freq2.df, grepl(search_for, Words)) %>% arrange(desc(Count)))[1:5,]
        
        if ( !words.returned(df_pred2gram) ) {
            predicted_words <- "Could not predict"
        } else {
            df_splits2 <- data.frame(strsplit(as.character(df_pred2gram$Words), " "))
            df_pred2 <- data.frame(t(df_splits2))
            predicted_words <- as.character(df_pred2$X2)
        }
            
    }
    
    ####################################
    # Predict using the 3grams
    if ( num_words == 2 ) {
        

        df_pred3gram <- (filter(freq3.df, grepl(search_for, Words)) %>% arrange(desc(Count)))[1:5,]
        
        if ( !words.returned(df_pred3gram) ) {
            predicted_words <- "Could not predict"
        } else {
            df_splits3 <- data.frame(strsplit(as.character(df_pred3gram$Words), " "))
            df_pred3 <- data.frame(t(df_splits3))
            predicted_words <- as.character(df_pred3$X3)
        }
        
    }
    
    ####################################
    # Predict using the 4grams
    if ( num_words >= 3 ) {
        
        df_pred4gram <- (filter(freq4.df, grepl(search_for, Words)) %>% arrange(desc(Count)))[1:5,]
        
        if ( !words.returned(df_pred4gram) ) {
            predicted_words <- "Could not predict"
        } else {
            df_splits4 <- data.frame(strsplit(as.character(df_pred4gram$Words), " "))
            df_pred4 <- data.frame(t(df_splits4))
            predicted_words <- as.character(df_pred4$X4)
        }
        
    }
    
    ####################################
    # OLD BACKUP 
    # Predict using the 4grams
    # if ( num_words == 3 ) {
    # 
    #     df_pred4gram <- (filter(freq4.df, grepl(search_for, Words)) %>% arrange(desc(Count)))[1:5,]
    # 
    #     ####################################
    #     # Back-off strategy
    #     if ( !words.returned(df_pred4gram) ) {
    #         predicted_words <- "Could not predict"
    #     } else {
    #         df_splits4 <- data.frame(MC_tokenizer(df_pred4gram[,2]))
    #         df_pred4 <- data.frame(matrix(unlist(df_splits4), ncol = 4, byrow = T))
    #         predicted_words <- df_pred4$X4
    #     }
    # }
    
    return(predicted_words)
    
}

d1 <- Sys.time()
predict.word("I")
predict.word("I am")
predict.word("I am not")
predict.word("You have a")
predict.word("I will not be doing this")
predict.word("You are an absolute idiot and I would not like to see you again")
predict.word("I'll be there for you, I'd live and I'd")
d2 <- Sys.time()
difftime(d2,d1, units = "auto")