library(xlsx)
library(caret)
library(readr)
library(e1071)
library(randomForest)

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

#10 fold cross validation, change repeats to 3 since RF is cpu heavy
RFfitcontrol <- trainControl(method = "repeatedcv", number = 10, repeats = 3)

#RF model  
#tuneLength has R compute the number of guesses
RFFit <- train(brand ~ .,data = training, method = "rf",trControl = fitcontrol,tuneLength=5)

#KNNFit output for training data
RFFit

#graphic repsenetation
plot(RFFit,"# of mtry", ylab = "Model Accuracy")


#make predictions
testPredRF <- predict(RFFit, testing)
summary(testPredRF)

#obtain confusion matrix
confusionMatrix(testPredRF,testing$brand)

#RF output for test data
postResample(testPredRF,testing$brand)

#RF model on new data 
incomplete_survery_workfile <- read.csv("SurveyIncomplete.csv")
incomplete_predict_RF <- predict(RFFit, incomplete_survey_workfile)
summary(incomplete_predict_RF)

#plot RF prediction
plot(incomplete_predict_RF, xlab="Brand",ylab = "Count")

