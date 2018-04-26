#import libraries
library(xlsx)
library(caret)
library(readr)
library(e1071)

#import files
survey_initial <- read.xlsx("Survey_Key_and_Complete_Responses_excel.xlsx",2)
survey_workfile <- survey_initial

#y variable <- survey_workfile$brand

#get datatypes
str(survey_workfile)

#set seed for reproduction
set.seed(123)

#change column name 
colnames(survey_workfile)[colnames(survey_workfile) == 'elevel'] <- 'education'
colnames(survey_workfile)[colnames(survey_workfile) == 'zipcode'] <- 'region'

#chg data type 
survey_workfile$education <- as.factor(survey_workfile$education)
survey_workfile$car <- as.factor(survey_workfile$car)
survey_workfile$region <- as.factor(survey_workfile$region)
survey_workfile$brand <- as.factor(survey_workfile$brand)


#make data paritions 
intraining <- createDataPartition(survey_workfile$brand,p=.75,list = FALSE)
training <- survey_workfile[intraining,]
testing <- survey_workfile[-intraining,]

#10 fold cross validation NEEDS TUNING
fitcontrol <- trainControl(method = "repeatedcv", number = 10, repeats = 10)
KNNfitcontrol <- fitcontrol

#KNN model NEEDS TUNING 
#tuneLength has R compute the number of guesses
KNNFit <- train(brand ~ .,data = training, method = "knn",trControl = fitcontrol,tuneLength=10)


#tunegrid method ==> ask how to use tune grid 
gri <- expand.grid(k=c(13,14,15,16,17,18,19,20))

#KNNFit output for training data
KNNFit

#graphic repsenetation
plot(KNNFit)


#make predictions
testPredKNN <- predict(KNNFit, testing)

#obtain confusion matrix
confusionMatrix(testPredKNN,testing$brand)

#KNN output for test data
postResample(testPredKNN,testing$brand)



#labeled data
plot(testPredKNN,testing$brand, xlab="Actual Value",ylab = "Predicted Value")

