# Purpose: To predict whether a customer will make a term deposit based on the demographic data and responses to a prior marketing campaign. 

## Summary 
K Nearest Neighbor (KNN), RandomForest (RF), and Support Vector Machines Classifier(SVC), classification models were run on the dataset. The data was spilt into 80/20 training testing sets. StandardScaler(), PCA(n_components=7), and 5 fold cross validation were applied to the data prior to running classification models. KNN with k_neighbors = 18 was the optimal model. It had the highest cross validation score of 88.92% and a predictive accuracy of 86% on the test data. In addition, its accuracy was consistent among training and testing data sets. 

##  Project structure
* [bank-full.csv](Python/ML-Marketing/bank-full.csv): dataset
* [Python scripts and outputs](Python/ML-Marketing/Bank%20marketing-PCA.ipynb): data exploration and predictiive modeling
* [Marketing  Paper](Python/ML-Marketing/Bank%20Marketing%20project%20paper.docx): summary of data insights
* [confusion matrix and classification report](Python/ML-Marketing/confusion,%20classification%20reports.xlsx): various metrics from classification prediction models.

## data dictionary

### Dependent variable (categorical data type)
* **y:** has the client subscribed a term deposit? (yes, no)

### Object ariables 

* **job :** (admin, technician, services, management, retired, blue-collar, unemployed, entrepreneur, housemaid, unknown, self-employed, student)
* **marital:** (married, single, divorced)
* **education:** (primary, secondary, tertiary, unknown)
* **default:** has credit in default? (yes, no)
* **housing:** has housing loan? (yes, no)
* **loan:** has personal loan? (yes, no)

### Related with the last contact of the current campaign:
* **contact:** contact communication type (unknown, cellular, telephone)
* **month:** last contact month of year (jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec)
* **poutcome:** outcome of the previous marketing campaign (unknown, other, failure, success)

### Numerical Variables
* **age**: [18,95]
* **balance**: average yearly balance, in euros [-8,019, 102,127]
* **day:** last contact day of the month [1, 31]
* **campaign**: number of contacts performed during this campaign and for this client (includes last contact) [1, 63]
* **pdays**: number of days that passed by after the client was last contacted from a previous campaign (numeric; "-1" means client was not previously contacted)[-1, 871]
* **previous**: number of contacts performed before this campaign and for this client [0, 275]

### Removed for prediction purposes
* **duration**: last contact duration, in seconds (numeric). Important note: this attribute highly affects the output target (e.g., if duration=0 then y='no'). Yet, the duration is not known before a call is performed. Also, after the end of the call y is obviously known. Thus, this input should only be included for benchmark purposes and should be discarded if the intention is to have a realistic predictive model. [0, 4,918]



## PCA analysis: There were 7 variables that large variances. PCA components were set to 7 prior to training models. 
![PCA](Python/ML-Marketing/images/PCA.png)

## model accuracy metrics & visualizations 
### Training data tuning accuracy metrics
![metrics](Python/ML-Marketing/images/training.png)

KNN model with K = 18 was the most accurate model.

### KNN
![knn](/images/knn.png)
### RandomForest
![rf](Python/ML-Marketing/images/rf.png)
### SVC
![SVC](Python/ML-Marketing/images/svc.png)

### The knn prediction model was applied to testing data set and was ~86% accurate. See metrics below.

![test](Python/ML-Marketing/images/prediction.png)



