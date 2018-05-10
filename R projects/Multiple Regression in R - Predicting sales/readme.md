# Purpose: To predict sales volumes of new products based on historical sales data of products with similar attributes. 

Sales volume is the dependent variable.


## Project Structure 
1. [Parallel processing.R](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Multiple%20Regression%20in%20R%20-%20Predicting%20sales/Parallel%20processing.R)  : Allows you to utilize more than 1 cpu for training machine learning models. Change the number of cores based on your CPU architecture. You do not want to use all the CPU cores on your PC, please leave 1 core to perform backgrounds processes. Otherwise, your PC will crash.

2. [Final week 6 R script.R](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Multiple%20Regression%20in%20R%20-%20Predicting%20sales/Final%20week%206%20R%20script.R) : imports historical sales data, cleans data, runs machine learning model on data, chose most accurate model to predict future sales volume.

3. [Week 6 optimized coding .R](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Multiple%20Regression%20in%20R%20-%20Predicting%20sales/Week%206%20optimized%20coding%20.R) : optimized version of final week 6 scripts.R.

## Data visualizations
### Correlation matrix heat map
![correlation matrix](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Multiple%20Regression%20in%20R%20-%20Predicting%20sales/Final%20report/Corr%20matrix%20heat%20map.png)

### Model Accuracy comparsion
![dotplot](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Multiple%20Regression%20in%20R%20-%20Predicting%20sales/Final%20report/Model%20accuracy.png)

**Insights** RandomForest is the most accurate model. In addition, when SVM and GradientBoostedMachines models were used for volumes predicts, the predicted negative sales volumes. This is not possible, therefore, RandomForest is the best prediction model.

### Predicted new product sales based on RandomForest model
**Sales by project category**

![Project category](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Multiple%20Regression%20in%20R%20-%20Predicting%20sales/Final%20report/Product%20category%20sales.png)

**Sales by product**

![Project sales](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Multiple%20Regression%20in%20R%20-%20Predicting%20sales/Final%20report/Product%20sales.png)
