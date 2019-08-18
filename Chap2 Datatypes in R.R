#Workspace
getwd()
setwd('E:/IIM/BABD_B3 docs/')  #Sets the working directory to C: Drive
#Chapter 2 - Data Types in R

#Use it as a calculator
#R Variables
#Vectors
#Functions
#Typecasting
#Workspace
#History
#Missing values
#Reference Book : "R for Everyone Advanced Analytics and Graphics"
#Author : "Jared P. Lander"
#ISBN : 978-93-325-3924-2 Pearson Publication

####################################################################

# R Can be used just like a calculator to do basic Mathematics
3 + 9 + 12 -7
(12 + 17/2 -3/4) * 2.5

####################################################################

# R Variables
  # Four  Types of Variables can be defined
  # Numeric
  # Character
  # Date
  # Logical

# Numeric Datatype
answer1 <- 23 + 17/2 + pi/4
sample1 = c(2, 5, 7, 3, 9, 4, 5)
x <- c(1.1,2.2,90.7,60.3) 

# Character Datatype
y <- c("a","b","c")
y1 <- c("R","SPSS")

# Define and assign values to variables
# In the above examples
#"=" and "<-" are interchangeable
# The LHS of the assignment operator is the "variable" or otherise the "object"

class(x)                    #Answeris numeric
x <- c(1:10)
class(x)                    #Answeris integer

class(y) 
class(y1)

#Other variable types in R

#Date and Time

datevariable <- as.Date("2017-06-04")
datevariable
class(datevariable)

timevariable <- as.POSIXct("2017-06-04 19:41 IST")
timevariable1 <- as.POSIXct("2017-07-04 19:41 IST")
difftime(timevariable,timevariable1,units="weeks")

class(timevariable)
timevariable
print(timevariable,sec)

as.POSIXlt(Sys.time(), "GMT")
as.POSIXlt(Sys.time(), "Asia/Calcutta")
as.POSIXlt(Sys.time(), "UTC")

#Logical Datatypes : TRUE and FALSE
#TRUE = 1 FALSE = 0
class(TRUE) 
class(FALSE)

answer1
TRUE*answer1           # any guess ?  [1] 32.2854
FALSE*answer1          # any guess ?  [1] 0

is.numeric(answer1)
is.character(answer1)
is.character(y)
is.numeric(datevariable)

#or simply
2 > 3
2 < 3
######################################################################

#Vectors
#Vectors are a collection of objects#

numericvector1 <- c(1:10)
numericvector2 <- rnorm(10)

#Excercise
#What is the class of numericvector1
#What is the class of numericvector2
class(numericvector1)
class(numericvector2)

charactervector1 <- c("R","Python","SPSS","SAS")
charactervector1
class(charactervector1)

#Vector Operations
numericvector3 <- c(numericvector1,numericvector2) 
numericvector4 <- numericvector1 + numericvector2
numericvector5 <- numericvector1 * numericvector2
numericvector6 <- c(numericvector1,charactervector1,NA)
numericvector4 < 5 #This is a logical operation
#Note combining character and numeric vectors may not be useful

#Learning about a vector
length(numericvector3)
max(numericvector4)
min(numericvector5)
sum(numericvector4)
sort(numericvector6)
sort(numericvector6, decreasing = TRUE)
sort(numericvector6, na.last = TRUE)
sort(numericvector6, na.last = FALSE)
class(numericvector6)

#Data extraction from a vector
numericvector6[1]
numericvector6[1:3]
numericvector6[-3]
numericvector5[numericvector5>3]

#Reading Data from Console
#Ways to input data - From Console
scanvector1 = scan()
scanvector1


#By default the separator 
scanvector2 = scan(sep = ',')
scanvector2

#Try to scan a character

#Ways to input data - From File
getwd()
setwd("E:/IIM/BABD_B3 docs/data")
scanvector3 = scan(file = 'test data.txt')
class(scanvector3)
scanvector4 = scan(file.choose())
class(scanvector4)

#Factor Vectors
gendervector <- c("Male","Female","Male","Female","Male","Female")
gendervector
class(gendervector)
gendervector <- as.factor(gendervector)
class(gendervector)
#How are factors useful
#In statistics we have a data type called "Categorical" data
#R handles Categorical data through factor

######################################################################
#Functions 
# Call in-built functions
sqrt(10)
factorial(10)
abs(12-17*2/3-9)
sum(10,2)
mean(numericvector1)
sd(numericvector2)

#help on functions
?+?
?sum
?mea #Find objects by partial name
apropos("mea")

######################################################################
#Workspace

#What is a workspace#
#It is a collection of R objects#

#List of objects in workspace
ls()

#Removing objects from workspace
rm(answer1,sample1)

getwd()
setwd('E:/IIM/BABD_B3 docs/data/Files1')
getwd()
setwd('E:/IIM/BABD_B3 docs/data/Files')
getwd()

#saving workspace
save.image("E:/IIM/BABD_B3 docs/data/Files/Workspace.RData")

#Loading workspace
load("E:/IIM/BABD_B3 docs/data/Files/workspace.RData")
######################################################################
#Typecasting
monthvectorc <- c("Jan","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep",
                 "Aug","Oct","Feb","Dec","Nov","Apr","May","Jan")
class(monthvectorc)
str(monthvectorc)

monthvectorf <- as.factor(monthvectorc)
class(monthvectorf)
str(monthvectorf)

monthvectorn <- as.numeric(monthvectorc)
class(monthvectorn)
monthvectorn
#character vector cannot be coerced to numeric

monthvectorn <- as.numeric(monthvectorf)
class(monthvectorn)
monthvectorn

######################################################################
#Knowing your objects
class(x)
class(numericvector1)
class(charactervector1)
class(charactervector1)
######################################################################

#History
history()
history(max.show = 25)

######################################################################
#Missing Values
numericvector7 <- c(1,2,3,NA,5,NA,7)
class(numericvector7)
length(numericvector7)
is.na(numericvector7)
mean(numericvector7)
mean(numericvector7, na.rm=TRUE)
length(which(is.na(numericvector7)==TRUE))

numericvector8 <- c(1,2,3,5,5,NULL,7)
numericvector8
length(numericvector8)
is.na(numericvector8)
mean(numericvector8)

#NA means missing#
#NULL means nothing#

#####################################################################


