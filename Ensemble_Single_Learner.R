install.packages("ggplot2")
install.packages('Rcpp')
install.packages("stringi")
install.packages("car")
install.packages("rpart")
install.packages("adabag")
install.packages("ada")
install.packages("party")
install.packages("klaR")
install.packages("caret")


library(car)
library(ggplot2)
library(rpart)
library(adabag)
library(party)
library(klaR)
library(caret)


#Data Source
#http://www.consumerfinance.gov/data-research/hmda/explore

#Read Data
#housingdata <-  read.csv("C:/Users/IIM/Downloads/hmda_lar.csv")
data <- nhousingdata
str(data)

#Data Preparation
#Convert into factor variables
data$action_taken <- as.factor(data$action_taken)
data$agency_code <- as.factor(data$agency_code)
data$applicant_ethnicity <- as.factor(data$applicant_ethnicity)
data$applicant_race <- as.factor(data$applicant_race)
data$applicant_sex <- as.factor(data$applicant_sex)
data$co_applicant_ethnicity  <- as.factor(data$co_applicant_ethnicity)
data$co_applicant_race  <- as.factor(data$co_applicant_race)
data$co_applicant_sex <- as.factor(data$co_applicant_sex)
data$preapproval  <- as.factor(data$preapproval)
data$purchaser_type  <- as.factor(data$purchaser_type)

#Adding random column to data
set.seed(pi)
data$random <- runif(nrow(data),1,nrow(data))

#Split data into training set and test set
train <- data[data$random<=48000, ]
test  <- data[data$random>48000, ]
nrow(train)
nrow(test)

#Verify proportional split of labels in both test and train
table(train$action_taken)
table(test$action_taken)


#Define Predictors and Predicted
predicted  <- "action_taken"
predictors <- c("agency_code", "applicant_ethnicity", "applicant_income_000s",
                "co_applicant_ethnicity","co_applicant_race",
                "co_applicant_sex","preapproval","hud_median_family_income", 
                "loan_amount_000s", "number_of_1_to_4_family_units",
                "number_of_owner_occupied_units", "minority_population",
                "population")
fmla       <-  paste(predicted,paste(predictors,collapse="+"), sep="~")


# Bagging Model

baggingmodel     <- bagging(fmla,data=train)
baggingmodelpred <- predict.bagging(baggingmodel,newdata=test)
baggingmodelprob <- as.data.frame(baggingmodelpred$prob)
test$baggingpred <- baggingmodelprob$V2
summary(test$baggingpred)
baggingcT = mean(test$baggingpred)

#Confusion Matrix
test$baggingclass <- ifelse(test$baggingpred  > 0.975, 1,0)
ENS1_CF  <- table(predicted=test$baggingclass, actual=test$action_taken)
ENS1_TP  <- ENS1_CF[2,2]
ENS1_TN  <- ENS1_CF[1,1]
ENS1_FP  <- ENS1_CF[2,1]
ENS1_FN  <- ENS1_CF[1,2]
ENS1_ACC <- (ENS1_TP + ENS1_TN)/(ENS1_TP+ENS1_TN+ENS1_FP+ENS1_FN)
ENS1_SEN <- (ENS1_TP)/(ENS1_TP+ENS1_FN)
ENS1_PRE <- (ENS1_TP)/(ENS1_TP+ENS1_FP)
ENS1_SPE <- (ENS1_TN)/(ENS1_TN+ENS1_FP)
#Remarks - Poor on Specificity

#Boosting Model
boostingmodel     <- boosting(fmla, data=train)
boostingmodelpred <- predict.boosting(boostingmodel,newdata=test)
boostingmodelprob <- as.data.frame(boostingmodelpred$prob)
test$boostingpred <- boostingmodelprob$V2
summary(test$boostingpred)
boostingcT = mean(test$boostingpred)

#Confusion Matrix
boostingcT = mean(test$boostingpred)
test$boostingclass <- ifelse(test$boostingpred  > boostingcT,1,0)
ENS2_CF <- table(predicted=test$boostingclass, actual=test$action_taken)
ENS2_TP  <- ENS2_CF[2,2]
ENS2_TN  <- ENS2_CF[1,1]
ENS2_FP  <- ENS2_CF[2,1]
ENS2_FN  <- ENS2_CF[1,2]
ENS2_ACC <- (ENS2_TP + ENS2_TN)/(ENS2_TP+ENS2_TN+ENS2_FP+ENS2_FN)
ENS2_SEN <- (ENS2_TP)/(ENS2_TP+ENS2_FN)
ENS2_PRE <- (ENS2_TP)/(ENS2_TP+ENS2_FP)
ENS2_SPE <- (ENS2_TN)/(ENS2_TN+ENS2_FP)
#Remarks - Results look more balanced

#Benefit Analysis
BTP = 150; BTN = 150; LFP = -100; LFN = -25

True_POS  <- c(ENS1_TP,ENS2_TP)
True_NEG  <- c(ENS1_TN,ENS2_TN)
False_POS <- c(ENS1_FP,ENS2_FP)
False_NEG <- c(ENS1_FN,ENS2_FN)

imp_bagging   <- BTP*ENS1_TP+BTN*ENS1_TN+LFP*ENS1_FP+LFN*ENS1_FN
imp_boosting  <- BTP*ENS2_TP+BTN*ENS2_TN+LFP*ENS2_FP+LFN*ENS2_FN

impact    <- c(imp_bagging,imp_boosting)
Method    <- c("Bagging","Boosting")
analysis  <- data.frame(Method,True_POS,True_NEG,False_POS,False_NEG,impact)
View(analysis)

