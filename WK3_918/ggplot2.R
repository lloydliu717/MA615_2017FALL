#install.packages("ggplot2")
library(ggplot2)

### barplot

head(mtcars)

ggplot(data = mtcars, aes(carb)) + geom_bar()
ggplot(data = mtcars, aes(factor(carb))) + geom_bar()
ggplot(data = mtcars) + geom_bar(aes(factor(carb)))
ggplot(data = mtcars) + geom_bar(aes(factor(carb),fill=factor(cyl)))
ggplot(data = mtcars) + geom_bar(aes(x=factor(carb),fill=factor(cyl)),position='dodge')
ggplot(data = mtcars) + geom_bar(aes(factor(carb),fill=factor(am))) + coord_flip()

head(diamonds)
dataset = diamonds
ggplot(data = dataset, aes(color)) + geom_bar(fill=5)
p <-  ggplot(data = dataset)
p + geom_bar(aes(factor(color)))
p + geom_bar(aes(factor(color),fill=factor(clarity)))
p + geom_bar(aes(factor(color),fill=factor(clarity)),position='dodge')

# PRICE LEVEL
summary(diamonds$price)
# 1000, 5000
pricelevel <- (diamonds$price>1000) + (diamonds$price > 5000)
is.vector(pricelevel)
#pricelevel[pricelevel==2]
dataset$pricelevel <-  as.factor(as.integer(pricelevel))

p <-  ggplot(data = dataset)
p + geom_bar(aes(factor(color),fill=factor(clarity))) + 
  facet_wrap(~pricelevel)

### boxplot
p + geom_boxplot(aes(x=factor(clarity),y=price))
p + geom_boxplot(aes(x=factor(clarity),y=price)) + geom_jitter()
p + geom_boxplot(aes(x=factor(clarity),y=price)) + 
  geom_jitter(aes(x=factor(clarity),y=price))

### point and smooth
p <- ggplot(dataset, aes(x=carat,y=price))
p + geom_smooth()
p + geom_smooth() + geom_point(aes(color=cut))

### density and histogram 
ggplot(dataset, aes(x=price)) + geom_histogram(bins=10)
ggplot(dataset, aes(x=price)) + geom_histogram(bins=30)
ggplot(dataset, aes(x=price)) + geom_density(color=5,fill=9)
ggplot(dataset, aes(x=price,y=carat)) + geom_density2d(aes(fill=..level..))#,geom="polygon")
ggplot(dataset, aes(x=price,y=carat)) + 
  stat_density2d(aes(fill=..level..),geom="polygon") +
  geom_vline(aes(xintercept=3000)) + 
  geom_hline(aes(yintercept=0.8))


