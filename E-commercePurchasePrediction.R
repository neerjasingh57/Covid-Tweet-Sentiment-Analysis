
setwd("/Users/neerjasingh/Desktop")
#test <- read.csv("test_forclass.csv", header = T)#
finaltrain <- read.csv("final.csv", header = T)

localtime <- read.csv("localtime.csv", header = T)

test <- read.csv("test_forclass.csv", header = T)

linear <- read.csv("linear.csv", header = T)

test3 <- read.csv("Test_3.csv", header = T)

test3 <- read.csv("Test_3.csv", colClasses =  c(fullVisitorId='character'), header = TRUE)

#separating characters within columns
install.packages("dplyr")
library(dplyr)

#deleting quotation marks
library(stringr)
library(plyr)

del <- colwise(function(test) str_replace_all(test, '\"', ""))
test <- del(test)

#how to remove brackets?

#DIVIDING TOTALS COLUMN
library(dplyr)
install.packages("readr")
library(readr)

#creating vector of all totals values
totals <- x[,"visits"]
#Each value with "bounces"
bouncesvector <- grep("bounces", totals)
#Creating dataframe of bounces (and newVisits)
bouncesdata <- x[bouncesvector,]

#just bounces data
bouncesdata <- bouncesdata[-bounces_newvisitsvector,]
write_csv(bouncesdata, path = "bouncesdata.csv")

#X dataframe without bounces (and newVisits)
newx <- x[-bouncesvector,]

#data of bounces AND newVisits
totalsbouncesdata <- bouncesdata[,"visits"]
bounces_newvisitsvector <- grep("newVisits", totalsbouncesdata)
bounces_newvisitsdata <- bouncesdata[bounces_newvisitsvector,]
write_csv(bounces_newvisitsdata, path = "bounces_newvisitsdata.csv")

#transactionRevenue (and newVisits)
transaction <- newx[,"visits"]
transactionvector <- grep("transactionRevenue", transaction)
transactiondata <- newx[transactionvector,]
write_csv(transactiondata, path = "transactiondata.csv")

#transactionRevenue AND newVisits
totalstransactiondata <- transactiondata[,"visits"]
transaction_newvisitsvector <- grep("newVisits", totalstransactiondata)
transaction_newvisitsdata <- transactiondata[transaction_newvisitsvector,]
write_csv(transaction_newvisitsdata, path = "transaction_newvisitsdata.csv")

transactiondata <- transactiondata[-transaction_newvisitsvector,]
write_csv(transactiondata, path = "transactiondata.csv")

#First dataframe without bounces/newvisits and transactionRevenue/newvisits
newx2 <- newx[-transactionvector,]

newvisits <- newx2[,"visits"]
newvisitsvector <- grep("newVisits", newvisits)
newvisitsdata <- newx2[newvisitsvector,]
write_csv(newvisitsdata, path = "newvisitsdata.csv")

newx3 <- newx2[-newvisitsvector,]
write_csv(newx3, path = "pagevisitsdata.csv")


#REMEMBER CSVS DONT SAVE IN THE FINAL FORMAT
bounces_newvisitscsv <- read.csv("bounces_newvisitsdata.csv", header = T)
transaction_newvisitscsv <- read.csv("transaction_newvisitsdata.csv", header = T)
bouncescsv <- read.csv("bouncesdata.csv", header = T)
transactioncsv <- read.csv("transactiondata.csv", header = T)
newvisitscsv <- read.csv("newvisitsdata.csv", header = T)
pagevisitscsv <- read.csv("pagevisitsdata.csv", header = T)

rm(final)

final2 <- rbind(bounces_newvisitscsv, transaction_newvisitscsv)
write_csv(test, path = "testnew.csv")

final <- rbind(bounces_newvisitscsv, transaction_newvisitscsv)
final <- rbind(final, bouncescsv)
final <- rbind(final, transactioncsv)
final <- rbind(final, newvisitscsv)
final <- rbind(final, pagevisitscsv)

write_csv(final, path = "ALP.csv")

is.factor(trafficSource)
ALP$trafficsource <- as.factor(ALP$trafficSource)

is.factor(ALP$trafficSource)

install.packages("dplyr")
library(dplyr)

distinct(ALP, trafficSource)

#referralPath
trafficSource <- ALP[,"trafficSource"]
referralPathvector <- grep("referralPath", trafficSource)
referralPathdata <- ALP[referralPathvector,]
write_csv(referralPathdata, path = "referralPath.csv")

