#Workspace
getwd()
setwd('E:/IIM/BABD_B3 docs/')  #Sets the working directory to C: Drive

#Chapter 3 Datastructures in R

#Type of Data Structures
#Vectors - We already covered it in chapter 2
#Lists
#Data Frames
#Matrices
#Typecasting Data Structures

######################################################################
#Lists                                                               #
#Lists are datastructures that are meant for holding  objects of     #
#similar or different data types.                                    #
#For example a list can hold two vectors                             #
#It may also hold a list and a dataframe                             #
######################################################################
numericvector1 <- c(1:10)
numericvector2 <- rnorm(10)

list1 <-list(numericvector1,numericvector2)
#list1 contains two elements
#First element is a numeric vector named numericvector1
#Second element is a numeric vector named numericvector2

charactervector1 <- c("R","Python","SPSS","SAS")
list2 <-list(numericvector1,charactervector1)
#list2 contains two elements
#First element is a numeric vector named numericvector1
#Second element is a character vector named charactervector1

#Lets add a dataframe named dataframe1 to list3
#Lets create a dataframe
program <- c("PGP","EPGP","FPM","EFPM","PGP","EPGP","FPM","EFPM")
institute <- c("IIMKa","IIMKa","IIMKa","IIMKa","IIMT","IIMT","IIMT","IIMT")
students <-c(180,60,20,30,200,50,30,15)
dataframe1 <- data.frame(institute,program,students)

#dataframe1 is an existing dataframe
list3 <- list(numericvector1,charactervector1,dataframe1)
#list3 contains three elements
#First element is a numeric vector named numericvector1
#Second element is a character vector named charactervector1
#Third element is a dataframe named dataframe1

#naming elements of a list
list3 <- list(element1 = numericvector1, element2 = charactervector1, element3 = dataframe1)
names(list3)

#Accessing elements of a list

#By index
list3[[1]]
list3[[2]]

#By name
list3[["element1"]]
list3[["element2"]]

#Accessing specific columns
list3[["element3"]]$institute #Method1#
list3[["element3"]][,"institute",drop=FALSE] #Method2#

#Did you notice the difference in above two Methods - Method1 and Method2#
#See the output again#
class(list3[["element3"]][,"institute"])
class(list3[["element3"]][,"institute",drop=FALSE])

#length of a list
length(list3)
length(list3[["element3"]])
length((list3)[["element3"]][,"institute"])
#############################################################################

#Dataframes
#What is a dataframe ?
#Data frame is perhaps the most useful object in R
#In terms of data processing its similar to Excel
#In terms of statistics, its is equivalents to a table with rows and columns
#Each column of the dataframe may hold different types of data
#However, withing a column data must be similar

#Creating a dataframe
program <- c("PGP","EPGP","FPM","EFPM","PGP","EPGP","FPM","EFPM")
institute <- c("IIMKa","IIMKa","IIMKa","IIMKa","IIMT","IIMT","IIMT","IIMT")
students <-c(180,60,20,30,200,50,30,15)
dataframe2 <- data.frame(institute,program,students)

#Knowing your dataframe
class(dataframe2)
View(dataframe2)
str(dataframe2)
head(dataframe2)
tail(dataframe2)


#Number of columns and rows and their names
nrow(dataframe2)
ncol(dataframe2)
colnames(dataframe2)
rownames(dataframe2)
dimnames(dataframe2)

#Renaming columns of a dataframe
names(dataframe2) <- (c("Institute","Program","Students"))

#Operations in a Dataframe
dataframe2[3,3]
dataframe2[1:4,]
dataframe2[3,2:3]
dataframe2[,'Students']
dataframe2[3]

#Subset operations in a dataframe
#Extract Programs where enrollment is > 30 into a new dataframe
dataframe3 <- subset(dataframe2,Students > 30)
#Extract Programs where enrollment is > 30 and Program is PGP or EPGP)
dataframe3 <- subset(dataframe2,Students > 60 & (Program == "PGP" | Program =="EPGP"))

#############################################################################

#Reading into Dataframes
getwd()
setwd('E:/IIM/BABD_B3 docs/data')

#reading a .csv file using read.csv
#use file casedata.csv
dataframe4 <- read.csv(file.choose())   #use file casedata.csv
View(dataframe4)

dataframe5 <- read.csv(file.choose(), header=FALSE)
#use file casedata.csv
#Useful when data has no header
#If it has header - the header will be treated as a row
View(dataframe5)

#reading a .txt file specifying header
#choose file table.text
dataframe6 <- read.table(file.choose(), header=TRUE, sep = '\t')
View(dataframe6)

#reading into dataframe
#instead of file.choose(), you can specify the file name as well
dataframe7 <- read.csv(file = 'casedata.csv', header=TRUE, sep=",")
View(dataframe7)

#reading into dataframe
#read.table can be used instead of read.csv
dataframe8 <- read.table(file = 'casedata.csv', header=TRUE, sep=",")
View(dataframe8)
  
#GUI method to read into dataframes


#############################################################################
#Matrices#
#Unlike a dataframe, all columns of a matrix hold similar type of data
#Its commonly used in statistics

#Lets create a 5*5 matrix
#The matrix has 5 rows and 5 columns

getwd()
setwd('E:/IIM/BABD_B3 docs/data') #Set your working directory

#Before running the next command place the file "grounds and wins.txt" in your working directory                                 

temptable <- read.table(file='grounds and wins.txt', header=FALSE) 
class(temptable)
View(temptable)
colnames(temptable) <- c('EDENGARDEN','GREENPARK','CHEPAUK','LORDS','MCG')
rownames(temptable) <- c('INDIA','AUSTRALIA','ENGLAND','SRILANKA','WESTINDIES')
groundswinsmatrix <- as.matrix(temptable)

#knowing your matirx
class(groundswinsmatrix)
View(groundswinsmatrix)
colnames(groundswinsmatrix)
rownames(groundswinsmatrix)
dimnames(groundswinsmatrix)

#Extracting elements of a matrix
groundswinsmatrix
groundswinsmatrix[1,]
groundswinsmatrix[1:3,]
groundswinsmatrix[,1]
groundswinsmatrix[2:4,1:3]
groundswinsmatrix[c('INDIA','AUSTRALIA'),]
groundswinsmatrix[,c('EDENGARDEN','CHEPAUK')]


#############################################################################
#Typecasting between dataframes and matrices
#Matrix to Dataframe
class(groundswinsmatrix)
mat2frame = as.data.frame(groundswinsmatrix)
mat2frame
class(mat2frame)

#Dataframe to Matrix
frame2mat = as.matrix(mat2frame)
class(frame2mat)
#############################################################################

