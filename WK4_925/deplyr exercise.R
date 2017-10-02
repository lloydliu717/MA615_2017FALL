##  the dplyr and tidyr exercises from the Brad Boehmke blog

## the blog is open so commands and data can be copied

## first

library(dplyr)
library(tidyr)

library(stringr)

# table a

# copy the table in from the blod -- it will come in commented lines
# then use the (Code > Comment/uncomment line) to remove the comments easily
# then scan the lines into a data.frame

# take the first line of data

t <- "1      1 2006    15    16    19    17"

# ok we want to remove the spaces
t1 <- str_replace_all(t,"\\s+"," ")  

# \\s+ is a regulare expression that finds the white space to be replaced


t2 <- str_split(t1," ")   # What is t2??

t3 <- unlist(t2)  

t4 <- as.integer(t3)


ha <-    "Group Year Qtr.1 Qtr.2 Qtr.3 Qtr.4"
ba <- "1      1 2006    15    16    19    17
2      1 2007    12    13    27    23
3      1 2008    22    22    24    20
4      1 2009    10    14    20    16
5      2 2006    12    13    25    18
6      2 2007    16    14    21    19
7      2 2008    13    11    29    15
8      2 2009    23    20    26    20
9      3 2006    11    12    22    16
10     3 2007    13    11    27    21
11     3 2008    17    12    23    19
12     3 2009    14     9    31    24"

h1 <- str_replace_all(ha,"\\s+"," ")  # remove extra whitespace
h2 <- str_split(h1, " ")              # use the spaces to split the string
str(h2)
h3 <- unlist(h2)                      # h3 is the vector of column heads we want

str(h3)
is.vector(h3)
length(h3)


# now that we understand these commands we can combine them

head.a <- ha %>% str_replace_all("\\s+"," ") %>% str_split(" ") %>% unlist()

str(head.a)
is.vector(head.a)
length(head.a)


body.a <- ba %>% str_replace_all("\\s+"," ") %>% str_split(" ") %>% unlist()

body.a <- as.integer(body.a)

body.a <- matrix(body.a, nrow = 12, byrow = TRUE)

body.a <- body.a[,-1]  # drop the first col

DF.a <- data.frame(body.a, stringsAsFactors = FALSE)

colnames(DF.a) <- head.a
DF.a

long_DF.a <- DF.a %>% gather(Quarter, Revenue, Qtr.1:Qtr.4)
long_DF.a


head(long_DF.a)

#############################
# now use separate to breakup QTR.#

separate_DF.a <- long_DF.a %>% separate(Quarter, c("time unit", "ID"))



head(separate_DF.a)

##################################################
# replace spaces in data items with underscore
# add "Unknown" in line 9 so there are 5 data items
# split City_State into City State in the initial string to match the heading 
# for the data frame


hb <-   "Grp_Ind    Yr_Mo       City State        First_Last Extra_variable"
bb <- "1     1.a 2006_Jan      Dayton (OH) George_Washington   XX01person_1
2     1.b 2006_Feb Grand_Forks (ND)        John_Adams   XX02person_2
3     1.c 2006_Mar       Fargo (ND)  Thomas_Jefferson   XX03person_3
4     2.a 2007_Jan   Rochester (MN)     James_Madison   XX04person_4
5     2.b 2007_Feb     Dubuque (IA)      James_Monroe   XX05person_5
6     2.c 2007_Mar Ft._Collins (CO)        John_Adams   XX06person_6
7     3.a 2008_Jan   Lake_City (MN)    Andrew_Jackson   XX07person_7
8     3.b 2008_Feb    Rushford (MN)  Martin_Van_Buren   XX08person_8
9     3.c 2008_Mar Unknown   Unknown  William_Harrison   XX09person_9"


head.b <- hb %>% str_replace_all("\\s+"," ") %>% str_split(" ") %>% unlist()

body.b <- bb %>% str_replace_all("\\s+"," ") %>% str_split(" ") %>% unlist()

body.b <- matrix(body.b, nrow = 9, byrow=TRUE)

body.b <- body.b[,-1]
body.b
head.b

DF.b <- data.frame(body.b)
colnames(DF.b) <- head.b

