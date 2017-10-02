library(stringr)
library(tidyr)
library(magrittr)
library(data.table)
library(ggplot2)
library(lubridate)
library(plyr)

#STEP ONE
###read in##put data file and R code in your working directory
##setwd("")
corn = read.csv2("corn.csv",sep = ",",stringsAsFactors = F)

###glimpse
colnames(corn) 
head(corn)

#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

#STEP TWO

#Check each variable(column) and if it is all NAs, then drop it.
#if there is too much NA, check them one by one is time consuming and tiring, a loop is recommended
indi = rep(0,ncol(corn))
for(i in 1: ncol(corn)){indi[i] = sum(!is.na(corn[,i]))}
which(indi==0)
#[1]  4  8  9 10 11 12 13 15 21
tidycorn = corn[,-c(which(indi==0))]
rm(indi,corn)
#we removed 9 variables
#you can check by looking at them by View(tidycorn) or click tidycorn in Environment Panel(In the right top part of your screen) ======>>


#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

#STEP THREE
#check remaining variables, if the value in these variables doesn't change at all, then drop it

table(tidycorn$Year)#meaningful

table(tidycorn$Domain)#meaningless
table(tidycorn$Domain.Category)#meaningless
table(tidycorn$Commodity)#meaningless
table(tidycorn$watershed_code)#meaningless
table(tidycorn$Program)#meaningless
table(tidycorn$Geo.Level)#meaningless

#these are variables that do not vary in this scale. If our target dataset is just in this file, we can just drop them.


###Extract Stable information of this dataset just in case.
Info = tidycorn[,c("Domain","Domain.Category","Commodity","watershed_code","Program","Geo.Level")][1,]

###Drop stable variables
dr = function(name){return(which(colnames(tidycorn)==name))}
tidycorn = tidycorn[,-c(dr("Domain"),
                        dr("Domain.Category"),
                        dr("Commodity"),
                        dr("watershed_code"),
                        dr("Program"),
                        dr("Geo.Level"))]
rm(i,dr)

#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

#STEP FOUR #(optional)
###Transform Period and State into number and lower capital

tidycorn$State = tolower(tidycorn$State) #try tolower() and toupper() to a string


month.abb.c = toupper(month.abb) ##extract Month name from build-in variable


for(i in 1:length(month.abb.c)){#check and substitude the month by number
  tidycorn$Period = gsub(pattern = month.abb.c[i],replacement = i,x = tidycorn$Period)
}

table(tidycorn$Period)#12 thru 2 #9 thru 11 indicate time periods

#if you check Period before the this step, you will see this.

## APR          AUG          DEC DEC THRU FEB          FEB          JAN          JUL          JUN 
## 252          249          234           16          252          252          251          252 
## MAR          MAY          NOV          OCT          SEP SEP THRU NOV 
## 252          252          234          234          239           16 

tidycorn$Period = gsub(pattern = "THRU",replacement = "~",x = tidycorn$Period) #replace the "THRU"

table(tidycorn$Period)#you can see the difference

rm(i,month.abb.c)
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

#STEP FIVE

##### ok now we need to setup the variable format: factors numbers chars, etc.

##### we could do "stringsAsFactors = T" when read in our data in line 12 to set all string variables to factors
##### Be careful when using the factors!!
tidycorn$Year <- factor(tidycorn$Year)
levels(tidycorn$Year)

tidycorn$Period <- factor(tidycorn$Period,levels = c("1","2","3","4","5","6","7","8","9","10","11","12","9 ~ 11","12 ~ 2"))
levels(tidycorn$Period)

tidycorn$State <- factor(tidycorn$State)
levels(tidycorn$State)

tidycorn$State.ANSI <- factor(tidycorn$State.ANSI)
levels(tidycorn$State.ANSI)

#for Value, the thing is tricky
warning(as.numeric(tidycorn$Value))
#1: In warning(as.numeric(tidycorn$Value)) : NAs introduced by coercion

#find why this happens
which(is.na(as.numeric(tidycorn$Value)))#find which row turned to NA

tidycorn$Value[which(is.na(as.numeric(tidycorn$Value)))] #is the comma

#eliminate the comma and switch type to numeric
tidycorn$Value = gsub(pattern = ",",replacement = "",x = tidycorn$Value)
tidycorn$Value = as.numeric(tidycorn$Value)



