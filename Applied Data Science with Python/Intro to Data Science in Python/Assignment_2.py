# -*- coding: utf-8 -*-
"""
Created on Sat Jun 30 21:26:45 2018

@author: james
"""

import pandas as pd

df = pd.read_csv('olympics.csv', index_col=0, skiprows=1)

for col in df.columns:
    if col[:2]=='01':
        df.rename(columns={col:'Gold'+col[4:]}, inplace=True)
    if col[:2]=='02':
        df.rename(columns={col:'Silver'+col[4:]}, inplace=True)
    if col[:2]=='03':
        df.rename(columns={col:'Bronze'+col[4:]}, inplace=True)
    if col[:1]=='№':
        df.rename(columns={col:'#'+col[1:]}, inplace=True)

names_ids = df.index.str.split('\s\(') # split the index by '('

df.index = names_ids.str[0] # the [0] element is the country name (new index) 
df['ID'] = names_ids.str[1].str[:3] # the [1] element is the abbreviation or ID (take first 3 characters from that)

df = df.drop('Totals')
df.head()


def answer_one():
    return df.loc[df['Gold'].idxmax()].name
answer_one()


def answer_two():
    return (df['Gold'] - df['Gold.1']).idxmax()
answer_two()


def answer_three(): 
    new_df = df.where((df['Gold'] > 0) | (df['Gold.1'] > 0))
    return ((new_df['Gold'] - new_df['Gold.1']) / new_df['Gold.2']).idxmax()
answer_three()


def answer_four():
    
    p = []
    for i in df.index:
        g = df.loc[i]['Gold.1'] * 3
        s = df.loc[i]['Silver.1'] * 2
        b = df.loc[i]['Bronze.1']
        p.append(g + s + b)
        
    Points = pd.Series(data = p, index= df.index)
    return Points
answer_four()


census_df = pd.read_csv('census.csv')
census_df.head()


def answer_five():
    cnty = census_df[['SUMLEV', 'STNAME','CTYNAME']]
    cnty = cnty[cnty['SUMLEV'] == 50].groupby('STNAME').count()
    return cnty['CTYNAME'].idxmax()
answer_five()




