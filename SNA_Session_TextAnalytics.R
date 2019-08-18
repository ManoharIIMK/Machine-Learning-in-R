#To remove variables in the workspace
rm(list=ls(all=TRUE))

load("D:/OutputFiles/tweetcorpusCBFC1")
#Loads mycorpus - list of  tweets 
load("D:/OutputFiles/tweetsCBFC1")
#loads the data frame of tweet

# install.packages("tm")
library(tm)
getSources()
getReaders()

#iconv Standardize the corpus content text
mycorpus <- iconv(enc2utf8(mycorpus), sub="byte")

# build a corpus, and specify the source to be character vectors
myCorpus <- Corpus(VectorSource(mycorpus))
class(myCorpus)
class(myCorpus[[1]])
summary(myCorpus)
inspect(myCorpus[1:5])

#******************************************************#
#Text cleaning starts
#******************************************************#
getTransformations()

# Convert the text to Lower case - For English language text this is required 
myCorpus <- tm_map(myCorpus, content_transformer(tolower))

# Remove symbols @ and #
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, "", x))
myCorpus <- tm_map(myCorpus, toSpace, "[@#]")

# remove URLs
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeURL))

# remove anything other than English letters or space
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))

# remove stopwords
myStopwords <- c(setdiff(stopwords('english'), c("r", "big")),
                 "use", "see", "used", "via", "amp", "rt")
myCorpus <- tm_map(myCorpus, removeWords, myStopwords)

#see myCorpus[[1]]$content

# remove extra whitespace
myCorpus <- tm_map(myCorpus, stripWhitespace)

# keep a copy for stem completion later
myCorpusCopy <- myCorpus

#******************************************************#
#Text pre-processing starts

# Stemming
myCorpus <- tm_map(myCorpus, stemDocument) # stem words

#test by removing more words now after stemming 
#myCorpus <- tm_map(myCorpus, removeWords, c("#word1****","#word2****"))

writeLines(strwrap(myCorpus[[190]]$content, 60))


# count word frequency function
wordFreq <- function(corpus, word) {
  results <- lapply(corpus,
                    function(x) { grep(as.character(x), pattern=paste0("\\<",word)) }
  )
  sum(unlist(results))
}

#Count the word frequency of each term of interest
#n.term1 <- wordFreq(myCorpus, "#term1****")


# replace oldword with newword
replaceWord <- function(corpus, oldword, newword) {
  tm_map(corpus, content_transformer(gsub),
         pattern=oldword, replacement=newword)
}
#myCorpus <- replaceWord(myCorpus, "#oldword****", "#newword*****")


# Text pre processing ends 

#******************************************************#
#Text Representation starts now 
#******************************************************#

#Create Term Document Matrix
tdm <- TermDocumentMatrix(myCorpus,
                          control = list(wordLengths = c(1, Inf)))
tdm

# tdmr <-TermDocumentMatrix(myCorpus,
#                           control=list(wordLengths=c(2, 20),
#                                        bounds = list(global = c(3,Inf))))
# tdmr
# tdm<-tdmr

# Zipf's plot check
Zipf_plot(tdm)

#Viewing a small sample
#idx <- which(dimnames(tdm)$Terms %in% c("#term1***", "#term2***", "#term3***","#term4***"))

#as.matrix(tdm[idx, 21:30])

#  Start by removing sparse terms:   
tdms <- removeSparseTerms(tdm, 0.9) # This makes a matrix that is 10% empty space, maximum.   
inspect(tdms) 


#************************************#
#Text analytics application begins
#************************************#

# inspect frequent words
(freq.terms <- findFreqTerms(tdm, lowfreq = 500))
idx <- which(dimnames(tdm)$Terms %in% freq.terms)
inspect(tdm[idx,21:30])

#Term Frequency table: Finding frequent terms
#1
m<-as.matrix(tdm)
term_freq <- rowSums(m)
ord <- order(term_freq,decreasing=TRUE)
term_freq[head(ord)]
term_freq[tail(ord)]

sorted_terms <- sort(term_freq,decreasing=TRUE)
d <- data.frame(word = names(sorted_terms),term_freq=sorted_terms)
head(d)
head(d,10)

