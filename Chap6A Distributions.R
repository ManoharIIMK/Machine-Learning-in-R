
#.........................................................................#

#Normal Distribution

#Parameters of normal distribution are mean and sd

#Function to generate random numbers of specifed mean and sd

#rnorm(n,mean,sd)
rnorm(100,5,1)

#Function that gives the density (Probability) of x in a normal distribution
#dnorm(x,mean,sd)
dnorm(5,5,1)

#Function that gives the cumulative density from a normal distribution
#pnrom(x,mean,sd)
pnorm(5,5,1)


#.........................................................................#


#uniform Distribution

#Function to generate random numbers of specifed min and max
#runif(n,min, max)
runif(100,0,9)

#Function that gives the (Probability) of x in a uniform distribution
#dunif(x,min, max)
dunif(4.5,0,9)

#Function that gives the cumulative density of a uniform distribution
#punif(x,mean,sd)
punif(4.5,0,9)

#.........................................................................#

#Poisson Distribution

#Unlike normal or uniform, its a discrete event distribution

#Paramtersx of the Poisson Distribution is lambda
#lambda = average event rate

#Function that generate random numbers from poisson distribution
#rpois(n,lambda)
rpois(100,1)

#Function that gives the density (Probability) of x from a poisson distribution
#dpois(x,lambda)
dpois(0,1)

#Function that gives the cumulative density of a poisson distribution
#punif(x,lambda)
ppois(1,1)

#.........................................................................#

#Binomial Distribution

#Unlike normal or uniform, its a discrete event distribution

#Paramters of the Binomial Distribution are n and p
#n is the number of events and p is the probability of success
#there can be two outcomes for an event - success/failure, yes/no etc.

#Function that generate random numbers from binomial distribution
#rbinom(n,size, prob)
rbinom(100,1,0.5)
#Above is equivalent of generating 100 outcomes with two possibilities 

#Function that gives the density (Probability) of x from a binomial distribution
#dbinom(x,size,prob)
#x is the number of successes
#size is the number of outcomes 

#This is equivalent of getting one head out of 1 toss in a fair coin
dbinom(1,1,0.5)

#This is equivalent of getting exactly three heads out of 6 tosses in a fair coin
dbinom(3,6,0.5)

#Function that gives the cumulative density of x from a binomial distribution
#pbinom(x,size,prob)

#Equivalent of getting upto 11 correct answers in a set of 30 with a probability
#of success of 0.25 per question, if you answer randomly
pbinom(11,30,0.25)
pbinom(50,100,0.5)

#Equivalent of getting upto 3 heads in 6 tosses in a fair coin
pbinom(3,6,0.5)

#.........................................................................#




