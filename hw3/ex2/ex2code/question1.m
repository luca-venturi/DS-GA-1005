% HW1 Question 1
%
% Brown CS242

clear variables

%% QUESTION 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% brute force marginals
G = make_debug_graph();
nodeMarg = marg_brute_force(G);

% Run Parallel Loopy BP
clear G; 
G = make_debug_graph();

max_iters = 500;
conv_tol = 1e-6;
% TODO: Implement BP by modifying run_loopy_bp_parallel.m and get_beliefs.m
[G, iters] = run_loopy_bp_parallel(G, max_iters, conv_tol);
nodeMarg_par = get_beliefs(G);

if iters < max_iters,
  fprintf('\nParallel LBP converged in %d iterations.', iters);
else
  fprintf('Parallel LBP did not converge.  Terminated at %d iterations.', max_iters);
end

% Plot
figure();
D = belief_diff( nodeMarg, nodeMarg_par );
bar( D );
xlabel('Node Index');
ylabel('Symmetric L1 Distance');
title('Serial LBP vs. Brute Force');


