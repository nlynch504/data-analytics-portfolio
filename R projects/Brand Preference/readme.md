# Purpose: To predict customer brand preference

### Notes
1. [Survey_Key_and_Complete_Responses_excel.xlsx](https://github.com/nlynch504/data-analytics-portfolio/edit/master/R%20projects/Brand%20Preference/Survey_Key_and_Complete_Responses_excel.xlsx) represents initial dataset that the predicting modeling is run on.
2. [SurveyIncomplete.csv](https://github.com/nlynch504/data-analytics-portfolio/edit/master/R%20projects/Brand%20Preference/SurveyIncomplete.csv) represents the incomplete dataset where we predict customer brand preference based on historical data.

## Project Structure
1. [KNN.R](https://github.com/nlynch504/data-analytics-portfolio/edit/master/R%20projects/Brand%20Preference/KNN.R)  Imports and cleans data. Then, runs knn modeling on dataset and computes accuracy.
2. [RandomForest.R](https://github.com/nlynch504/data-analytics-portfolio/edit/master/R%20projects/Brand%20Preference/Random%20Forest.R) Runs RandomForest modeling on dataset and computes accuracy. RandomForest was the most accurate model, the model was applied to dataset [Incomplete.csv](R%20projects/Brand%20Preference/SurveyIncomplete.csv) 

## Model accuracy visualizations
RandomForest with mtry = 10 was the most accurate model.

### RandomForest Accuracy
![RandomForest Accuracy](https://github.com/nlynch504/data-analytics-portfolio/edit/master/R%20projects/Brand%20Preference/Final%20Report/RF%20output.jpeg)

### KNN Accuracy 
![KNN Accuracy](https://github.com/nlynch504/data-analytics-portfolio/edit/master/R%20projects/Brand%20Preference/Final%20Report/KNN%20output.jpeg)