#2
term.freq <- subset(term_freq, term_freq >= 500)
df <- data.frame(term = names(term.freq), freq = term.freq)
library(ggplot2)
ggplot(df, aes(x=term, y=freq)) + geom_bar(stat="identity") +
  xlab("Terms") + ylab("Count") + coord_flip() +
  theme(axis.text=element_text(size=7))
#3
findFreqTerms(tdm,lowfreq=500)


#install.packages("RColorBrewer")
library(RColorBrewer)
m <- as.matrix(tdm)
# calculate the frequency of words and sort it by frequency
word.freq <- sort(rowSums(m), decreasing = T)
# colors
pal <- brewer.pal(9, "BuGn")[-(1:4)]

# plot word cloud
library(wordcloud)
#setting the same seed each time ensures consistent look across clouds
set.seed(32)
wordcloud(words = names(word.freq), freq = word.freq, min.freq = 300,
          random.order = F, colors = pal)

# which words are associated with 'r'?
#findAssocs(tdm, "term1", 0.3)
#findAssocs(tdm, "term2", 0.3)
#findAssocs(tdm, "term3", 0.2)

#install.packages("devtools")
# source("https://bioconductor.org/biocLite.R")
# biocLite("graph")
# biocLite("Rgraphviz")
library(graph)
#library(Rgraphviz)
(freq.terms <- findFreqTerms(tdm, lowfreq = 500))
#plot(tdm, term = freq.terms, corThreshold = 0.1, weighting = T)

# General Inquirer is the Dictionary for Emotions & other classification of words
# http://www.wjh.harvard.edu/~inquirer/homecat.htm
## install.packages("tm.lexicon.GeneralInquirer", repos="http://datacube.wu.ac.at", type="source")
require("tm.lexicon.GeneralInquirer")
pos.vec <- tm::tm_term_score(tdm,terms_in_General_Inquirer_categories("Positiv"))
pos.score <- sum(pos.vec)
neg.vec <- tm::tm_term_score(tdm,terms_in_General_Inquirer_categories("Negativ"))
neg.score <- sum(neg.vec)
Strong.score <- sum(tm::tm_term_score(tdm,terms_in_General_Inquirer_categories("Power")))
weak.score <- sum(tm::tm_term_score(tdm,terms_in_General_Inquirer_categories("Submit")))
active.score <- sum(tm::tm_term_score(tdm,terms_in_General_Inquirer_categories("Active")))
passive.score <- sum(tm::tm_term_score(tdm,terms_in_General_Inquirer_categories("Passive")))

#Emotions
Pleasur.score <- sum(tm::tm_term_score(tdm,terms_in_General_Inquirer_categories("Pleasur")))
Pain.score <- sum(tm::tm_term_score(tdm,terms_in_General_Inquirer_categories("Pain")))
feel.score <- sum(tm::tm_term_score(tdm,terms_in_General_Inquirer_categories("Feel")))
anxiety.score <- sum(tm::tm_term_score(tdm,terms_in_General_Inquirer_categories("Arousal")))
Virtue.score <- sum(tm::tm_term_score(tdm,terms_in_General_Inquirer_categories("Virtue")))
Vice.score <- sum(tm::tm_term_score(tdm,terms_in_General_Inquirer_categories("Vice")))

# Negation.vec <-tm::tm_term_score(tdm,terms_in_General_Inquirer_categories("No"))
Negation.vec <-tm::tm_term_score(tdm,c("no","not","nay","nope","neither","nor","nt"))
Negation.score <- sum(Negation.vec)

#correct sentiment with negation
Negation.vec[Negation.vec==1]<- -1
Negation.vec[Negation.vec==0]<- 1
Corrected.pos.score<-sum(pos.vec*Negation.vec)
Corrected.neg.score<-sum(neg.vec*Negation.vec)

sentiment.df<-data.frame(Positive=pos.score,corrPos= Corrected.pos.score,
                         negative=neg.score,corrNeg= Corrected.neg.score,strong=Strong.score,
                         weak=weak.score,activeOrient=active.score,passiveOrient=passive.score,
                         pleasure=Pleasur.score, pain=Pain.score,feel=feel.score,
                         anxiety=anxiety.score,virtue=Virtue.score,vice=Vice.score,
                         negation=Negation.score)

