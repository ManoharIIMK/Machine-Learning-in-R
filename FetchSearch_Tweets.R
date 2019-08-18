#To remove variables in the workspace
rm(list=ls(all=TRUE))


#install.packages("twitteR")
#install.packages("ROAuth")
library("twitteR")
library("ROAuth")

api_key <- "****" # or Consumer Key from dev.twitter.com. API Identifier
api_secret <- "***"
token <- "***" # Access token
token_secret <- "***"

# Create Twitter Connection
setup_twitter_oauth(api_key, api_secret, token, token_secret)
# Expected response will be:
# "Using direct authentication"
# Use a local file ('.httr-oauth'), to cache OAuth access credentials between R sessions?
# 
# 1: Yes
# 2: No
#Select 1 to make the authentication faster next time

# Run Twitter Search based on keyword or otherwise using a user account
tweets <- searchTwitter("Keyword"
                        , n=100, lang="en")
##                       ,since="2019-08-11",sinceID = '896060199772971008')

# Transform tweets list into a data frame
tweets.df <- twListToDF(tweets)

#Save the data frame
save(tweets.df, file="tweetsDF1")

#Save to the corpus
mycorpus <- tweets.df$text
save(mycorpus, file="tweetcorpus1")

load("tweetsDF1")

