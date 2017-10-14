% HW1 Question 2
%
% Brown CS242

%TODO: Must implement and test loopy BP (question 1) first

%% QUESTION 2a %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear variables;
max_iters = 500; conv_tol = 1e-6;

G = make_alarm_graph_partA();

% brute force marginals
nodeMarg = marg_brute_force(G);

% Run Parallel Loopy BP
[G, iters] = run_loopy_bp_parallel(G, max_iters, conv_tol);
[nodeMarg_par] = get_beliefs(G);
if iters < max_iters,
  fprintf('\nParallel LBP converged in %d iterations.\n', iters);
else
  fprintf('\nParallel LBP did not converge.  Terminated at %d iterations.\n', max_iters);
end

% Get IDs and output expected values
varName = {'PULMEMBOLUS','INTUBATION','VENTTUBE','KINKEDTUBE'};
for ii = 1:length(varName)
  varID(ii) = get_varid(G, varName{ii});
  fprintf('E[ %s ] = %0.3f\n', varName{ii}, ...
    [1:numel(nodeMarg_par{varID(ii)})] * nodeMarg_par{varID(ii)});
end

% Plot
figure('InvertHardcopy','off','Color',[1 1 1])
D = belief_diff( nodeMarg, nodeMarg_par );
bar(D(varID));
xlabel('Node Index');
ylabel('Symmetric L1 Distance');
title('Serial LBP vs. Brute-Force Beliefs');
set(gca, 'XTickLabel', varName);

%% QUESTION 2b %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear variables;
max_iters = 500; conv_tol = 1e-6;

G = make_alarm_graph_partA();
% TODO: Call add_evidence() to condition on observed variables

% brute force marginals
nodeMarg = marg_brute_force(G);

% Run Parallel Loopy BP
[G, iters] = run_loopy_bp_parallel(G, max_iters, conv_tol);
[nodeMarg_par] = get_beliefs(G);
if iters < max_iters,
  fprintf('\nParallel LBP converged in %d iterations.\n', iters);
else
  fprintf('\nParallel LBP did not converge.  Terminated at %d iterations.\n', max_iters);
end

% Get IDs and output expected values
varName = {'PULMEMBOLUS','INTUBATION','VENTTUBE','KINKEDTUBE'};
for ii = 1:length(varName)
  varID(ii) = get_varid(G, varName{ii});
  fprintf('E[ %s ] = %0.3f\n', varName{ii}, ...
    [1:numel(nodeMarg_par{varID(ii)})] * nodeMarg_par{varID(ii)});
end

% Plot
figure('InvertHardcopy','off','Color',[1 1 1])
D = belief_diff( nodeMarg, nodeMarg_par );
bar(D(varID));
xlabel('Node Index');
ylabel('Symmetric L1 Distance');
title('Serial LBP vs. Brute-Force Beliefs');
set(gca, 'XTickLabel', varName);

%% QUESTION 2c %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear variables;
max_iters = 500; conv_tol = 1e-6;

G = make_alarm_graph_partC();

% brute force marginals
nodeMarg = marg_brute_force(G);

% Run Parallel Loopy BP
[G, iters] = run_loopy_bp_parallel(G, max_iters, conv_tol);
[nodeMarg_par] = get_beliefs(G);
if iters < max_iters,
  fprintf('\nParallel LBP converged in %d iterations.\n', iters);
else
  fprintf('\nParallel LBP did not converge.  Terminated at %d iterations.\n', max_iters);
end

% Get IDs and output expected values
varName = {'INTUBATION','VENTTUBE','KINKEDTUBE','VENTLUNG'};
for ii = 1:length(varName)
  varID(ii) = get_varid(G, varName{ii});
  fprintf('E[ %s ] = %0.3f\n', varName{ii}, ...
    [1:numel(nodeMarg_par{varID(ii)})] * nodeMarg_par{varID(ii)});
end

% Plot
figure('InvertHardcopy','off','Color',[1 1 1])
D = belief_diff( nodeMarg, nodeMarg_par );
bar(D(varID));
xlabel('Node Index');
ylabel('Symmetric L1 Distance');
title('Serial LBP vs. Brute-Force Beliefs');
set(gca, 'XTickLabel', varName);

%% QUESTION 2e %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear variables;
max_iters = 500; conv_tol = 1e-6;

G = make_alarm_graph();
% TODO: If necessary, call add_evidence() to condition on observed variables

% Run Parallel Loopy BP
[G, iters] = run_loopy_bp_parallel(G, max_iters, conv_tol);
[nodeMarg_par] = get_beliefs(G);
if iters < max_iters,
  fprintf('\nParallel LBP converged in %d iterations.\n', iters);
else
  fprintf('\nParallel LBP did not converge.  Terminated at %d iterations.\n', max_iters);
end

