library(xlsx)

team = read.xlsx("team.xlsx",sheetIndex = 1, header = F)

for(i in 1:ncol(team)){
  team[,i] = as.character(team[,i])
}



library(stringi)
library(stringr)
library(tidyr)

tm = rbind(gsub(pattern = " U", replacement = ", U", team))

colnames(team) = c("team", "person1","person2","person3","person4","person5")

knitr::kable(team)
