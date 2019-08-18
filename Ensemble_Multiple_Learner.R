options(warn=-1)
options(digits=2)

install.packages("ggplot2")
install.packages('Rcpp')
install.packages("stringi")
install.packages("car")
install.packages("rpart")
install.packages("adabag")
install.packages("ada")
install.packages("party")
install.packages("DMwR")	
install.packages("klaR")
install.packages("caret")
install.packages("kernlab")
install.packages("randomForest")
install.packages("purrr")

library(ggplot2)
library(psych)
library(klaR)   #Naive-Bayes
library(rpart)  #Decision Trees
library(MASS)   #lda
library(purrr)
library(caret)
library(adabag) #bagging
library(car)
library(party)

######################################################################################

# Step 1 : Data Preparation

#Imported Data : bank_additional
#rm(bank)
bank <- bank_additional

#Explore the data
str(bank)

#Study the data and identify categorical variables that need to be converted into factors
#We find that following needs to be converted into factors

bank$job        <- as.factor(bank$job)
bank$marital    <- as.factor(bank$marital)
bank$education  <- as.factor(bank$education)
bank$default    <- as.factor(bank$default)
bank$housing    <- as.factor(bank$housing)
bank$loan       <- as.factor(bank$loan)
bank$contact    <- as.factor(bank$contact)
bank$month      <- as.factor(bank$month)
bank$day_of_week<- as.factor(bank$day_of_week)
bank$poutcome   <- as.factor(bank$poutcome)
bank$y          <- as.factor(bank$y)
bank$y          <- as.factor(as.numeric(bank$y)-1)

#Identify factor levels with only few counts and group them as " to "unknown"
#Why do we need to do this
#When a category has many options and some option have few counts
#It is possible that some options donot occure in test data and may cause a problem
#In model application

bank$default[bank$default == "yes"] <- "unknown"
bank$education[bank$education == "illeterate"] <- "unknown"
#To do simple check of freq counts, use the table function

#Check if any of the attributes has NULL Values
#If yes replace by mean or median
table(is.na(bank))
#Luckily we don't have any

#######################################################################################
# Step 2 : Select validation strategy and divide into test and train data
# One of the critical tasks in machine learning is the ability to validate results
# We use k-fold validation. In this example We shall use 4-fold validation

# In a k-fold validation method. The dataset is divided into k-folds of equal size
# Data is trained on k-1 folds and tested on the kth fold
# Let's split the data into four-folds

# step 2a : attach a random number column
set.seed(10)
bank$random <- runif(nrow(bank),min=0,max=nrow(bank))

#Folds are to be generated randomly
bank$fold   <- ifelse(bank$random <= quantile(bank$random,0.75),1,2)
train       <- bank[bank$fold==1, ]
test        <- bank[bank$fold==2, ]

#Store the relationship to be built as a varible for convenience

predicted <- "y";
predictors<- c("age","job","marital","education","default","housing",
               "loan","contact","month","day_of_week","duration","campaign",
               "pdays","previous","poutcome","emp.var.rate","cons.price.idx",
               "cons.conf.idx","euribor3m","nr.employed")
fmla <- paste(predicted, "~" , paste(predictors, collapse=' + '),sep= ' ')

#Check the relationship stored
fmla

#######################################################################################


#Ensemble modelling using on multiple-base learners (classifiers)

#Building Individual blocks of Ensemble model

#Component one of Ensemble Model : Logistic Regression
logisticmodel <- glm(fmla, data = train, family=binomial(link="logit"))
test$logisticpred <- predict(logisticmodel, newdata=test, type="response")
test$logisticpred[is.na(test$logisticpred)]<-mean(test$logisticpred,na.rm=TRUE)
ggplot(test,aes(x=logisticpred, color=y, linetype=y))+geom_density()

#Confusion Matrix
logisticT = mean(test$logisticpred)
test$logisticclass <- ifelse(test$logisticpred > logisticT, 1,0)
ENS1_CF <- table(predicted=test$logisticclass, actual=test$y)
ENS1_TP  <- ENS1_CF[2,2]
ENS1_TN  <- ENS1_CF[1,1]
ENS1_FP  <- ENS1_CF[2,1]
ENS1_FN  <- ENS1_CF[1,2]
ENS1_ACC <- (ENS1_TP + ENS1_TN)/(ENS1_TP+ENS1_TN+ENS1_FP+ENS1_FN)
ENS1_SEN <- (ENS1_TP)/(ENS1_TP+ENS1_FN)
ENS1_PRE <- (ENS1_TP)/(ENS1_TP+ENS1_FP)
ENS1_SPE <- (ENS1_TN)/(ENS1_TN+ENS1_FP)

#Remarks - Results useful

###########################################################################################

