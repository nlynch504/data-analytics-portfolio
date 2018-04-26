#trying to determine whether a client with make a deposit ==> dependent variable

import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn import tree, metrics, datasets
from sklearn.model_selection import train_test_split, cross_val_score, RandomizedSearchCV, GridSearchCV
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import confusion_matrix, classification_report

from clean import bank_dummies, X, y, X_train, X_test, y_train, y_test

# create data model################################################
#KNN testing EDA

neighbors = np.arange(1,9)
train_acc = np.empty(len(neighbors))
test_acc = np.empty(len(neighbors))

# test different K values

for counter, values in enumerate(neighbors):
    knn = KNeighborsClassifier(n_neighbors=values)
    knn.fit(X_train, y_train)
    train_acc[counter] = knn.score(X_train, y_train)
    test_acc[counter] = knn.score(X_test, y_test)

### generate accuracy plot
plt.title('KNN: Accuracy')
plt.plot(neighbors, test_acc, label = 'Testing Accuracy')
plt.plot(neighbors, train_acc, label = 'Training Accuracy')
plt.legend()
plt.xlabel('Number of Neighbors')
plt.ylabel('Accuracy')
plt.show()


# use k = 8 for confusion matrix
knn = KNeighborsClassifier(n_neighbors=8)
knn.fit(X_train, y_train)

# y prediction on test data set
y_pred = knn.predict(X_test)

#generate confusion matrix and classfication report for accuracy metrics
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test,y_pred))

"""
###################### use hyperparameter training ##########################
# which doing cross validation , stratify on test_train_split is disabled
param_grid = {'n_neighbors':np.arange(1,5)}
knn = KNeighborsClassifier()
knn_cv = GridSearchCV(knn, param_grid, cv=5)
knn_cv.fit(X_train,y_train)
"""
print("Tuned KNN Parameters: {}".format(knn_cv.best_params_))
print("Best score is {}".format(knn_cv.best_score_))
