#Chapter 6 - Distributions

#Many inferential statistical testing methods require that data is normally distributed

#Basics about Statistical Testing
#We always have a null hypothesis and alternate hypothesis
#Statistical tests will allow us to accept or reject a null hypothesis
#Statistical tests provide us with a p-value.
#The smaller the p-value, there is strong evidence in favour of alternate hypothesis
#calculate p-value is the probability (its an indicator of being wrong about alternate hypothesis)
#It is the probability that the observed phenomenon is occuring only by chance.
#The p-value is compared against a chosen significance level
#Significance level is arbitrary (decided by the researcher)...but is usually 0.05 or lower
#If the p-value is less than the chosen significance level, we reject null hypothesis
#If the p-value is greater than the chosen significance level, we do not reject null hypothesis

#Statistical Tests for Distributions

#Create some known datasets for testing distributions
#Let's create one with uniform distribution and other with

#Normal Distribution

#Creating Datasets
set.seed(pi)
testunifdata <- runif(1000,min=4.9,max=5.1)
testnormdata <- rnorm(1000,mean=5,sd=0.1)

#Verifying Graphically
#Let's try density plots
plot(density(testunifdata)) #Seem uniform from graph...Good
plot(density(testnormdata)) #Seem normal from graph...Good

#Let's try histograms (though its strictly for discrete data)
hist(testunifdata) #Seem uniform from graph...Good
hist(testnormdata) #Seem normal from graph...Good

#QQPlot
qqnorm(testunifdata)  #S-Shaped curve is an indicator of uniform distribution
qqnorm(testnormdata)  #Line along the is an indicator of normal distribution
#along the diagonal - Indicative of normal Distribution)


#Now let us do the statistical tests
#Test No 1 : Shapiro Test

#Shapiro Test 
#Null Hypothesis : testnormdata is normal
shapiro.test(testnormdata)
#p-value = 0.3911 [>0.05]
#Inference : Not enough evidence to reject null hypothesis 
#Inference : testnormdata is normal
#Go Back to Diamond Data
#Let us check if Total Price is Normal
shapiro.test(Diamonds$PricePerCt)
#p-value ~ 0
#Inference : ???
#Inference : ???

#Null Hypothesis : testunifdata is normal
shapiro.test(testunifdata)
#p-value ~0.0000 [< 0.05] 
#Result : Enough evidence Reject null hypothesis 
#Inference : testunifdata is not normal

#KS Test
#Null Hypothesis : No difference between testnormdata data and a normal distribution with mean=5 and sd=0.1
ks.test(testnormdata,'pnorm',mean=5,sd=0.1)
#p-value = 0.5865 [> 0.05]
#Inference : Not enough evidence to reject null hypothesis 
#Inference : testnormdata is normal with mean=5 and sd=0.1

#Null Hypothesis : No difference between testunifdata data and normal distribution
ks.test(testunifdata,'pnorm',mean=5,sd=0.1)
#p-value ~0.0000 [< 0.05] 
#Result : Enough evidence Reject null hypothesis 
#Inference : testunifdata is not normal 

#Exercise
# (1) Execute ks test to check whether the data set "testunifdata" is uniform
# (2) Execute ks test to check whether the date set "testnormdata" 
#     is normal with mean=10 and sd = 5



















































































