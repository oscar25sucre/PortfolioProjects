yt <-read.csv("topSubs.csv")

summary(yt)
colnames(yt)

head(yt, n= 10)

table(yt$Category)

#Entertainment , Gaming, Poeople and Blogs, and Music
#top 5

best<-yt[yt$Category == "Entertainment"| yt$Category == "Music" | yt$Category == "Gaming" | yt$Category == "People & Blogs" , ]

table(best$Category)
nrow(best)

tapply(best$Rank, best$Category, mean)

tapply(best$Rank, best$Category, median)

#lower the beter 

colors<- c('red','blue','cyan','yellow','green')

barplot(table(best$Category),main = "Category distribution",xlab = 'Category',ylab = 'Amount in top 1000',col =  colors)

barplot(tapply(best$Rank, best$Category, mean), main='Rank Average',xlab = 'Category',ylab = 'Avg Rank',col =  colors)

barplot(tapply(best$Rank, best$Category, median), main='Categorical Median Rank',xlab = 'Category',ylab = 'Median Rank',col =  colors)

#Video views

tapply(best$Video.Views,best$Category, mean)

#sum(best$Video.Views)

#doesn't work because video views are in char

library(tidyverse)
yt2 <- yt %>%
  mutate(`Video.Views` = as.numeric(gsub(",","",yt$Video.Views)))

summary(yt2)

best2<-yt2[yt2$Category == "Entertainment"| yt2$Category == "Music" | yt2$Category == "Gaming" | yt2$Category == "People & Blogs" , ]

tapply(best2$Video.Views,best2$Category, mean)

barplot(tapply(best2$Video.Views,best2$Category, mean),main='Average Viewer Count per Channel',xlab = 'Category',ylab = 'Avg # of views',col =  colors)

#Using Z-Test

ZTest::z_test_from_data(best, "Category", "Rank", "Music", "Entertainment")
ZTest::z_test_from_data(best, "Category", "Rank", "Music", "Gaming")
ZTest::z_test_from_data(best, "Category", "Rank", "Music", "People & Blogs")


ZTest::z_test_from_data(yt2, "Category", "Video.Views", "Entertainment" ,"Music")
ZTest::z_test_from_data(yt2, "Category", "Video.Views", "Gaming" ,"Music")
ZTest::z_test_from_data(yt2, "Category", "Video.Views", "People & Blogs" ,"Music")

