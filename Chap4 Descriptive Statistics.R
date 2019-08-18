#Workspace
getwd()
setwd('E:/IIM/BABD_B3 docs/')  #Sets the working directory to C: Drive
#=============================================================
#                       Descriptive Statistics
#=============================================================
#  working with default datasets in R
#  Extracting datasets from default packages
#  Simple and Summary Stats in R
#  Pivot Tables
#  Groupby Stats in R

#########################################################################

#R Provides DataSets
#Datasets are part of packages
#Good Source to view list of R Packages
#https://vincentarelbundock.github.io/Rdatasets/datasets.html

#Lets use the data  "Diamonds". It is a part of the package "Stat2Data"
#To use "Diamonds", we have to install the package "Stat2Data"


#install.packages("Stat2Data")
library(Stat2Data)
data(Diamonds, package="Stat2Data")

#########################################################################

#Descriptive Statistics
#Let us work with the package diamonds

View(Diamonds)
str(Diamonds)
head(Diamonds)
tail(Diamonds)

#Simple Statistics
mean(Diamonds$TotalPrice)
max(Diamonds$TotalPrice)
sd(Diamonds$TotalPrice)
table(Diamonds$Color)
mean(Diamonds$PricePerCt)
median(Diamonds$PricePerCt)
sd(Diamonds$PricePerCt)


#########################################################################
library(Hmisc)
#Summary Commands with multiple outputs
summary(Diamonds$TotalPrice)
quantile(Diamonds$TotalPrice)
summary(Diamonds)
describe(Diamonds)   # Hmisc  package us for describe

#Did you notice the difference between summary and describe

#########################################################################
#Frequency Tables
table(Diamonds$Color)
table(Diamonds$Clarity)

#Contingency Tables
#Similar to Pivot Tables in Excel
pivot <- table(Diamonds$Color,Diamonds$Clarity)
t(pivot)

#########################################################################

#GroupBy functions
library(psych)

#Describe All attributes
describeBy(Diamonds,Diamonds$Color)
describeBy(Diamonds,Diamonds$Clarity)

#Describe Selected attributes
describeBy(Diamonds[,5:6],Diamonds$Color)
describeBy(Diamonds[,c('PricePerCt','TotalPrice')],Diamonds$Color)
describeBy(Diamonds$PricePerCt,Diamonds$Color)

#Exercise
#Let's do the groupbys for Clarity

#########################################################################

#Get means for subsets of data
mean(subset(Diamonds,Color == "D")$TotalPrice)
mean(subset(Diamonds,Color == "E")$TotalPrice)
median(subset(Diamonds,Color == "D")$TotalPrice)
median(subset(Diamonds,Color == "E")$TotalPrice)

#Exercise
#Let's get quantiles for subset of data by "Clarity"
#Return a particular percentile

#########################################################################


