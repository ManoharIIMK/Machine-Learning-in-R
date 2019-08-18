#Implementing Market Basket Analysis using Apriori Algorithm

#read transactions
df_groceries <- read.csv("Class_demo.csv")
str(df_groceries)

df_sorted <- df_groceries[order(df_groceries$Member_number),]


#convert member number to numeric
df_sorted$Member_number <- as.numeric(df_sorted$Member_number)


#convert item description to categorical format

df_sorted$itemDescription <- as.factor(df_sorted$itemDescription)

str(df_sorted)

#convert dataframe to transaction format using ddply; 

if(sessionInfo()['basePkgs']=="dplyr" | sessionInfo()['otherPkgs']=="dplyr"){
  detach(package:dplyr, unload=TRUE)
}

#group all the items that were bought together; by the same customer on the same date
library(plyr)
df_itemList <- ddply(df_groceries, c("Member_number","Date"), function(df1)paste(df1$itemDescription,collapse = ","))

#remove member number and date
df_itemList$Member_number <- NULL
df_itemList$Date <- NULL

colnames(df_itemList) <- c("itemList")

#write to csv format
write.csv(df_itemList,"ItemList.csv", quote = FALSE, row.names = TRUE)

#-------------------- association rule mining algorithm : apriori -------------------------#

#load package required
library(arules)

#convert csv file to basket format
txn = read.transactions(file="ItemList.csv", rm.duplicates= FALSE, format="basket",sep=",",cols=1);

#remove quotes from transactions
txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)


#run apriori algorithm
basket_rules <- apriori(txn,parameter = list(minlen=3,supp = 0.14, conf = 0.5, target="rules", maxlen= 4))
#the version of apriori algorithm implemented gives you support for rules which may include both
# lhs and rhs items or only lhs inclusion of items for support calculation of rules
# See http://www.borgelt.net/doc/apriori/apriori.html for more details
# You can also find the frequent item set instead of rules

#view rules
inspect(basket_rules)

#convert to datframe and view; optional piece of code
df_basket <- as(basket_rules,"data.frame")
df_basket$confidence <- df_basket$confidence * 100
df_basket$support <- df_basket$support * nrow(df_basket)


# Mining rules for recommendations:

# split lhs and rhs into two columns
library(reshape2)
df_basket <- transform(df_basket, rules = colsplit(rules, pattern = "=>", names = c("lhs","rhs")))

# Remove curly brackets around rules
df_basket$rules$lhs <- gsub("[[:punct:]]", "", df_basket$rules$lhs)
df_basket$rules$rhs <- gsub("[[:punct:]]", "", df_basket$rules$rhs)

# convert to chracter
df_basket$rules$lhs <- as.character(df_basket$rules$lhs)
df_basket$rules$rhs <- as.character(df_basket$rules$rhs)

library(stringi)
library(dplyr)
df_basket$rules %>%
  filter(stri_detect_fixed(lhs, "yogurt")) %>%
  select(rhs)



#plot the rules
library(arulesViz)
plot(basket_rules)

set.seed(8000)
#different ways to visualize the rules 
plot(basket_rules, method = "grouped", control = list(k = 5))

plot(basket_rules[1:10,], method="graph", control=list(type="items"))

plot(basket_rules[1:10,], method="paracoord",  control=list(alpha=.5, reorder=TRUE))

itemFrequencyPlot(txn, topN = 5)
#For interactive inspection of rules use the below line
#plot(basket_rules[1:10,],measure=c("support","lift"),shading="confidence",interactive=T)

