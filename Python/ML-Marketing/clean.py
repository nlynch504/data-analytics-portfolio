import pandas as pd
from sklearn.model_selection import train_test_split

bank_data = pd.read_csv('/Users/lynchno/Documents/Data_science_portifolio/Marketing dataset source docs/bank/bank-full.csv',sep=';',header=0)

# need to convert categorical data to numeric
copy_bank = bank_data.copy()
# see job category breakdown
#print(copy_bank.job.value_counts())

# group into smaller categories
copy_bank.job = copy_bank.job.replace(['management', 'admin.'],'white collar')
copy_bank.job = copy_bank.job.replace(['services','housemaid'],'pink collar')
copy_bank.job = copy_bank.job.replace(['student','unknown', 'retired','unemployed'],'other')

# see new job breakdown
#print(copy_bank.job.value_counts())

# consolidate loan outcomes
copy_bank.poutcome = copy_bank.poutcome.replace(['other'], 'unknown')
#print(copy_bank.poutcome.value_counts())

# drop duration per UCI website
copy_bank.drop(['duration'], axis=1, inplace=True)

#map data
# dictionary to be applied for dates
clean_up = {'month': {'jan':1, 'feb':2, 'mar':3, 'apr':4, 'may':5, 'jun':6, 'jul':7, 'aug':8, 'sep':9, 'oct':10, 'nov':11, 'dec':12},
    'default':{'yes':1, 'no':0},
    'housing':{'yes':1, 'no':0},
    'loan':{'yes':1, 'no':0},
    'y':{'yes':1, 'no':0}
}

#apply mapping
copy_bank.replace(clean_up, inplace=True)

#dummify categorical value
bank_dummies = pd.get_dummies(data=copy_bank, columns=['job', 'marital', 'education', 'contact', 'poutcome' ,], prefix = ['job', 'marital', 'education', 'contact', 'poutcome'])

# print(copy_bank.info ==> dummy generates uint8 values
# print(bank_dummies.info())

# separate dataframe into predictors and dependent numpy arrays
y = bank_dummies['y']
X = bank_dummies.drop('y', axis=1).values

# test train split

X_train, X_test, y_train, y_test = train_test_split(X, y,  test_size=0.2, random_state = 123)