% Get IDs and output expected values
varName = {'LVFAILURE','ANAPHYLAXIS','INSUFFANESTH','PULMEMBOLUS','DISCONNECT'};
for ii = 1:length(varName)
  varID(ii) = get_varid(G, varName{ii});
  fprintf('E[ %s ] = %0.3f\n', varName{ii}, ...
    [1:numel(nodeMarg_par{varID(ii)})] * nodeMarg_par{varID(ii)});
end

%% QUESTION 2f %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear variables;
max_iters = 500; conv_tol = 1e-6;

G = make_alarm_graph();
% TODO: If necessary, call add_evidence() to condition on observed variables

% Run Parallel Loopy BP
[G, iters] = run_loopy_bp_parallel(G, max_iters, conv_tol);
[nodeMarg_par] = get_beliefs(G);
if iters < max_iters,
  fprintf('\nParallel LBP converged in %d iterations.\n', iters);
else
  fprintf('\nParallel LBP did not converge.  Terminated at %d iterations.\n', max_iters);
end

% Get IDs and output expected values
varName = {'LVFAILURE','ANAPHYLAXIS','INSUFFANESTH','PULMEMBOLUS','DISCONNECT'};
for ii = 1:length(varName)
  varID(ii) = get_varid(G, varName{ii});
  fprintf('E[ %s ] = %0.3f\n', varName{ii}, ...
    [1:numel(nodeMarg_par{varID(ii)})] * nodeMarg_par{varID(ii)});
end

%% QUESTION 2g %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear variables;
max_iters = 500; conv_tol = 1e-6;

G = make_alarm_graph();
% TODO: If necessary, call add_evidence() to condition on observed variables

% Run Parallel Loopy BP
[G, iters] = run_loopy_bp_parallel(G, max_iters, conv_tol);
[nodeMarg_par] = get_beliefs(G);
if iters < max_iters,
  fprintf('\nParallel LBP converged in %d iterations.\n', iters);
else
  fprintf('\nParallel LBP did not converge.  Terminated at %d iterations.\n', max_iters);
end

% Get IDs and output expected values
varName = {'LVFAILURE','HYPOVOLEMIA','ANAPHYLAXIS','INSUFFANESTH',...
  'PULMEMBOLUS','INTUBATION','DISCONNECT','KINKEDTUBE'};
for ii = 1:length(varName)
  varID(ii) = get_varid(G, varName{ii});
  fprintf('E[ %s ] = %0.3f\n', varName{ii}, ...
    [1:numel(nodeMarg_par{varID(ii)})] * nodeMarg_par{varID(ii)});
end

%% QUESTION 2h %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear variables;
max_iters = 500; conv_tol = 1e-6;

G = make_alarm_graph();
% TODO: If necessary, call add_evidence() to condition on observed variables

% Run Parallel Loopy BP
[G, iters] = run_loopy_bp_parallel(G, max_iters, conv_tol);
[nodeMarg_par] = get_beliefs(G);
if iters < max_iters,
  fprintf('\nParallel LBP converged in %d iterations.\n', iters);
else
  fprintf('\nParallel LBP did not converge.  Terminated at %d iterations.\n', max_iters);
end

% Get IDs and output expected values
varName = {'LVFAILURE','HYPOVOLEMIA','ANAPHYLAXIS','INSUFFANESTH',...
  'PULMEMBOLUS','INTUBATION','DISCONNECT','KINKEDTUBE'};
for ii = 1:length(varName)
  varID(ii) = get_varid(G, varName{ii});
  fprintf('E[ %s ] = %0.3f\n', varName{ii}, ...
    [1:numel(nodeMarg_par{varID(ii)})] * nodeMarg_par{varID(ii)});
end

%% QUESTION 2i %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear variables;
max_iters = 500; conv_tol = 1e-6;

G = make_alarm_graph();
% TODO: If necessary, call add_evidence() to condition on observed variables

% Run Parallel Loopy BP
[G, iters] = run_loopy_bp_parallel(G, max_iters, conv_tol);
[nodeMarg_par] = get_beliefs(G);
if iters < max_iters,
  fprintf('\nParallel LBP converged in %d iterations.\n', iters);
else
  fprintf('\nParallel LBP did not converge.  Terminated at %d iterations.\n', max_iters);
end

% Get IDs and output expected values
varName = {'LVFAILURE','HYPOVOLEMIA','ANAPHYLAXIS','INSUFFANESTH',...
  'PULMEMBOLUS','INTUBATION','DISCONNECT','KINKEDTUBE'};
for ii = 1:length(varName)
  varID(ii) = get_varid(G, varName{ii});
  fprintf('E[ %s ] = %0.3f\n', varName{ii}, ...
    [1:numel(nodeMarg_par{varID(ii)})] * nodeMarg_par{varID(ii)});
end