#Component Two of the Ensemble Model : Naive Bayes
bayesmodel <- NaiveBayes(y ~ age + job + marital + education + default + housing + loan + contact + month + day_of_week + duration + campaign + pdays + previous + poutcome + emp.var.rate + cons.price.idx + cons.conf.idx + euribor3m + nr.employed, data=train)
bayesmodelpred <- predict(bayesmodel,newdata=test,type="raw")
bayesmodelpred <- as.data.frame(bayesmodelpred)
test$bayespred <- bayesmodelpred[,3]
test$bayespred[is.na(test$bayespred)]<-mean(test$bayespred,na.rm=TRUE)

#Confusion Matrix
bayescT = mean(test$bayespred)
test$bayesclass <- ifelse(test$bayespred  > bayescT, 1,0)
ENS2_CF  <- table(predicted=test$bayesclass, actual=test$y)
ENS2_TP  <- ENS2_CF[2,2]
ENS2_TN  <- ENS2_CF[1,1]
ENS2_FP  <- ENS2_CF[2,1]
ENS2_FN  <- ENS2_CF[1,2]
ENS2_ACC <- (ENS2_TP + ENS2_TN)/(ENS2_TP+ENS2_TN+ENS2_FP+ENS2_FN)
ENS2_SEN <- (ENS2_TP)/(ENS2_TP+ENS2_FN)
ENS2_PRE <- (ENS2_TP)/(ENS2_TP+ENS2_FP)
ENS2_SPE <- (ENS2_TN)/(ENS2_TN+ENS2_FP)
#Remarks - Results useful


###########################################################################################


#Component Three of Ensemble Model : LDA

ldamodel <- lda(y ~ age + job + marital + education + default + housing + loan + contact + month + day_of_week + duration + campaign + pdays + previous + poutcome + emp.var.rate + cons.price.idx + cons.conf.idx + euribor3m + nr.employed, data = train)
ldamodelpred <- predict(ldamodel, test)
ldamodelpred <- ldamodelpred$posterior
test$ldapred <- ldamodelpred[,2]
test$ldapred[is.na(test$ldapred)]<-mean(test$ldapred,na.rm=TRUE)

#Confusion Matrix
ldacT = mean(test$ldapred)
test$ldaclass <- ifelse(test$ldapred  > ldacT, 1,0)
ENS3_CF <- table(predicted=test$ldaclass, actual=test$y)
ENS3_TP  <- ENS3_CF[2,2]
ENS3_TN  <- ENS3_CF[1,1]
ENS3_FP  <- ENS3_CF[2,1]
ENS3_FN  <- ENS3_CF[1,2]
ENS3_ACC <- (ENS3_TP + ENS3_TN)/(ENS3_TP+ENS3_TN+ENS3_FP+ENS3_FN)
ENS3_SEN <- (ENS3_TP)/(ENS3_TP+ENS3_FN)
ENS3_PRE <- (ENS3_TP)/(ENS3_TP+ENS3_FP)
ENS3_SPE <- (ENS3_TN)/(ENS3_TN+ENS3_FP)
#Remarks - Results useful


###########################################################################################
#Component Four of Ensemble Model : CART

#Set minsplit criteria and minbucket criteria
#minsplit : the minimum number of observations that must exist in a node in order for a split to be attempted. 
#minbucket : the minimum number of observations in any terminal <leaf> node. 

#minsplit and minbucket 
zminsplit = 40
zminbucket = zminsplit / 2
zcp = 0.04

treemodel <- rpart(fmla,method="class", data=train,control=rpart.control(minsplit=zminsplit,minbucket=zminbucket,maxdepth=20,cp=zcp))
test$treepred <- predict(treemodel,newdata=test,type="prob")[,2]

#Confusion Matrix
treecT = mean(test$treepred)
test$treeclass <- ifelse(test$treepred  > treecT, 1,0)
ENS4_CF <- table(predicted=test$treeclass, actual=test$y)
ENS4_TP  <- ENS4_CF[2,2]
ENS4_TN  <- ENS4_CF[1,1]
ENS4_FP  <- ENS4_CF[2,1]
ENS4_FN  <- ENS4_CF[1,2]
ENS4_ACC <- (ENS4_TP + ENS4_TN)/(ENS4_TP+ENS4_TN+ENS4_FP+ENS4_FN)
ENS4_SEN <- (ENS4_TP)/(ENS4_TP+ENS4_FN)
ENS4_PRE <- (ENS4_TP)/(ENS4_TP+ENS4_FP)
ENS4_SPE <- (ENS4_TN)/(ENS4_TN+ENS4_FP)
#Remarks - Results useful


###########################################################################################

#Combining the output of Multiple Classifiers using Polling

