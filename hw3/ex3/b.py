import pyldpc
import numpy as np
from get_graph import *

N = 128
dN = 2 * 128  # Number of columns
c = 1 # Number of ones per column
r = 2 # Number of ones per row

H = pyldpc.RegularH(dN,c,r)
fg = get_graph(H)
