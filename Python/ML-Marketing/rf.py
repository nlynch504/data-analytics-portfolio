import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split, cross_val_score, RandomizedSearchCV, GridSearchCV
from sklearn.metrics import confusion_matrix, classification_report
from sklearn.ensemble import RandomForestClassifier

from clean import bank_dummies, X, y, X_train, X_test, y_train, y_test

# random forest hyper parameter grid


param_grid = {"n_estimators": np.arange(1, 100, 20),
             "max_features":np.arange(5,25,5),
             "criterion": ["gini", "entropy"]
    }

rf=RandomForestClassifier()
rf_cv = GridSearchCV(rf, param_grid, cv=5)
rf_cv.fit(X_train,y_train)

print("Tuned rf Parameters: {}".format(rf_cv.best_params_))
print("Best score is {}".format(rf_cv.best_score_))

"""
#run prediction
rf_1 = RandomForestClassifier()
rf_1.fit(X_train,y_train)

# y_predictions
y_pred = rf_1.predict(X_test)

#calculate accuracy metrics on test data set
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test,y_pred))
"""
