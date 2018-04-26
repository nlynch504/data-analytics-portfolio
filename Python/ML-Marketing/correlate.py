import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from clean import bank_dummies, X, y, X_train, X_test, y_train, y_test


# get correlation covariance after converting numerical values
df_corr = bank_dummies.corr()
df_cov = bank_dummies.cov()

"""
 correlation heat map #################################
cmap = sns.diverging_palette(200,15, as_cmap=True)
sns.heatmap(df_corr,
            xticklabels=df_corr.columns.values,
            yticklabels=df_corr.columns.values,
            cmap=cmap)
plt.plot()
plt.title('Correlation Heatmap')
plt.show()
"""
# get correlation column for deposit #################################

y_corr = pd.DataFrame(df_corr['y'])
y_corr = y_corr.sort_values(by='y', ascending=False)
print(y_corr)


