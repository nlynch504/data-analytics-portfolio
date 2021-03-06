# -*- coding: utf-8 -*-
"""gdp_cap

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1orShmQNF_f9CdoZvWpfZfpws1akEq2oK
"""

#install necessary libraries
!pip install -q xlrd
import xlrd
import pandas as pd
from google.colab import files



#grab gdp excel docs from https://www.gapminder.org/data/
gdp_url = 'https://docs.google.com/spreadsheet/pub?key=phAwcNAVuyj1jiMAkmq1iMg&output=xlsx'

#import file
#gdp is from 1800 to 2015
gdp = pd.read_excel(gdp_url, sheet_name = 'Data', header = 0, index_col = False)

# need tranpose columns
gdp.set_index('GDP per capita',inplace=True)
trans_gdp = gdp.transpose()

#reset indices

trans_gdp = trans_gdp.reset_index()

#melt data frame
melt_gdp = pd.melt(trans_gdp, id_vars = 'index', var_name = 'Country', value_name = 'GDP per capita')

#reset indexes prior to merging data frames
melt_gdp = melt_gdp.set_index('index')

#rename indices
melt_gdp.index.names = ['Year']
melt_gdp = melt_gdp.reset_index().dropna()

# create csv to be used in sql merge
"""
print(melt_gdp.info())
melt_gdp.to_csv('gap_gdp.csv', sep=",", index=False)
files.download('gap_gdp.csv')
"""