#Polling using Majority Class
test$polledvotes <- test$ldaclass+test$bayesclass+test$treeclass+test$logisticclass
test$polledclass <- ifelse(test$polledvotes  >= 1, 1,0)
ENSP_CF <- table(predicted=test$polledclass, actual=test$y)
ENSP_TP  <- ENSP_CF[2,2]
ENSP_TN  <- ENSP_CF[1,1]
ENSP_FP  <- ENSP_CF[2,1]
ENSP_FN  <- ENSP_CF[1,2]
ENSP_ACC <- (ENSP_TP + ENSP_TN)/(ENSP_TP+ENSP_TN+ENSP_FP+ENSP_FN)
ENSP_SEN <- (ENSP_TP)/(ENSP_TP+ENSP_FN)
ENSP_PRE <- (ENSP_TP)/(ENSP_TP+ENSP_FP)
ENSP_SPE <- (ENSP_TN)/(ENSP_TN+ENSP_FP)

#Polling via Average Probabilities
test$polledpred <- test$ldapred+test$bayespred+test$treepred+test$logisticpred
summary(test$polledpred)
#polledpredCT = mean(test$polledpred)
polledpredCT =0.47961
test$polledpredclass <- ifelse(test$polledpred > polledpredCT, 1,0)
ENSPP_CF <- table(predicted=test$polledpredclass, actual=test$y)
ENSPP_TP  <- ENSPP_CF[2,2]
ENSPP_TN  <- ENSPP_CF[1,1]
ENSPP_FP  <- ENSPP_CF[2,1]
ENSPP_FN  <- ENSPP_CF[1,2]
ENSPP_ACC <- (ENSPP_TP + ENSPP_TN)/(ENSPP_TP+ENSPP_TN+ENSPP_FP+ENSPP_FN)
ENSPP_SEN <- (ENSPP_TP)/(ENSPP_TP+ENSPP_FN)
ENSPP_PRE <- (ENSPP_TP)/(ENSPP_TP+ENSP_FP)
ENSPP_SPE <- (ENSPP_TN)/(ENSPP_TN+ENSPP_FP)

#Gathering the values for a closer look
Method <- c("Logistic","Bayes","LDA","Tree","Polling","Averaging")
ENSACC <- c(ENS1_ACC,ENS2_ACC,ENS3_ACC,ENS4_ACC,ENSP_ACC,ENSPP_ACC)
ENSSEN <- c(ENS1_SEN,ENS2_SEN,ENS3_SEN,ENS4_SEN,ENSP_SEN,ENSPP_SEN)
ENSPRE <- c(ENS1_PRE,ENS2_PRE,ENS3_PRE,ENS4_PRE,ENSP_PRE,ENSPP_PRE)
ENSSPE <- c(ENS1_SPE,ENS2_SPE,ENS3_SPE,ENS4_SPE,ENSP_SPE,ENSPP_SPE)
data.frame(Method,ENSACC,ENSSEN,ENSPRE,ENSSPE)

#Benefit Analysis
BTP = 100; BTN = 40; LFP = -20; LFN = -120;

True_POS  <- c(ENS1_TP,ENS2_TP,ENS3_TP,ENS4_TP,ENSP_TP,ENSPP_TP)
True_NEG  <- c(ENS1_TN,ENS2_TN,ENS3_TN,ENS4_TN,ENSP_TN,ENSPP_TN)
False_POS <- c(ENS1_FP,ENS2_FP,ENS3_FP,ENS4_FP,ENSP_FP,ENSPP_FP)
False_NEG <- c(ENS1_FN,ENS2_FN,ENS3_FN,ENS4_FN,ENSP_FN,ENSPP_FN)

imp_log   <- BTP*ENS1_TP+BTN*ENS1_TN+LFP*ENS1_FP+LFN*ENS1_FN
imp_bayes <- BTP*ENS2_TP+BTN*ENS2_TN+LFP*ENS2_FP+LFN*ENS2_FN
imp_lda   <- BTP*ENS3_TP+BTN*ENS3_TN+LFP*ENS3_FP+LFN*ENS3_FN
imp_tree  <- BTP*ENS4_TP+BTN*ENS4_TN+LFP*ENS4_FP+LFN*ENS4_FN
imp_poll  <- BTP*ENSP_TP+BTN*ENSP_TN+LFP*ENSP_FP+LFN*ENSP_FN
imp_avg   <- BTP*ENSPP_TP+BTN*ENSPP_TN+LFP*ENSPP_FP+LFN*ENSPP_FN

impact    <- c(imp_log,imp_bayes,imp_lda,imp_tree,imp_poll,imp_avg)

analysis  <- data.frame(Method,ENSACC,ENSSEN,ENSSPE,True_POS, True_NEG, False_POS,False_NEG,impact)

View(analysis)
