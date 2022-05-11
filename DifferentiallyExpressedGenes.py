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
