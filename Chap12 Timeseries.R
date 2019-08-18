#Time Series Analysis
#Time Series methods are useful in working with data that has a temporal component
#For example forecasting of
    #Air Passenger over years
    #Production of Gold over years
    #Sales Revenue over years
    #Footfalls - consumers, patients, students etc. over years

##############################################################################

#Basics
  
install.packages("rmeta")     #Plotting
install.packages("CADFtest")  #Evaluation
library(rmeta)
library(forecast)
library("CADFtest")

##################################################################################

#Objective

#There are various methods for handling time series
#Time series data exhibit different characteristics in otherwords components
#We shall look at basic decomposition to identify relevant components of time series
#Then we shall use two different methods
    #1. Simple Exponential Method
    #2. Holt's Method
    #3. Winter's Method

########################################################################

#Step 1 : Data Preparation

#Step 1A: Understanding the data
View(footfalls)
class(footfalls)
str(footfalls)

#Step 1B: Coverting data to aid time series analysis
#See what ts command does
data <- ts(footfalls$footfalls)
data
str(data)
class(data)

#Frequency will specify if it is monthly or quarterly
data <- ts(footfalls$footfalls,frequency=12, start=c(2006,1))
data # Do you spot the difference
str(data)

#Plotting
plot(data)

#Step 2 : Getting insights into components of Time Series Data

#Decomposing Time Series Data
#A time series data may contain seasonal and trend components. How we see those.
#Use the decompose function

decompdata <- decompose(data)

#Do you notice - We have to handle missing values
#Let's us understand how to handle missing values
#identify trends and use it to fill in the missing values
data 

#Let the processed data be called "datana"
datana
plot(datana)
decompdata <- decompose(datana)
plot(decompdata)

#Result : We are able to observe two components - Seasonality and Trend
#Let us try to visualize the data without seasonality and trend

#Seasonally adjusted data
plot(datana)
plot(datana - decompdata$seasonal)

#Trend adjusted data
plot(datana - decompdata$trend)

#Seasonality and Trend Adjusted
plot(datana - decompdata$seasonal - decompdata$trend)
plot(datana - decompdata$seasonal - decompdata$trend - decompdata$random)

##################################################################################

#Step 3 : Building Forecasting Models
#Approach 1 : Simple Exponential Model
#Approach 2 : Holt's Model
#Apporach 3 : Winter's Model


#Approach I : Simple Exponential Smoothing

#alpha = TRUE (Need not be specified)
#Level alone considered
modela <- HoltWinters(datana, beta=FALSE, gamma=FALSE)
plot(modela)
modelaforecasts <- forecast(modela,h=12)
#Using parameter h, you can specify the period for which you need forecasts
plot(modelaforecasts)
plot(modelaforecasts$residuals)


#Approach II : Model with Trend - Holt's Model

#alpha and beta = TRUE (Need not be specified)
#Level and Trend considered
modelb <- HoltWinters(datana, gamma=FALSE)
plot(modelb)
modelbforecasts <- forecast(modelb,h=12) 
#h=number of periods of forecasting
plot(modelbforecasts)
plot(modelbforecasts$residuals)


#Approach III : Model with Seaonality and Trend - Winter's Model

#alpha, beta, gamma = TRUE (Need not be specified)
#Level, Trend and Gamma considered
modelc <- HoltWinters(datana)
plot(modelc)
modelcforecasts <- forecast(modelc,h=12)
plot(modelcforecasts)
plot(modelcforecasts$residuals)

#Comparing Results using MAPE value

resulta <- as.data.frame(accuracy(forecast(modela)))[5]
resultb <- as.data.frame(accuracy(forecast(modelb)))[5]
resultc <- as.data.frame(accuracy(forecast(modelc)))[5]

rownames(resulta) <- 'Exponential Model'
rownames(resultb) <- 'Holts Model'
rownames(resultc) <- 'Winters Model'

result  <- rbind.data.frame(resulta,resultb,resultc)
View(result)