#keyword
ALP2 <- ALP[-referralPathvector,]
trafficSource2 <- ALP2[,"trafficSource"]
keywordvector <- grep("keyword", trafficSource2)
keyworddata <- ALP2[keywordvector,]

#keyword and adcontent
ALP3 <- ALP2[-keywordvector,]
trafficSource3 <- keyworddata[,"trafficSource"]
adcontentvector <- grep("adContent", trafficSource3)
adContentdata <- keyworddata[adcontentvector,]
write_csv(adContentdata, path = "adContent.csv")

#keyword and adwordsClickInfo
keyworddata2 <- keyworddata[-adcontentvector,]
trafficSource4 <- keyworddata2[,"trafficSource"]
adwordsClickInfovector <- grep("adwordsClickInfo", trafficSource4)
keyword_adwordsClickInfodata <- keyworddata2[adwordsClickInfovector,]
write_csv(keyword_adwordsClickInfodata, path = "keyword_adwordsClickInfo.csv")

#adwordsClickInfo(Without keyword)
trafficSource5 <- ALP3[,"trafficSource"]
isTrueDirectvector <- grep("isTrueDirect", trafficSource5)
isTrueDirectdata <- ALP3[isTrueDirectvector,]
write_csv(isTrueDirectdata, path = "isTrueDirect.csv")

last <- ALP3[-isTrueDirectvector,]
write_csv(last, path = "last.csv")

install.packages("anytime")
library("anytime")

distinct(newtrain, deviceCategory)
distinct(tronly, source)

small <- finaltrain[1:10000,]

localtime$logtransaction <- log(localtime$transactionRevenue + 1)

#Assumptions: Linear relationship b/t each DV and IV, all IVs are normally distributed,
#no multicollinearity (IVs too highly correlated with each other) - confirmed by VIF > 5 - 
# can be centered, homoscedasticity

plot(finaltrain$logtransaction, finaltrain$hits, xlab = "logtransaction", ylab = "hits")

install.packages("car")
library(car)

vif(model)

install.packages("ggplot2")
library(ggplot2)

linear <- ggplot(finaltrain, aes(logtransaction, browser)) + 
  geom_point(aes(shape = factor(browser)),alpha= 1/20) + 
  scale_x_continuous(name = "hits", limits=c(15, 25)) + 
  scale_y_continuous(name="logtransaction", limits=c(0, 200))

linear

localtime$isrevenue <- ifelse(localtime$transactionRevenue !=0, 1, 0)
tronly <- subset(localtime, transactionRevenue!=0)
nobounce <- subset(localtime, bounces == 0)

###MODEL###
model <- lm(log(transactionRevenue + 1) ~ newVisits + visitNumber + pageviews + hits + hitsppv 
            + visitNumber2 + pageviews2 + hits2 + hitsppv2 + pageviews3 + hits3 
            + factor(channelGrouping) + factor(operatingSystem) + weekend + factor(quarter) 
            + subContinent + factor(localhours2) + isUSA + isChrome + hitsppv*visitNumber 
            + isReferral*visitNumber + isChrome*visitNumber + isUSA*pageviews + isUSA*hitsppv, tronly)

summary(model)

##Streamlined Model##
linearmodel <- lm(log(transactionRevenue + 1) ~ newVisits + visitNumber + pageviews
             + hits + hitspage+ visitNumber2 + pageviews2 + hits2 + hitspage2 + pageviews3
             + hits3 + factor(channelGrouping) + factor(operatingSystem) + factor(weekday) 
             + factor(quarter) + subContinent + factor(localhours2) + isUSA + isChrome 
             + hitspage*visitNumber + isReferral*visitNumber + isChrome*visitNumber 
             + isUSA*pageviews + isUSA*hitspage, data=linear)

summary(linearmodel)

linear$trlog <- log(linear$transactionRevenue + 1)

distinct(linear, channelGrouping)

newvisitsplot <- plot(tronly$visitNumber, tronly$logRevenue, xlab = "visitNumber", 
                      ylab = "Revenue")

linear <- ggplot(tronly, aes(logtransaction, visitNumber)) + 
  geom_point(aes(shape = factor(browser)),alpha= 1/20) + 
  scale_x_continuous(name = "hits", limits=c(15, 25)) + 
  scale_y_continuous(name="logtransaction", limits=c(0, 200))