## pie chart - Not the best graph --- use with caution ***

labs = paste(simData$FacVar3, counts)  ## create labels
pie(cbind(pos.score,neg.score), c(paste("Positive",pos.score), paste("Negative",neg.score)), col = c("green","red"))  ## plot

#ObserveNegation
neg_idx <- which(Negation.vec==-1)
observe.neg.df<-data.frame(mssg=mycorpus[neg_idx],pos.vec[neg_idx],
                           neg.vec[neg_idx],Negation.vec[neg_idx])

#Plot sentiment analysis 
library(data.table)
library(xts)
sentiment.GI.vec <-1
sentiment.GI.vec$pscore <- pos.vec
sentiment.GI.vec$nscore <- neg.vec
sentiment.GI.vec$date <- as.IDate(tweets.df$created)
result_GI <- aggregate(pscore ~ date, data = sentiment.GI.vec, FUN=sum)

dtm <- as.DocumentTermMatrix(tdm)
rowTotals <- apply(dtm , 1, sum) #Find the sum of words in each Document
dtm  <- dtm[rowTotals> 0, ] 
terms = colnames(dtm)
# Find the positive and negative terms using the lexicons.
pos.terms = terms[terms %in% terms_in_General_Inquirer_categories("Positiv")]
neg.terms = terms[terms %in% terms_in_General_Inquirer_categories("Negativ")]
PosCloud = function() {
  wordcloud(
    pos.terms,
    colSums(as.matrix(dtm[ , pos.terms])),
    min.freq=1,
    scale=c(4,0.7),
    color=brewer.pal(n=9, "Greens")[6:9]
  )
}

NegCloud = function() {
  wordcloud(
    neg.terms,
    colSums(as.matrix(dtm[ , neg.terms])),
    min.freq=1,
    scale=c(4,0.7),
    color=brewer.pal(n=9, "Reds")[6:9]
  )
}
PosCloud()
NegCloud()

#Topic Detection - Information retrieval

library(topicmodels)

# remove sparse terms
dtms<-removeSparseTerms(dtm,0.99)
dtm_bool <- dtms
dtm_bool$v[,] =1
doc_freq <- apply(dtms , 2, sum) #Find the number in each D
sorted_terms_df <- sort(doc_freq,decreasing=TRUE)
d_df <- data.frame(word = names(sorted_terms_df),df=sorted_terms_df)
dtms$dimnames$Terms[doc_freq<5000]
dtms  <- dtms[,doc_freq<5000]


lda <- LDA(dtm, k = 2) # find 2 topics
term <- terms(lda, 3) # first 3 terms of every topic
(term <- apply(term, MARGIN = 2, paste, collapse = ", "))

#rm(lda)

topics <- topics(lda) # 1st topic identified for every document (tweet)

load("tweetsCBFC1")
# install.packages("xts")
library(data.table)
library(xts)

topics <- data.frame(date=as.IDate(tweets.df$created), topic=topics)
ggplot(topics, aes(date, fill = term[topic])) +
  geom_density(position = "stack")+
  theme(legend.key.width=unit(0.3,"cm"),legend.key.height=unit(0.3,"cm"),legend.position = c(0.7, 0.8))

#Hierarchical Clustering
library(cluster)  


d <- dist(t(dtms), method="euclidian")   # First calculate distance between words
fit <- hclust(d=d, method="ward.D")   
plot.new()
plot(fit, hang=-1, cex = 0.3)
groups <- cutree(fit, k=2)   # "k=" defines the number of clusters you are using   
rect.hclust(fit, k=5, border="red") # draw dendogram with red borders around the 5 clusters   

#d <- cut(as.dendrogram(fit), h=80)
#d
#par(mfrow=c(1, 1))
#plot(d$lower[[1]])
#plot.new()
#plot(d$lower[[2]])


# Cut the dendogram to find the interpretable number of clusters
d <- cut(as.dendrogram(fit), h=80)
d
par(mfrow=c(1, 1))
plot(d$lower[[1]])
