#### set libaries ####

library(caret)
library(randomForest)
library(e1071)
library(corrplot)
library(gbm)
library(C50)
library(arules)

#### setting up sampling ####
#set seed and sampling 4k pop
set.seed(123)

sam_galaxy <- feat_galaxy[sample(1:nrow(feat_galaxy), 4000, replace = FALSE),]
sam_iphone <- feat_iphone[sample(1:nrow(feat_iphone), 4000, replace = FALSE),]

#### galaxy modeling ####
gal_trainSize <- createDataPartition(sam_galaxy$galaxySentiment, p = .70, list = FALSE)
gal_training <- sam_galaxy[gal_trainSize,]
gal_testing <- sam_galaxy[-gal_trainSize,]

# fit control with 5 fold cross validation
gal_fit_control <- trainControl(method = "repeatedcv", number = 5, repeats = 5)

# galaxytraining models
system.time({rf_gal <- train(galaxySentiment ~ ., data = gal_training, method = "rf", trControl = gal_fit_control, tuneLength = 5)})
save.image()


system.time({svm_gal <- train(galaxySentiment ~ ., data = gal_training, method = "svmLinear2", trControl = gal_fit_control, tuneLength = 5)})
save.image()

#run
system.time({knn_gal <- train(galaxySentiment ~ ., data = gal_training, method = "knn", trControl = gal_fit_control, tuneLength = 5)})
save.image()
system.time({nb_gal <- train(galaxySentiment ~ ., data = gal_training, method = "naive_bayes", trControl = gal_fit_control, tuneLength = 5)})
save.image()
##### iphone modeling #####
iphone_trainSize <- createDataPartition(sam_iphone$iphoneSentiment , p = .70, list = FALSE)
iphone_training <- sam_iphone[iphone_trainSize,]
iphone_testing <- sam_iphone[-iphone_trainSize,]

# fit control with 5 fold cross validation
iphone_fit_control <- trainControl(method = "repeatedcv", number = 5, repeats = 5)

# iphonetraining models
system.time({rf_iphone <- train(iphoneSentiment ~ ., data = iphone_training, method = "rf", trControl = iphone_fit_control, tuneLength = 5)})
save.image()

#svm 
system.time({svm_iphone <- train(iphoneSentiment ~ ., data = iphone_training, method = "svmLinear2", trControl = iphone_fit_control, tuneLength = 5)})
save.image()

#ran successfully 
knn_iphone <- train(iphoneSentiment ~ ., data = iphone_training, method = "knn", trControl = iphone_fit_control, tuneLength = 5)
save.image()
nb_iphone <- train(iphoneSentiment ~ ., data = iphone_training, method = "naive_bayes", trControl = iphone_fit_control, tuneLength = 5)
save.image()

#### galaxy review models results and export ####

knn_gal$bestTune
rf_gal$bestTune
svm_gal$bestTune
nb_gal$bestTune

models <- list(knn = knn_gal$results, rf= rf_gal$results, svm = svm_gal$results, nb = nb_gal$results)

resample_gal <- resamples(list(knn = knn_gal, rf= rf_gal, svm = svm_gal, nb = nb_gal))
summary(resample_gal)

# write model results
for (i in names(models)){
  write.csv(models[[i]], file = paste0(i,".csv"), row.names = F)
  }

#### iphone results, where resampling is more efficient that looping #####
i_models <- list(knn = knn_iphone$results, rf= rf_iphone$results, svm = svm_iphone$results, nb = nb_iphone$results)

# write model results
for (i in names(i_models)){
  write.csv(i_models[[i]], file = paste0(i,".csv"), row.names = F)
}

resample_iphone <- resamples(list(knn = knn_iphone, rf= rf_iphone, svm = svm_iphone, nb = nb_iphone), metric = c('Accuracy','Kappa') ,decreasing=T)
resample_iphone
summary(resample_iphone)


#### gal, iphone predictions and postsamples ####
#rf is the best model for both gal and iphone and doesn't show signs of overfitting
# where rf has mtry = 24

predict_gal <- predict(rf_gal, newdata = gal_testing)

predict_iphone <- predict(rf_iphone, newdata = iphone_testing)

## accuracy against real data
post_gal <- postResample(predict_gal, gal_testing$galaxySentiment) 
post_gal

post_iphone <- postResample(predict_iphone, iphone_testing$iphoneSentiment) 
iPhone_testing_results <- post_iphone 
Galaxy_testing_resilts <- post_gal

final_results <- rbind(Galaxy_testing_resilts,iPhone_testing_results)
write.csv(final_results, "resample.csv")

#stop parallel processing
stopCluster(cl)

#### dot graphic viz for comparing models ####
dotplot_gal <- dotplot(resample_gal, metric = c('Accuracy','Kappa'), ylab='Galaxy Classifer Method')
dotplot_gal

dotplot_iphone <- dotplot(resample_iphone, metric = c('Accuracy', 'Kappa'), ylab='iPhone Classifer Method')
dotplot_iphone
