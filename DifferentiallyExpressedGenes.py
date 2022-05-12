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
