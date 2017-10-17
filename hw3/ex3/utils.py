from my_loopy_bp import *
import pyldpc as pl
import itertools as itt

def get_factor_potential(dv):
	tmp = np.ones(tuple([2 for _ in range(dv)]))
	index = itt.product(range(2), repeat=dv)
	for i in index:
		tmp[i] = np.float(1 - (sum(list(i)) % 2))
	if int(np.sum(tmp)) == 0: #
		print("error") #
	return tmp

def get_graph(H):
	
	(N,dN) = H.shape
	dv = int(sum(H[0,:]))
	
	# Create factor graph
	fg = graphs.FactorGraph()
	
	# Create variable nodes
	vNodes = []
	for n in range(dN):
		vNodes.append( nodes.VNode('v' + str(n)) )
	
	# Create factor nodes    
	fNodes = []
	for n in range(N):
		fNodes.append( nodes.FNode('f' + str(n)) )
	
	# Add nodes to factor graph
	fg.set_nodes([vNodes[n] for n in range(dN)])
	fg.set_nodes([fNodes[n] for n in range(N)])
	
	# Add edges to factor graph
	for v in range(dN):
		for f in range(N):
			if H[f,v] == 1:
				fg.set_edge(vNodes[v], fNodes[f])
	
	# Add potentials
	for f in fg.get_fnodes():
		tmp = get_factor_potential(dv) ##
		tmpx = nx.all_neighbors(fg, f)
		f.factor = rv.Discrete(tmp,*tmpx)
	
	return fg

def get_variable_number(v):
	return int(v.__str__()[1:])

def get_unary_potential(msg,eps,n):
	x = msg[n]
	tmp = np.zeros((2))
	tmp[int(x)] = 1 - eps 
	tmp[1-int(x)] = eps
	return tmp

def add_unary_factor(fg,msg,eps):
	# Create unary factor nodes
	dN = msg.size
	ufNodes = []
	for n in range(dN):
		ufNodes.append( nodes.FNode('uf' + str(n)) ) 
	fg.set_nodes([ufNodes[n] for n in range(dN)])
	# Add edges
	for v in fg.get_vnodes():
		n = get_variable_number(v)
		uf = ufNodes[n]
		fg.set_edge(v, uf)
	# Add potentials
	for v in fg.get_vnodes():
		n = get_variable_number(v)
		uf = ufNodes[n]
		tmp = get_unary_potential(msg,eps,n)
		uf.factor = rv.Discrete(tmp,v)
	return fg

def get_pcm(N,dv,dc):
	return pl.RegularH(2*N,dv,dc)

def get_invalid_codework(H):
	dN = H.shape[1]
	msg = np.zeros((dN))
	msg[np.argwhere(H[0,:])[0][0]] = 1
	return msg

def get_nodes(fg,f):
	tmp = nx.all_neighbors(fg,f)
	return np.sort([get_variable_number(v) for v in tmp])

def get_factor(fg,v):
	tmp = 1.
	for f in fg.get_fnodes():
		factor = f.factor.pmf
		nodes = get_nodes(fg,f)
		index = tuple([int(v[i]) for i in nodes])
		tmp *= 1. - factor[index]
	return tmp
		
def transmit_msg(msg,eps):
	dN = msg.size
	corrupted_msg = []
	for n in range(dN):
		corrupt = np.random.choice([0,1],p=[1-eps,eps])
		corrupted_msg.append((1-msg[n])*corrupt+msg[n]*(1-corrupt))
	return np.array(corrupted_msg)

def get_potential(fg,nIter=50):
	vnodes = fg.get_vnodes()	
	dN = len(vnodes)
	tmp = np.zeros((2,dN))
	bel = get_beliefs(fg, nIter, vnodes)
	for [v,b] in bel:
		nv = get_variable_number(v)
		tmp[:,nv] = b.pmf
	return np.array(tmp)

def estimate_msg(pot):
	dN = pot.shape[1]
	tmp = []
	for n in range(dN):
		tmp.append(np.argmax(pot[:,n]))
	return tmp

def Hamming_distance(v,w):
	return sum(np.abs(np.array(v)-np.array(w)))