#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

#STEP SIX

## now we need to operate on the Data.Item column 
## eliminate the redundancies

table(tidycorn$Data.Item)
# CORN,          GRAIN - PRICE RECEIVED, MEASURED IN $ / BU    
# CORN,          GRAIN - SALES,          MEASURED IN PCT OF MKTG YEAR
# CORN, ON FARM, GRAIN - DISAPPEARANCE,  MEASURED IN BU 

tidycorn$Data.Item = as.character(tidycorn$Data.Item)

tidycorn %<>% separate(Data.Item, into = paste("Data.Item",1:4,sep = ""),sep = ", ",remove = TRUE)
#Turn:
#CORN,          GRAIN - PRICE RECEIVED, MEASURED IN $ / BU    

#Into:
#| CORN | GRAIN - PRICE RECEIVED | MEASURED IN $ / BU | 

head(tidycorn)#see what's happened

table(tidycorn$Data.Item1)###drop it!
tidycorn$Data.Item1 = NULL

sum(!is.na(tidycorn$Data.Item4))###can not drop!

#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

table3 = subset(tidycorn,subset = Data.Item2 == "ON FARM")
tidycorn = tidycorn[-as.integer(rownames(table3)),]
colnames(table3)
#"Year"      "Period"    "State"   "State.ANSI"   "Data.Item2"      "Data.Item3"      "Data.Item4"         "Value"
##Data.Item3 ---> Data.Item2
##Data.Item4 ---> Data.Item3
##Data.Item2 ---> Data.Item4
colnames(table3) = c("Year","Period" ,"State" ,"State.ANSI","Data.Item4","Data.Item2","Data.Item3","Value" )
table3 = table3[,c("Year","Period","State","State.ANSI","Data.Item2","Data.Item3","Data.Item4","Value")]
table3$Value = gsub(pattern = ",",replacement = "",x = table3$Value)
table3$Value = as.numeric(table3$Value)

tidycorn = rbind(tidycorn,table3)
rm(table3)
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

tidycorn %<>% separate(Data.Item2, into = paste("Data.Item.sub",1:2,sep = ""),sep = " - ",remove = TRUE)

table(tidycorn$Data.Item.sub1)

tidycorn$Data.Item.sub1 = NULL

#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

##
save(file = "corndog.sav", list = "tidycorn")

save(tidycorn,file = "tidycorn.Rdata")
rm(list = ls())

#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

load("tidycorn.Rdata")
load("corndog.sav")#both works

###Play with data

##TIME SERIES

SALES = subset(tidycorn,subset = Data.Item.sub2=="SALES")

CO_SALES = subset(SALES,subset = State=="colorado")

ggplot(CO_SALES) + geom_point(aes(x=Period,y=Value,col=Year)) + facet_wrap(~Year) + ggtitle("CORN - SALES IN PCT OF MKTG YEAR - COLORADO")

ggplot(CO_SALES) + geom_smooth(aes(x=Period,y=Value,group=Year,col=Year),alpha = 0.05) + ggtitle("CORN - SALES IN PCT OF MKTG YEAR - COLORADO")

CO_SALES$time = paste(CO_SALES$Year,CO_SALES$Period,"01",sep = "-")
CO_SALES$time = ymd(CO_SALES$time)

ggplot(CO_SALES) + geom_line(aes(x = time,y = Value)) + ggtitle("CORN - SALES IN PCT OF MKTG YEAR - COLORADO")

#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
SALES %<>% as.data.table()
SALES = SALES[,list(Value=median(Value)),by=State]
#dplyr::group_by()
#aggregate()
#do the same things 
#data.table do it fast

statmap = map_data("state")
corn_map = merge(SALES,statmap,by.x = "State", by.y = "region",all.y = T)
corn_map = arrange(corn_map,order,group)

ggplot(corn_map,aes(x=long, y=lat, group=group)) +
  geom_polygon(linetype = 2, size = 0.1, colour = "lightgrey",aes(fill = Value)) + 
  expand_limits(x = corn_map$long, y = corn_map$lat) + 
  coord_map( "polyconic")

rm(statmap,t,theme_clean)

##############Notice:
##############Other ways to divide table, e.g. table contain data of a certain state, is also reasonable.


