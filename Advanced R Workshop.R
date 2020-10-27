## ADVANCED R WORKSHOP ##

setwd("~/Desktop/Stats/Intro_R_Sep_8")
getwd()
car <- read.csv("car_dataset.csv", stringsAsFactors = F)

head(car)
str(car)

nrow(car)
ncol(car)
names(car)

test <- car[,(ncol(car)-4):ncol(car)]

#LOAD CSV FILE#
write.csv(test,"test.csv", row.names = F) #Doesn't Save Index#
write.table(test,"test.csv", row.names = F, sep = '|') #Pipe Separated Needs a Different Function for |#

test_new <- read.table("test.csv", header = T, sep = '|', stringsAsFactors = F) #????

help(read.table)

#INSTALL EXCEL#
install.packages("readx1")
library(readxl)

excel_sheets("car_dataset_excel.xlsx") #Shows Multiple Sheet Names#

car_excel <- read_excel("car_dataset_excel.xlsx", sheet = "car_dataset_5_10")

#DPLYR#

install.packages("hflights")
library(hflights)
head(hflights)

install.packages("dplyr")
library(dplyr)

dim(hflights)

# Select #


flights <- select(hflights, ActualElapsedTime, AirTime, ArrDelay, DepDelay) #no need to quotes in dplyr#
#hflights%>%select(ActualElapsedTime, AirTime, ArrDelay, DepDelay)%>%filter()# #easy filter from dataset#

flights2 <- select(hflights, Origin:Cancelled, -TaxiIn) #another way to select columns# 
head(flights2)

flights3 <- select(hflights, contains("Delay"))

flights4 <- select(hflights, starts_with("Taxi")) #OR ends_with#
head(flights4)

flights5 <- select(hflights, one_of(c("UniqueCarrier", "FlightNum", 
                                      "TailNum", "Cancelled", "CancellationCode")))
head(flights5)

# Filter First Before Select #

flights6 <- filter(hflights, Distance >= 3000 & DayOfWeek == 4)
head(flights6)

flights <- filter(hflights, UniqueCarrier %in% c("EV", "UA", "XE"))

flights <- hflights%>%filter(TaxiIn + TaxiOut > AirTime)%>%select(Year,Month)
head(flights)

# Mutate #

flights <- hflights%>%mutate(TotalTaxi = TaxiIn + TaxiOut) # doesn't save column TotalTaxi #
flights <- hflights%>%mutate(TotalTaxi = TaxiIn + TaxiOut)%>%filter(TotalTaxi > ArrTime)
head(flights)

# arrange (sort) # 
dtc <- filter(hflights, Cancelled == 1, !is.na(DepDelay))
test1 <- arrange(dtc, DepDelay)
head(test1)

test1 <- arrange(dtc, DepDelay, desc(DayOfWeek))

# summarize #

summarize(hflights, min_dist = min(Distance), max_dist = max(Distance))

mean(hflights$TaxiIn, na.rm = T)

count(hflights, Cancelled == 1)

flights <- hflights%>%group_by(UniqueCarrier)%>%
  summarize(tt=n())%>%filter(tt > 10000)
head(flights)

# GGPLOT #

install.packages("ggplot2")
library(ggplot2)

library(MASS)

remove.packages("dplyr")

plot(mammals$body, mammals$brain)

mammals$body[mammals$body > 500] <- median(mammals$body)
mammals$brain[mammals$brain > 1000] <- median(mammals$brain)

#Structure:#
#ggplot(data, aes(x,y)) + type of plot#

head(mammals)

# Scatterplot w Regression Line w/out CI#
ggplot(mammals, aes(body, brain)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)

mtcars$cyl <- as.factor(mtcars$cyl)

ggplot(mtcars, aes(mpg, wt, col = cyl)) + 
  geom_point() + 
  geom_smooth(method = 'lm') + facet_grid(am ~ gear)

ggplot(mtcars, aes(cyl)) + geom_bar()

# Bar Chart #
mtcars$am <- as.factor(mtcars$am)

# Stacked Bar #
ggplot(mtcars, aes(cyl, fill = am)) + geom_bar()

# Side by Side Bar #
ggplot(mtcars, aes(cyl, fill = am)) + geom_bar(position = "dodge") 
#or position fill for percentage#

ggplot(mtcars, aes(am, mpg, fill = am)) + geom_boxplot()

ggplot(mtcars, aes(wt)) + geom_histogram() + facet_grid(. ~ am)


setwd("~/Desktop/Stats/Intro_R_Sep_8")
cleaned_loan <- read.csv("cleaned_loan.csv", stringsAsFactors = F)

colnames(cleaned_loan)

ggplot(cleaned_loan, aes(loan_amnt)) + geom_histogram()

summary(cleaned_loan$loan_amnt)

ggplot(cleaned_loan, aes(loan_amnt, int_rate)) + geom_point() + geom_smooth(method = 'lm')

ggplot(cleaned_loan, aes(status_2, loan_amnt, fill = status_2)) + geom_boxplot()




























