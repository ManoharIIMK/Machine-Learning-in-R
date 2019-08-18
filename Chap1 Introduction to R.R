#Chapter 1 - Introduction to R

#What is R ? Where shall I find it ? How do I install it
#How to use help documentation ?
#How to know more about a command or a function
#What are packages ? Why do we need them ?
#Viewing installed packages
#Loading a package into Library
#What is Workspace ?

####################################################################################

#What is R
#R is a tool for statistical analysis, machine learning and visualization
#It has been around for 40 years now
#It's open source
#It's suppoted by an active community that keep's contributing statistical / ML packages
#We have 4500 plus packages as on date.

####################################################################################

#Where do I find R and How do I install it ?

#http://cran.r-project.org/

#Choose one of the options
#Download R for Linux (or)
#Download R for (Mac) OS X
#Download R for Windows

#Let me choose the option "Download R for Windows"
#It takes me to a new screen#
#Click open the link intall R for the first time
#Then click the link Download R 3.4.0 for Windows (this is the latest version)
#The setup file wil be downloaded into your system
#Just right click run it
#At the end you will notice a shortcut titled "R x64 3.4.0" in your desktop
#That's it...You are ready to use R
#Double click to open "R"
#You will see the R Console through which you can interact with the system

####################################################################################

#R and R-Studio - Why do we need R-Studio ?
#R-Studio is an IDE for R
#Can R-Studio work without R ? No...You need to install R before you install R-Studio

#Where do I find R-Studio ?
#https://www.rstudio.com/products/rstudio/
#Scroll down in the page and click the button "Download RSTUDIO DESKTOP"
#It would lead you to a new page "choose your version of RSTUDIO
#Scroll down and you will have installer files for windows, mac and linux distributions
#Download the appropriate version (based on your OS)
#You will notice the setup file "RStudio-1.0.143.exe" in your downloads folder
#Install it and you will find the shortcut in desktop or RStudio in menu
#Click RStudio to open the IDE
#It will open an IDE as seen your screen now

####################################################################################

#First the Basics
#Staring with the documentation on R
help.start()


#If you wish to know about a function (or command)   
?summary
?sum
?mean
?data.frame

#Note
#search using "?" may not work for all functions
#use Search tab in such cases
#For example use search tab to find more about the function "describeBY"

#Packages installed in R
#Packages get installed at the same time as you install R

installed.packages()

#In case you need a package that is not pre-installed use
install.packages("psych")
#Packages are installed from CRAN repository

#You may also use the tab "install: under the menu "packages"
#to install a package

#Note packages are not loaded into memory by default
#List of Packages loaded into memory
search()

#Loading a package into memory
library(ade4)

#Detaching a package from memory
detach(package:ade4)

#GUI option to install a package into R

#Workspace
getwd()
setwd('E:/IIM/BABD_B3 docs/')  #Sets the working directory to C: Drive

##Exercise
#Search for "library" and identify its package
#Search for "qplot" and identify its package
#Can you spot the difference between "library" and "qplot"

##Some questions to ponder
#Did you install and load the package containing "library"
#We didnot install the package for library - If so how did it work 