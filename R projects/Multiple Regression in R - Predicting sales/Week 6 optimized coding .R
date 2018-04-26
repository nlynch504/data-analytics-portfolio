#### user variables ####

usr_working_dir <- "/Users/lynchno/Downloads/"
usr_input_data_exist_prod_file_name <- "existingproductattributes2017.csv"
usr_input_data_new_prod <- "newproductattributes2017.csv"
usr_output_data_new_prod_file_name <- "C2T3_new_prod_predictions.csv"

#### prep environment ####
#function check to see which packages are installed/updates uninstalled packages

fn_check_packages <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = T)
  sapply(pkg, require, character.only = T)
}

packages <- c("data.table","doParallel", "caret", "randomForest", "e1071", "corrplot", "gbm")
fn_check_packages(packages)

#load packages 

library(data.table)
library(caret)
library(randomForest)
library(e1071)
library(corrplot)
library(gbm)

#### prep input data ####

#set wd 
setwd(usr_working_dir)

#load data
dt_input_data_exist_prod <- fread(usr_input_data_exist_prod_file_name)
dt_exist_prod_workfile <- copy(dt_input_data_exist_prod)

#get data structure
str(dt_exist_prod_workfile)

#Step 1 - dummify data, which mean assigning binary values for attributes that have non-numeric data (product type)
# this allow R to run regression models on this data table since all values are now numeric
# creates a list of dummy variables
dt_dummy_eprod <- dummyVars(" ~ .", data = dt_exist_prod_workfile)

#Step 2 - dummify data - take dummy variable list and coerce it with the old data.table
dt_ready_data <- data.table(predict(dt_dummy_Eprod, newdata = dt_exist_prod_workfile))

# use summary to check for na values 
summary(dt_ready_data)

# Best seller rank is the only attribute with NA values
#removed best seller column
dt_ready_data$BestSellersRank <- NULL

#### analyze data ####

#correlation matrix 
corr_data <- cor(dt_ready_data)

#show corr matrix
corr_data
write.csv(corr_data,"Correlation_matrix.csv", sep = ',')

#show corr matrix heat map - requires corrplot package
corrplot(corr_data)

#remove 5staair for having perfect correlation  
dt_ready_data$x5StarReviews <- NULL

#seed
set.seed(123)

#linear model
linear_model <- lm(Volume~., data = dt_ready_data)
summary(linear_model)

#make data paritions  
train_size <- createDataPartition(dt_ready_data$Volume, p = .75, list = F)
training <- dt_ready_data[train_size,]
testing <- dt_ready_data[-train_size,]

#fit_control where number of folds in 10 
fit_control <- trainControl(method = "repeatedcv", number = 10, repeats = 10)

#models with 10 folds 
rf_fit <- train(Volume ~ .,  data = training, method = "rf", metric = "Rsquared", trControl = fit_control)
svm_fit <- train(Volume ~ ., data = training, method = "svmLinear2", metric = "Rsquared", trControl = fit_control)
gbm_fit <- train(Volume ~ ., data = training, method = "gbm", metric = "Rsquared", trControl = fit_control,verbose = F)

#svm generated errors based on scaling, as such I added "scale = F" to the train function. No errors were noted
#but the model was overfitted if scaling was disabled.
svm_fit_noscale <- train(Volume ~ ., data = training, method = "svmLinear2", metric = "Rsquared", trControl = fit_control, scale = F)

#predicts for the various models 
test_pred_rf <- predict(rffit, newdata = testing)
test_pred_svm <- predict(svmfit, newdata = testing)
test_pred_gbm <- predict(gbmfit, newdata = testing)
test_pred_svm_noscale <- predict(svmfit_noscale, newdata = testing)

#prediction summary
summary(test_pred_rf)
summary(test_pred_svm)
summary(test_pred_gbm)
summary(test_pred_svm_noscale)
#both the svm model and gbm model produce negative values and therefore cannot be used 

#prediction metrics on test data
postResample(test_pred_rf1, testing$Volume)

#### predict new data using loop ####


#import new dataset 
dt_new_prod <- fread(usr_input_data_new_prod)
dt_new_prod_workfile <- copy(dt_new_prod)

#get data structure
str(dt_new_prod_workfile)

#dummify data - Step 1 
dt_dummy_new_prod <- dummyVars(" ~ .", newdata = dt_new_prod_workfile)

#dummify data - step 2 
dt_ready_data_newprod <- data.table(predict(dt_dummy_new_prod, newdata = dt_new_prod_workfile))

#remove new best seller ranking 
dt_ready_data_newprod$BestSellersRank <- NULL
dt_ready_data_newprod$x5StarReviews <- NULL

#predictions on new data
dt_final_pred_rf <- predict(rf_fit, newdata = ready_data_newprod) 

#summary data
summary(dt_final_pred_rf)

#create output file 
project_output <- dt_new_prod_workfile

#add predicts to output file 
project_output$Predictions_Volume <- dt_final_pred_rf

#export
write.csv(project_output,file = usr_output_data_new_prod_file_name, row.names = T)
