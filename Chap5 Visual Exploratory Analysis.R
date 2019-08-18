#Chapter 5 - Visual Exploratory Analysis
#Chapter 5 : Visual Exploratory Analysis 
#Methods to visualize data
#Methods to visualize distributions 

#Plots
#Stem Plots
#Histograms
#Box Plots
#Density Plots

#We shalluse the dataset Diamonds

#Stem Plots
sort(Diamonds$PricePerCt)
stem(Diamonds$PricePerCt,scale=0.5)
#How do you interpret it ?
#Compare with Sorted list of Diamonds$PricePerCt
sort(Diamonds$PricePerCt)
#Scale helps you to control the resolution 
stem(Diamonds$PricePerCt,scale=0.5)

#Histograms
#Used to generate Frequency Distribution of data
#X-Axis provides bins
#Y-Axis provides frequency count

hist(Diamonds$TotalPrice)
hist(Diamonds$PricePerCt)
#Note in histograms the width of the intervals should remain identical
hist(Diamonds$PricePerCt,breaks=10,col='blue')

#Formatting the chart with colours
hist(Diamonds$TotalPrice, col='gray75', main='Histogram', xlab = 'Price Range')
hist(Diamonds$TotalPrice, col='purple', main='Histogram', xlab = 'Price Range')
colours()
#Try Histograms on PricePerCt

#BoxPlot
boxplot(Diamonds$TotalPrice)
boxplot(Diamonds$TotalPrice, Diamonds$PricePerCt, names = c('Price', 'CaratRate'), range = 0, xlab = 'Feature', ylab = 'USD', col = 'yellow')

#BoxPlot by Category
boxplot(Diamonds$PricePerCt~Diamonds$Color, range=1.5,xlab = 'Feature', ylab = 'USD',main="Price by Color")
boxplot(Diamonds$PricePerCt~Diamonds$Color, range=1.5,xlab = 'Feature', ylab = 'USD',main="Price by Color", col=(c("skyblue","blue","red","yellow","purple","green","rosybrown")) )
colors()

#Density Plots
plot(density(Diamonds$TotalPrice), main="Density Plot")
plot(density(Diamonds$PricePerCt), main="Density Plot")

#QQPlot
qqnorm(Diamonds$TotalPrice)  
qqnorm(Diamonds$PricePerCt) 
#along the diagonal - Indicative of normal Distribution

