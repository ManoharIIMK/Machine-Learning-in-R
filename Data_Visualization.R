## install.packages("ggplot2")
# Question 1
# Do we receive more likes on certain days of the week ? 

# Question 2
#  How many tweets did we send throughout the month ? 

# Question 3
# Are there certain times of day in which people like our tweets ? 


# Graphical visualization package
require("ggplot2") 
require(stringr)
require(lubridate)

#read the file
df_bak <- read.csv("data/Tweets_Organization.csv")

# number of rows and columns
dim(df_bak) 
# columns names
colnames(df_bak)
# summary of dataframe
str(df_bak)

# add day of week 
df_bak$day_of_week <- weekdays(as.Date(df_bak$time))

# add hour of the day
df_bak$hour_of_day <- hour(df_bak$time)

# create derived field with organic tweet or not 
df_bak = within(df_bak, {df_bak$organic_tweet = ifelse(str_detect(df_bak$promoted.impressions,"-"),1,0)})

#create derived field with  orginal tweet or replies/mention
df_bak = within(df_bak, {df_bak$tweet_type = ifelse(as.numeric(df_bak$organic_tweet == 0),"Promoted_tweet",ifelse(str_detect(df_bak$Tweet.text, "@"), "ReplyorMention","Organic_tweet"))})
                                                    
#Create appropriate visualizations

# Question 1
# Do we receive more likes on certain days of the week ? 

# Question 2
#  How many tweets did we send throughout the month ? 

# Question 3
# Are there certain times of day in which people like our tweets ? 
