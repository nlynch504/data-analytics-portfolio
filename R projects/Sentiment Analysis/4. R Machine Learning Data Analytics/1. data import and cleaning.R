#### check installed packages and load library ####

fn_check_packages <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = T)
  sapply(pkg, require, character.only = T)
}

packages <- c("doParallel", "caret", "randomForest", "e1071", "corrplot", "gbm", "arules", "data.table", "plyr")
fn_check_packages(packages)

library(caret)
library(randomForest)
library(e1071)
library(corrplot)
library(gbm)
library(arules)
library(data.table)
library(plyr)

#### import data, exploratory data analysis, and calculate correlation & covariance ####
#change sentiment (dependent) variable to factor, around 13 minutes in recording  
#for part 3, you may need to change negative/positive SD   

# maybe remove id, iphone, and ios for galaxy sentiment csv
# ===> not 100% tho 

# import sentiment matrices
origin_galaxy <- read.csv("GalaxyLargeMatrix.csv")
origin_apple <- read.csv("iPhoneLargeMatrix.csv")

galaxy_matrix <- origin_galaxy
iphone_matrix <- origin_apple

# check str and summary data
str(galaxy_matrix)
summary(galaxy_matrix$samsunggalaxy)
summary(galaxy_matrix$samsungcampos)

str(iphone_matrix)
summary(iphone_matrix$ios)
summary(iphone_matrix$samsungcampos)

#summary for sentiment, galaxy range (-503, 670) mean 1.095, iphone range (-550, 1046) mean 2.275
summary(galaxy_matrix$galaxySentiment)
summary(iphone_matrix$iphoneSentiment)

# check for NA values, there no na values
na_gal <- apply(galaxy_matrix, 2, function(x) any(is.na(x)))
summary(na_gal)

na_iphone <- apply(iphone_matrix, 2, function(x) any(is.na(x)))
summary(na_iphone)

# write correlation matrix
corr_galaxy <- cor(galaxy_matrix)
corr_iphone <- cor(iphone_matrix)


#heatmaps
corrplot(corr_galaxy, order = "hclust")
corrplot(corr_iphone, order= "hclust")

#write csvs for corr matrices
write.csv(corr_galaxy, "galaxy_corr.csv")
write.csv(corr_iphone, "iphone_corr.csv")

##### Feature selection #####
#upper tri shows the upper half of the matrix so you don't have dup values
# both matrices have a min and 3rd quadrant of about .63 ish
summary(corr_galaxy[upper.tri(corr_galaxy)])
high_galaxy <- findCorrelation(corr_galaxy, cutoff = 0.80)
list_high_corr_gal <- galaxy_matrix[, high_galaxy]
head(list_high_corr_gal)

summary(corr_iphone[upper.tri(corr_iphone)])
high_iphone <- findCorrelation(corr_iphone, cutoff = 0.80)
list_high_corr_iphone <- iphone_matrix[, high_iphone]
head(list_high_corr_iphone)

#create datasets that exclude high covariance
feat_galaxy <- galaxy_matrix[, -high_galaxy]
feat_iphone <- iphone_matrix[, -high_iphone]

#### lists of feature ####
feat_gal_list <- colnames(feat_galaxy)
feat_iphone_list <- colnames(feat_iphone)sa

# preprocessing the featured matrices
summary(feat_galaxy$galaxySentiment)
disc_galaxy <- discretize(feat_galaxy$galaxySentiment, "fixed", categories = c(-Inf, -35, -10, -1, 1, 10, 35, Inf))
#inspect discretized vector
summary(disc_galaxy)
plot(disc_galaxy)

summary(feat_iphone$iphoneSentiment)
disc_iphone <- discretize(feat_iphone$iphoneSentiment, "fixed", categories = c(-Inf,-55, -10, -1, 1, 10, 55, Inf))
#inspect vector
summary(disc_iphone)
plot(disc_iphone)

#assign factorized values to feature dataframes
feat_galaxy$galaxySentiment <- disc_galaxy
feat_iphone$iphoneSentiment <- disc_iphone

# check str, structure is good
str(feat_galaxy)
str(feat_iphone)

sum_distri_gal <- rbind(summary(feat_galaxy$galaxySentiment))
sum_distri_iphone <- rbind(summary(feat_iphone$iphoneSentiment))

#### copy feature data and assign text labels ####
copy_feat_gal <- data.table(copy(feat_galaxy))
copy_feat_iphone <- data.table(copy(feat_iphone))

# rename labels
copy_feat_gal$galaxySentiment <- mapvalues(copy_feat_gal$galaxySentiment , from = c("[-Inf,-35)",	"[-35,-10)",	"[-10,-1)",	"[-1,1)",	"[1,10)",	"[10,35)",	"[35, Inf]"), to = c("very negative", "negative", "somewhat negative", "neutral", "somewhat positive", "positive", "very positive"))

copy_feat_iphone$iphoneSentiment <- mapvalues(copy_feat_iphone$iphoneSentiment , from = c("[-Inf,-55)",	"[-55,-10)",	"[-10,-1)",	"[-1,1)",	"[1,10)",	"[10,55)",	"[55, Inf]"), to = c("very negative", "negative", "somewhat negative", "neutral", "somewhat positive", "positive", "very positive"))

bar_gal <- barplot(summary(copy_feat_gal$galaxySentiment), ylab = "Count", main = "Galaxy Phone Sentiment", col = "green", las=2)

