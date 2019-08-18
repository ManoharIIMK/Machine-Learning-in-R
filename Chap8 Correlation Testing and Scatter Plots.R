#'Chapter 8 : Correlation Testing and Scatterplots
#'Understanding Correlation
#'Scatter Plots
#'Scatter Plot Matrix
#'Statistical Test for Correlation

#'Correlation
#'It is an indication of how two variables are related to each other
#'Correlation is measured through correlation coefficient
#'There are two aspects in c 
#' (a) the strength of the relationship
#' (b) the direction of the relationship

#'Scatter Plots
#'Let's load the package "car"
#'Visual cues for possible correlation

#'Load Data
load("C:/Users/IIM/OneDrive/07 IIMKa/Coursework/EPGP/2018 DSBA/Session 05-06/Data_Chap0_10.RData")

#'install.packages("car")

library(car)

#'Diamonds Example

data(Diamonds)
colnames(Diamonds)
plot(TotalPrice ~ Carat, data = Diamonds)
scatterplot(TotalPrice ~ Carat, data=Diamonds,xlab="Weight",ylab="Price",main="Price vs Weight")

#'Cars Example

data(mtcars)
scatterplot(mpg ~ hp, data=mtcars, smoother=FALSE, reg.line = FALSE)
scatterplot(mpg ~ hp, data=mtcars, smoother=FALSE)
scatterplot(mpg ~ hp, data=mtcars)
scatterplot(mpg ~ hp|am, data=mtcars,smoother=FALSE, reg.line = FALSE)

#'Scatter Plot Matrix
#'Source: http://www.statmethods.net/graphs/scatterplot.html
#'Explore this link for colourful and 3D Scatter Plots

#'Basic Scatter Plot Matrix
pairs(~mpg+disp+hp+wt,data=mtcars,main="Scatterplot Matrix")

#'Advanced Scatter Plot Matrix
scatterplot.matrix(~mpg+disp+hp+wt,data=mtcars,main="Scatterplot Matrix")

#'Correlation
#'Case I
#'Correlation between Weight and Price of Diamond
#'Caution: Ensure via visualization that relationship is linear

plot(TotalPrice ~ Carat, data = Diamonds)
cor(Diamonds$TotalPrice,Diamonds$Carat)

#'Case II
#'Correlation between mpg and hp
#'Caution: Ensure via visualization that relationship is linear

plot(mpg ~ hp, data = mtcars)
cor(mtcars$mpg,mtcars$hp)

#'Statistical Test of Correlation
#'Caution: Only for relationships that are linear
#'Case I
#'Correlation between Weight and Price of Diamond

cor.test(~TotalPrice + Carat, data = Diamonds)

#'Null Hypothesis : Correlation Coffiecient = 0
#'Alternate Hypothesis : Correlation Coefficient <> 0
#'Calucated p-value < 0.05 
#'Result : Null Hypothesis is rejected, There is correlation between weight and price

#'Case II
#'Correlation between mpg and hp of Car

cor.test(~mpg + hp, data = mtcars)

#'Null Hypothesis : Correlation Coffiecient = 0
#'Alternate Hypothesis : Correlation Coefficient <> 0
#'Calculated p-value < 0.05 
#'Result : Null Hypothesis is rejected, There is correlation between mpg and hp

#'Is there any other indicator of relationship
#'Covariance
#'Case I
#'Covariance between Weight and Price of Diamond

cov(Diamonds$TotalPrice,Diamonds$Carat)

#'So what is relationship between covariance and correlation

cov(Diamonds$TotalPrice,Diamonds$Carat)/(sd(Diamonds$TotalPrice)*sd(Diamonds$Carat))

#'Anythoughts on why correlation is a better indicator of relationship ?
#'Think about the values of correlation and covariance
#'What are the boundaries of a correlation coefficient
#'Answer lies there

#'Case II
#'Covariance between mpg and hp of Diamond

cov(mtcars$mpg,mtcars$hp)

#'So what is relationship between covariance and correlation

cov(mtcars$mpg,mtcars$hp)/(sd(mtcars$mpg)*sd(mtcars$hp))