tronly$visitNumber2 <- tronly$visitNumber**2
tronly$pageviews2 <- tronly$pageviews**2
tronly$hits2 <- tronly$hits**2
tronly$hitsppv2 <- tronly$hitsppv**2

tronly$visitNumber3 <- tronly$visitNumber**3
tronly$pageviews3 <- tronly$pageviews**3
tronly$hits3 <- tronly$hits**3
tronly$hitsppv3 <- tronly$hitsppv**3

tronly$visitNumber4 <- tronly$visitNumber**4
tronly$pageviews4 <- tronly$pageviews**4
tronly$hits4 <- tronly$hits**4
tronly$hitsppv4 <- tronly$hitsppv**4

tronly$visitNumber5 <- tronly$visitNumber**5
tronly$pageviews5 <- tronly$pageviews**5
tronly$hits5 <- tronly$hits**5
tronly$hitsppv5 <- tronly$hitsppv**5

tronly$hitsppv6 <- tronly$hitsppv**6

#Does it make sense to include regular hits and pageviews variable with hitsppv variable (combined)?

tronly$logRevenue <- log(tronly$transactionRevenue + 1)

qqnorm(tronly$logRevenue)
qqline(tronly$logRevenue)

#Separate Variable for Channel Grouping - Organic Search?

tronly$isOrganicSearch <- ifelse(tronly$channelGrouping == "Organic Search", 1, 0)
tronly$isDisplay <- ifelse(tronly$channelGrouping == "Display", 1, 0)
tronly$isReferral <- ifelse(tronly$channelGrouping == "Referral", 1, 0)
tronly$isDirect <- ifelse(tronly$channelGrouping == "Direct", 1, 0)

tronly$isChrome <- ifelse(tronly$browser == "Chrome", 1, 0)
tronly$isDesktop <- ifelse(tronly$deviceCategory == " desktop", 1, 0)

tronly$isUSA <- ifelse(tronly$country == " United States", 1, 0)

tronly$quarter3 <- ifelse(tronly$quarter == "3", 1, 0)

summary(tronly$isDesktop)

summary(tronly$operatingSystem)

#hits per pageview variable
tronly$hitsppv <- tronly$hits/tronly$pageviews

install.packages("car")
library(car)

vif(lm(logRevenue ~ isChrome + isDesktop, data = tronly))

tronly$localhours <- gsub("[^[:digit:]]", "", tronly$localtime)
tronly$localhours <- as.numeric(tronly$localhours)

tronly$localhours3 <- ifelse(tronly$localhours <= 80000,"N",
                             ifelse(tronly$localhours <= 120000,"M",
                                    ifelse(tronly$localhours <= 180000,"A",  
                                           ifelse(tronly$localhours <= 240000,"E",NA))))

tronly$localhours3 <- ifelse(tronly$localhours <= 80000,"N",
                             ifelse(tronly$localhours <= 120000,"M",
                                    ifelse(tronly$localhours <= 180000, "A",
                                           ifelse(tronly$localhours <= 240000,"E",NA))))

nobouncesdataset2 <- nobouncesdataset[nobouncesdataset == 0, ]

tronly$europe <- ifelse(tronly$subContinent == " Eastern Europe", 1, 
                               ifelse(tronly$subContinent == " Northern Europe", 1, 
                                      ifelse(tronly$subContinent == " Southern Europe", 1,
                                             ifelse(tronly$subContinent == " Western Europe", 1, 0))))
install.packages("rjson")
library(rjson)

result <- fromJSON(file = "test1.json")

fromJSON
toJSON

Binary5 <-glm(transactionRevenue~factor(source)+factor(browser)+hitspage2
              +pageviews2+factor(ismobile)+isUSA+factor(weekday)+factor(quarter)
              +factor(localhours2)+visitNumber+log(pageviews)+hitspage+newVisits
              +newVisits*pageviews+isUSA*log(pageviews),family = "binomial", data = binary)

summary(binary5)

##Releveling##

levels(test3$channelGrouping)
levels(test3$operatingSystem)
levels(test3$weekday)
levels(test3$quarter)
levels(test3$subContinent)
levels(test3$localhours2)
levels(test3$isUSA)

test3$quarter <- as.factor(test3$quarter)
linear$quarter <- as.factor(linear$quarter)
test3$localhours2 <- as.factor(test3$localhours2)

