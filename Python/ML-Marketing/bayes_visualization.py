import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split, cross_val_score, RandomizedSearchCV, GridSearchCV
from sklearn.metrics import confusion_matrix, classification_report
from sklearn.naive_bayes import BernoulliNB

from clean import bank_dummies, X, y, X_train, X_test, y_train, y_test

estimators = np.arange(0.05, 1, .1)
train_acc = np.empty(len(estimators))
test_acc = np.empty(len(estimators))

for counter, values in enumerate(estimators):
    nb = BernoulliNB(alphana=values)
    nb.fit(X_train, y_train)
    train_acc[counter] = nb.score(X_train, y_train)
    test_acc[counter] = nb.score(X_test, y_test)

plt.title('Naive Bayes Bernoulli  : Accuracy')
plt.plot(estimators, test_acc, label = 'Testing Accuracy')
plt.plot(estimators, train_acc, label = 'Training Accuracy')
plt.legend()
plt.xlabel('Alpha')
plt.ylabel('Accuracy')
plt.show()
