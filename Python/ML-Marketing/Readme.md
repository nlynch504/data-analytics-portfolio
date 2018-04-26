# Purpose: To predict whether a customer will make a term deposit based on the demographic data and responses to prior marketing campaign. 

##  Project structure
0. [Marketing  Paper](Python/ML-Marketing/0%20-%20Marketing%20project%20paper.docx)
1. [clean.py](Python/ML-Marketing/clean.py) clean data for predictive modeling 
2. [correlate.py](Python/ML-Marketing/correlate.py) generate correlation matrix and sns heatmaps 
3. [KNN.py](Python/ML-Marketing/KNN.py) run KNN Model and visualize results
4. [rf.py](Python/ML-Marketing/rf.py) run randomForest model 
5. [rf visualization.py](Python/ML-Marketing/rf_visualization.py) run random forest visualization
6. [bayes.py](Python/ML-Marketing/bayes.py) run Naive Bayes model
7. [bayes_visualization.py](Python/ML-Marketing/bayes_visualization.py) run Naive Bayes visualization
8. [output information](Python/ML-Marketing/Output)
9. [confusion matrix and classification report](Python/ML-Marketing/confusion,%20classification%20reports.xlsx)

## model accuracy visualizations 
KNN model with K = 8 was the most accurate model.

### KNN
![knn](Python/ML-Marketing/images/knn.png)
### RandomForest
![rf](Python/ML-Marketing/images/rf.png)
### Naive Bayes
![nb](Python/ML-Marketing/images/nb.png)

###  Note: 
1. To keep scripts short I made the "clean.py" a module. If you want to run the scripts, make sure that that clean.py is in folder where you are running the other scripts.
2. Folder location for read.csv() function in clean.py will need to be updated as well. 

