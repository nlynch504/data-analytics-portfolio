#function check to see which packages are installed/updates uninstalled packages

fn_check_packages <- function(pkg) {
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg))
    install.packages(new.pkg, dependencies = T)
    sapply(pkg, require, character.only = T)
}

packages <- c("doParallel", "caret", "randomForest", "e1071", "corrplot", "gbm")
fn_check_packages(packages)

#load library
library(caret)
library(randomForest)
library(e1071)
library(corrplot)
library(gbm)

#load data
exist_prod <- read.csv("existingproductattributes2017.csv")
exist_prod_workfile <- exist_prod

#get data structure
str(exist_prod_workfile)

#dummify data - Step 1 
dummy_Eprod <- dummyVars(" ~ .", data = exist_prod_workfile)

#dummify data - step 2 
ready_Data <- data.frame(predict(dummy_Eprod, newdata = exist_prod_workfile))

#best sellers contains NAs
#remove NA values
ready_Data$BestSellersRank <- NULL

#correlation matrix 
corrData <- cor(ready_Data)

#show corr matrix
corrData
write.csv(corrData,"Correlation_matrix.csv", sep = ',')

#show corr matrix heat map - requires corrplot package
corrplot(corrData, method = 'circle', type = 'lower', srt = 0.001)


#remove 5staair for having perfect correlation  
ready_Data$x5StarReviews <- NULL

#seed
set.seed(123)

#linear model
LinearModel <- lm(Volume~., data = ready_Data)
summary(LinearModel)

#make data paritions  
trainSize <- createDataPartition(ready_Data$Volume, p = .75, list = FALSE)
training <- ready_Data[trainSize,]
testing <- ready_Data[-trainSize,]

#fitcontrol1 where number of folds in 10 
fitcontrol1 <- trainControl(method = "repeatedcv", number = 10, repeats = 10)

#models with 10 folds 
rffit <- train(Volume ~ .,  data = training, method = "rf", metric = "Rsquared", trControl = fitcontrol1)
svmfit <- train(Volume ~ ., data = training, method = "svmLinear2", metric = "Rsquared", trControl = fitcontrol1)
gbmfit <- train(Volume ~ ., data = training, method = "gbm", metric = "Rsquared", trControl = fitcontrol1,verbose = FALSE)

model_summary <- resamples(list(randomForest = rffit, SVM = svmfit, GrandientBoostedMachines = gbmfit),metric = 'Rsquared' ,decreasing=T)

model_dotplot <- dotplot(model_summary, metric = 'Rsquared', ylab = 'Classifier Method')

#svm generated errors based on scaling, as such I added "scale = False" to the train function. No errors were noted
#but the model was overfitted if scaling was disabled.
svmfit_noscale <- train(Volume ~ ., data = training, method = "svmLinear2", metric = "Rsquared", trControl = fitcontrol1, scale = FALSE)

#predicts for the various models 
testPred_rf1 <- predict(rffit, newdata = testing)
testPred_svm1 <- predict(svmfit, newdata = testing)
testPred_gbm <- predict(gbmfit, newdata = testing)
testPred_svm_noscale <- predict(svmfit_noscale, newdata = testing)

#prediction summary
summary(testPred_rf1)
summary(testPred_svm1)
summary(testPred_gbm)
summary(testPred_svm_noscale)

#both the svm model and gbm model produce negative values and therefore cannot be used 

#prediction metrics on test data
postResample(testPred_rf1, testing$Volume)

#import new data set 
new_prod <- read.csv("newproductattributes2017.csv")
new_prod_workfile <- new_prod

#get data structure
str(new_prod_workfile)

#dummify data - Step 1 
dummy_New_prod <- dummyVars(" ~ .", data = new_prod_workfile)

#dummify data - step 2 
ready_Data_newprod <- data.frame(predict(dummy_New_prod, newdata = new_prod_workfile))

#remove new best seller ranking 
ready_Data_newprod$BestSellersRank <- NULL
ready_Data_newprod$x5StarReviews <- NULL

#predictions on new data
FinalPred_rf1 <- predict(rffit, newdata = ready_Data_newprod) 

#summary data
summary(FinalPred_rf1)

#create output file 
project_output <- new_prod_workfile

#add predicts to output file 
project_output$Predictions_Volume <- FinalPred_rf1

#export
write.csv(project_output,file = "C2T3_new_prod_predictions.csv", row.names = TRUE)
