import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split, cross_val_score, RandomizedSearchCV, GridSearchCV
from sklearn.metrics import confusion_matrix, classification_report
from sklearn.ensemble import RandomForestClassifier

from clean import bank_dummies, X, y, X_train, X_test, y_train, y_test

estimators = np.arange(1,100, 10)
train_acc = np.empty(len(estimators))
test_acc = np.empty(len(estimators))

for counter, values in enumerate(estimators):
    rf = RandomForestClassifier(n_estimators=values, max_features=10, criterion='gini')
    rf.fit(X_train, y_train)
    train_acc[counter] = rf.score(X_train, y_train)
    test_acc[counter] = rf.score(X_test, y_test)

plt.title('RF : Accuracy')
plt.plot(estimators, test_acc, label = 'Testing Accuracy')
plt.plot(estimators, train_acc, label = 'Training Accuracy')
plt.legend()
plt.xlabel('Number of Decision trees')
plt.ylabel('Accuracy')
plt.show()
