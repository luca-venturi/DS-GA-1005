function G = init_ldpc_graph( H, y, theta )
% INIT_LDPC_GRAPH - Creates a factor graph from a codebook H, noisy data y,
%   and binomial noise parameter 1-theta.
%
% Brown CS242

  G = init_graph();
    
  % FILL IN THE REST OF THE CODE!
  % add factor and variable nodes using the add_varnode and add_facnode
  % functions. The implementation of loopy bp you are given
  % (run_loopy_bp_parallel.m) assumes that you added factors and variables
  % to the graph using these functions.
end
