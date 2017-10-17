from utils import *
from my_loopy_bp import *

# (a)

N = 8
H = get_pcm(N,1,2)
fg = get_graph(H)
inv_msg = get_invalid_codework(H)
print('PROBABILITY OF INVALID CODEWORD: %f'%get_factor(fg,inv_msg))
