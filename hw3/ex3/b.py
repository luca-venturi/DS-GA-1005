import pyldpc
import numpy as np
from get_graph import *

N = 128
dN = 2 * 128  # Number of columns
c = 1 # Number of ones per column, must be lower than d_c (because H must have more rows than columns)
r = 2 # Number of ones per row, must divide n (because if H has m rows: m*d_c = n*d_v (compute number of ones in H))

H = pyldpc.RegularH(dN,c,r)
fg = get_graph(H)

