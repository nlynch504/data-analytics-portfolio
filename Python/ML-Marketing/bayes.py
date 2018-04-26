import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split, cross_val_score, RandomizedSearchCV, GridSearchCV
from sklearn.metrics import confusion_matrix, classification_report
from sklearn.naive_bayes import BernoulliNB

from clean import bank_dummies, X, y, X_train, X_test, y_train, y_test

# random forest hyper parameter grid

"""
param_grid = {"alpha": np.arange(0.05, 1, .1)
    }

nb=BernoulliNB()
nb_cv = GridSearchCV(nb, param_grid, cv=5)
nb_cv.fit(X_train,y_train)

print("Tuned nb Parameters: {}".format(nb_cv.best_params_))
print("Best score is {}".format(nb_cv.best_score_))"""

# best model was alpha = 0.05


#run prediction
nb_1 = BernoulliNB(alpha=0.05)
nb_1.fit(X_train,y_train)

# y_predictions
y_pred = nb_1.predict(X_test)

#calculate accuracy metrics on test data set
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test,y_pred))

