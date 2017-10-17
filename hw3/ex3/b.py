from utils import *
from my_loopy_bp import *

# (b)

N = 128
dN = N * 2
H = get_pcm(N,4,8)
fg = get_graph(H)
eps = 0.05
msg = np.zeros((dN))
sent_msg = transmit_msg(msg,eps)
print('MESSAGE SENT (CORRUPTED):')
print(sent_msg)
print('NUMBER OF CORRUPTED BIT = %d'%np.sum(sent_msg))
fg = add_unary_factor(fg,sent_msg,eps)
pot = get_potential(fg,nIter=50)
print('POSTERIOR P(x_n=1):')
print(pot[1,:])
decoded_msg = estimate_msg(pot)
print('HAMMING DISTANCE d(SENT,DECODED) = %d'%Hamming_distance(msg,decoded_msg))
