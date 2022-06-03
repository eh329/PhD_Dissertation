"""
Implementation of microarray analysis from 
WIBR Bioinformatics and Research Computing

http://barc.wi.mit.edu/education/arrays/
"""

from itertools import product
from scipy.stats import f_oneway
from statsmodels.stats.multicomp import pairwise_tukeyhsd

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
%matplotlib inline
sns.set()


# Read the data

data = pd.read_csv("file.csv")
df = data.copy()
df.head()

# Look at the columns

df.columns

# Columns information

df.info()

# Drop the unnecessary columns 
# Drop the rows with NaN values
# Drop the duplicated values

df.drop(["Probe Set ID", "Unigene(Avadis)", "Entrez Gene", "GO(Avadis)"], axis = 1, inplace = True)
df.dropna(axis = 0, inplace = True)
df.drop_duplicates("Gene Title", inplace = True)
df.shape

# Columns basic statistics

df.describe().T

df.reset_index(inplace = True)
del df["index"]
df.head()


# Checking the distribution of the raw gene expression with histograms

cols = df.drop(["Gene Symbol", "Gene Title"], axis = 1).columns
col_list = list(cols)

for feature in col_list:
    df[feature].plot(figsize = (12, 5), title = feature,
                xlabel = "Gene Index",
                ylabel = "Gene Expression")
    plt.show()

    
# Checking the distribution of the log10 of gene expression with histograms

for feature in col_list:
    df[feature].plot(logy = True, figsize = (12, 5), title = feature,
                xlabel = "Gene Index",
                ylabel = "Gene Expression")
    plt.show()

    
# Creating a new dataset with normalized data (global median method):
#     Divide values of each colum by the median of the same column

init_df = df[["Gene Symbol", "Gene Title"]].copy()

for col in col_list:
    median = df[col].median(axis = 0)
    col_name = col + " norm"
    init_df[col_name] = df[col].div(df[col].median(axis = 0)) 

init_df.head()

init_df.to_csv("normalized_columns.csv", index = False)

# Start working with the normalized values

norm_data = pd.read_csv("normalized_columns.csv")
norm_data.head()

norm_data.describe()


# Forming a new dataset by:
#    adding all the replicates to each other and calculating the mean
#    using the mean as the final value 
#    reducing the number of the columns into half

init_norm = norm_data[["Gene Symbol", "Gene Title"]].copy()

init_norm["SS Th0"] = norm_data[["SS1 Th0 norm", "SS2 Th0 norm"]].mean(axis = 1)
init_norm["SS Th0 Dex"] = norm_data[["SS1 Th0 Dex norm", "SS2 Th0 Dex norm"]].mean(axis = 1)
init_norm["SS Th17"] = norm_data[["SS1 Th17 norm", "SS2 Th17 norm"]].mean(axis = 1)
init_norm["SS Th17 Dex"] = norm_data[["SS1 Th17 Dex norm", "SS2 Th17 Dex norm"]].mean(axis = 1)

init_norm["SR Th0"] = norm_data[["SR1 Th0 norm", "SR2 Th0 norm", "SR3 Th0 norm"]].mean(axis = 1)
init_norm["SR Th0 Dex"] = norm_data[["SR1 Th0 Dex norm", "SR2 Th0 Dex norm", "SR3 Th0 Dex norm"]].mean(axis = 1)
init_norm["SR Th17"] = norm_data[["SR1 Th17 norm", "SR2 Th17 norm", "SR3 Th17 norm"]].mean(axis = 1)
init_norm["SR Th17 Dex"] = norm_data[["SR1 Th17 Dex norm", "SR2 Th17 Dex norm", "SR3 Th17 Dex norm"]].mean(axis = 1)


init_norm.head()

init_norm.to_csv("reduced_norm_col.csv", index = False)

reduced_col = pd.read_csv("reduced_norm_col.csv")
reduced_col.head()

reduced_col.describe()

# Dividing each column with Dex to the corresponding column without it
# Then transfer the values to their coressponding log2 values

ratio_log = reduced_col[["Gene Symbol", "Gene Title"]].copy()

ratio_log["SS Th0 Dex/Th0 Log"] = np.log2(reduced_col["SS Th0 Dex"].div(reduced_col["SS Th0"]))
ratio_log["SS Th17 Dex/Th17 Log"] = np.log2(reduced_col["SS Th17 Dex"].div(reduced_col["SS Th17"]))
ratio_log["SR Th0 Dex/Th0 Log"] = np.log2(reduced_col["SR Th0 Dex"].div(reduced_col["SR Th0"]))
ratio_log["SR Th17 Dex/Th17 Log"] = np.log(reduced_col["SR Th17 Dex"].div(reduced_col["SR Th17"]))

ratio_log.head()

ratio_log.describe()

ratio_log.to_csv("ratio_log.csv", index = False)

last = pd.read_csv("ratio_log.csv")
last.head()

last.columns

anova_df = last[last['SR Th17 Dex/Th17 Log'] > last['SS Th17 Dex/Th17 Log']]
anova = anova_df[['SS Th0 Dex/Th0 Log',
       'SS Th17 Dex/Th17 Log', 'SR Th0 Dex/Th0 Log', 'SR Th17 Dex/Th17 Log']]

anova.head()


anova_val = anova.values
rows = range(anova_val.shape[0])
cols = range(anova_val.shape[1])
f_stat = []
p_val = []

for i, j in product(rows, cols):
    f, p = f_oneway(anova_val[i,:], anova_val[:,j])
    f_stat.append(f)
    p_val.append(p)

    
# Adding f statistics and p value for the calculation as column
# Adding the p value f

anova_df["f statistics"] = pd.Series(f_stat)
anova_df["anova p value"] = pd.Series(p_val)
anova_df.head()

anova_df.to_csv("Final_File.csv", index = False)

deg_df = pd.read_csv("Final_File.csv")
deg = deg_df.copy()
deg.head()


