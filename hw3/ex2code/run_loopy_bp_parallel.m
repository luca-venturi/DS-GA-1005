function [G, iters] = run_loopy_bp_parallel( G, max_iters, conv_tol )
% RUN_LOOPY_BP - Runs Loopy Belief Propagation (Sum-Product) on a factor 
%   Graph given by 'G'.This implements a "parallel" updating scheme in
%   which all factor-to-variable messages are updated in a single clock
%   cycle, and then all variable-to-factor messages are updated.
%
% Inputs:
%   G: Factor graph to perform loopy BP over
%   max_iters: Maximum number of iterations to run loopy BP for
%   conv_tol:  Convergence tolerance (threshold on max message change)
%
% Outputs:
%   G: The factor graph, with messages. Note that G will be passed to
%      get_beliefs.m to compute the node marginals.
%
%   iters: How many iterations it took for loopy BP to converge
%
% Brown CS242
  
  % Main Loop
  for iters = 1:max_iters
    % FILL ME IN!
  end
end

