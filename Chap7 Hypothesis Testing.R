#Chapter 7 : Hypothesis Testing

#Tests Covered

#t-tests (double sided)
#t-tests (single sided)
#t-tests (test of means for a hypothesized value)
#Wilcox Tests
#Chi-Square
#Anova 
#Tukey Tests
#Comparing Different models in Anova

#Input Data for Hypothesis Testing
#Used the data fram hypothesis_testing for this purpose

View(hypothesis_testing)

#Data Cleaning and Preparation
hypothesis_testing <- as.data.frame(hypothesis_testing)
hypothesis_testing$Degree <- as.factor(hypothesis_testing$Degree)
hypothesis_testing$Experience <- as.factor(hypothesis_testing$Experience)
hypothesis_testing$Promoted <- as.factor(hypothesis_testing$Promoted)
hypothesis_testing$Salary <- as.numeric(hypothesis_testing$Salary)

#Undestanding the data
#Identify the groups and the measures
#Groups - Based of Degree (UG and PG)
#Groups - Based on Experience (< 3 Years and > 3 Years)
#Measure - Salary is a measure
#Promoted - A measure indicating if someone was promoted or not

#t.tests

#Case I - Test of means between two groups(samples) - Double Sided
#Does salary vary by Degree
#Measure = Salary, Group = Degree
#Null Hypothesis : Salary doenot vary based on Degree
t.test(Salary~Degree,data=hypothesis_testing)
#p-value ~ 0.00 [< 0.05]
#Result : Reject Null Hypothesis
#Inference : Salary varies by Degree

#Case II - Test of means between two groups - Single Sided
#Is Salary of PG Degree Holders > Salary of UG Degree Holders
#Measure = Salary, Group = Degree
#Null Hypothesis : Salary of PG Degree Holders is not greater than UG Degree Holders
t.test(Salary~Degree,alternative  = "greater", data=hypothesis_testing)
#p-value ~ 0.00 [< 0.05]
#Result : Reject Null Hypothesis
#Inference : Salary of PG Degree Holder is greater than UG Degree Holders

#Case III - Test of means against a hypothesized value
#Salary of PG and UG Degree Holders vary by more than 1000
#Measure = Salary, Group = Degree
#Null Hypothesis : PG degree holder salary is not higher than UG holder by atleast 1000
t.test(Salary~Degree, mu=1000, alternative = "greater", data=hypothesis_testing)
#p-value ~ 0.00 [< 0.05]
#Result : Reject Null Hypothesis
#Inference : Salary of PG holders is higher by atleast 1000

#Case IV - Test of means against a hypothesized value
#Salary of PG and UG Degree Holders vary by more than 2000
#Measure = Salary, Group = Degree
#Null Hypothesis : PG degree holder salary is not higher than UG holder by atleast 2000
t.test(Salary~Degree, mu=2000, alternative = "greater", data=hypothesis_testing)
#p-value = 0.9565 [> 0.05]
#Result : Donot Reject Null Hypothesis
#Inference : Salary is not higher by atleast 2000

#Case V - Test of means against a hypothesized value - Across all groups
t.test(hypothesis_testing$Salary, data=hypothesis_testing, mu=12000, alternative="greater")
#p-value ~ 0 [<0.05] 
#Inference : Salary is greater than 12000
t.test(hypothesis_testing$Salary, data=hypothesis_testing, mu=13000, alternative="greater")
#p-value ~ 0.7778 [>0.05] 
#Inference : Salary is not greater than 13000

#Case VI - Non Normal Data
#Wilcox Test
#Does salary vary by Degree
#Measure = Salary, Group = Degree
#Null Hypothesis : Salary doenot vary based on Degree
wilcox.test(Salary~Degree,data=hypothesis_testing)
#p-value ~ 0.00 [< 0.05]
#Result : Reject Null Hypothesis
#Inference : Salary of PG Degree Holder is greater than UG Degree Holders

#Case VI - Non-parametric tests
#Chi-Square Test
#Frequency type values (Those which are counted and rather measured)
#Let us take the grounds and wins Example
#Is there is relation ship between grounds and wins
#Test the hypothesis that wins by a country is independent of the ground
View(groundswinsmatrix)
groundswins.cs = chisq.test(groundswinsmatrix)
groundswins.cs
#p-value ~ 0.07 [< 0.05]
#Result : Accept Null Hypothesis
#Inference : wins by contries is independent of grounds

#For the next three tests we shall use casedata
#Data Cleaning and Preparation
casedata$Productgroup <- as.factor(casedata$Productgroup)
casedata$Product <- as.factor(casedata$Product)
casedata$MeasurementPeriod <- as.factor(casedata$MeasurementPeriod)
View(casedata)
str(casedata)

#Case VII - More than three groups
#Anova
#So fare you have working with two groups...What if there are more than two groups
#Null Hypothsis : there is no difference between Look to Clickrates across product groups
fit1 <- aov(Looktoclickrate ~ Productgroup, data=casedata)
summary(fit1)
#p-value ~ 0.00 [< 0.05]
#Result : Reject Null Hypothesis
#Inference : Looktoclickrate differs across product groups

#Case VIII
#Tukey Tests
TukeyHSD(fit1)
model.tables(fit1, type = 'effects')
model.tables(fit1, type = 'means')

#Case IX
#Comparing different models
fit2 <- aov(Looktoclickrate ~ Productgroup + MeasurementPeriod ,data=casedata)
summary(fit2)
anova(fit1,fit2)
#Seems model Fit2 is better - You can notice this from residuals as well