test3$subContinent <- relevel(test3$subContinent, " Northern America")

distinct(test3, quarter)

levels(linear$channelGrouping)
levels(linear$operatingSystem)
levels(linear$weekday)
levels(linear$quarter)
levels(linear$subContinent)
levels(linear$localhours2)
levels(linear$isUSA)

linear$channelGrouping <- relevel(linear$channelGrouping, "(Other)")
linear$operatingSystem <- relevel(linear$operatingSystem, "other")
linear$subContinent <- relevel(linear$subContinent, " Northern America")
  
levels(linear$channelGrouping) <- c("Affiliates","Direct","Display",
                                  "Organic Search", "Paid Search", "Referral", "Social", "(Other)")

levels(linear$operatingSystem) <- c("Android","iOS","Chrome OS","Linux",
                                    "Macintosh", "Windows", "(not set)", "other")

levels(linear$subContinent) <- c(" Australisa", "Carribbean", " Central America", " Central Asia", 
                                 " Eastern Africa", " Eastern Asia", " Eastern Europe", " Middle Africa",
                                 " Northern Africa", " Northern America", " Northern Europe", " Polynesia",
                                 " Micronesian Region", " South America", " Southeast Asia", 
                                 " Southern Africa", " Southern Asia", " Southern Europe", " Western Africa",
                                 " Western Asia", " Western Europe", " (not set)", " Melanesia")

test3$hitspage <- test3$hits/test3$pageviews
test3$hitspage2 <- test3$hitspage*test3$hitspage
test3$pageviews2 <- test3$pageviews*test3$pageviews
test3$hits3 <- test3$hits**3
test3$pageviews3 <- test3$pageviews**3
test3$isChrome <- ifelse(test3$browser == "Chrome", 1, 0)
test3$isReferral<- ifelse(test3$channelGrouping == "Referral", 1, 0)
test3$visitNumber2<-test3$visitNumber**2                           
test3$hits2<-test3$hits**2

test3$localhours <- gsub("[^[:digit:]]", "", test3$localtime)
test3$localhours <- as.numeric(test3$localhours)
test3$localhours2 <- ifelse(test3$localhours <= 80000,"M",
                                ifelse(test3$localhours <= 160000,"A",
                                       ifelse(test3$localhours <= 240000,"N", NA)))

linear$localhours <- NULL
test3$localtime1 <- NULL

##Adding variables to the model##

test3$hitspage <- test3$hits/test3$pageviews
test3$hitspage2 <- test3$hitspage*test3$hitspage
test3$pageviews2 <- test3$pageviews*test3$pageviews
test3$hits3 <- test3$hits**3
test3$pageviews3 <- test3$pageviews**3
test3$isChrome <- ifelse(test3$browser == "Chrome", 1, 0)
test3$isReferral<- ifelse(test3$channelGrouping == "Referral", 1, 0)
test3$visitNumber2<-test3$visitNumber**2                           
test3$hits2<-test3$hits**2

test3$localhours <- gsub("[^[:digit:]]", "", test3$localtime)
test3$localhours <- as.numeric(test3$localhours)
test3$localhours2 <- ifelse(test3$localhours <= 80000,"M",
                            ifelse(test3$localhours <= 160000,"A",
                                   ifelse(test3$localhours <= 240000,"N", NA)))

##taking out types of observations that do not occur in the linear dataset##

test3 <- test3[test3$channelGrouping != "(Other)",]
test3 <- test3[test3$operatingSystem != "Chrome OS" & test3$operatingSystem != "(not set)" ,]
test3 <- test3[test3$subContinent != " Melanesia" & test3$subContinent != " Micronesian Region"
                     & test3$subContinent != " Middle Africa" & test3$subContinent != " Polynesia" 
                     & test3$subContinent != " Western Africa",]

##taking out the factor from the dataset## 
test3$channelGrouping <- factor(test3$channelGrouping)
test3$operatingSystem <- factor(test3$operatingSystem)
test3$subContinent <- factor(test3$subContinent)

##checking the new levels##
levels(test3$subContinent)
levels(test3$channelGrouping)
levels(test3$operatingSystem)

##prediction model##
test3$trpredict <- predict(linearmodel, test3)

range(linear$trlog)
median(test3$trpredict, na.rm = T)

test$predictbin <- predict.glm(binary,newdata=test3,type ="response")

