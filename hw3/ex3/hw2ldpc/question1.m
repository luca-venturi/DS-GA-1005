% RUN_DECODER - This is the main driver script for generating a random
%   codebook, sampling from a noisy channel, and running LBP inference.
%
% Brown CS242

clear variables;

% parameters
max_iters = 50;
conv_tol = 1e-6;

%% QUESTION 1b %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\nQuestion 1b:\n');
load('ldpc36-128.mat', 'G', 'H');
num_bits = size(G, 1);
noise = 0.05;
codeWord = zeros(num_bits, 1);

% generate data    
noisyCodeWord = channel_noise(codeWord, noise);
F = init_ldpc_graph( H, noisyCodeWord, 1-noise );
fprintf('\nActual error %0.3f\n', sum(codeWord ~= noisyCodeWord) / numel(noisyCodeWord));

% Run Parallel Loopy BP
tic;
[F, iters] = run_loopy_bp_parallel(F, max_iters, conv_tol);
t = toc;
nodeMarg_par = get_beliefs(F);
if iters < max_iters,
  fprintf('Parallel LBP converged in %d iterations.', iters);
else
  fprintf('Parallel LBP did not converge.  Terminated at %d iterations.', max_iters);
end
fprintf('\n%0.3f Seconds.\n', t);

% show bitwise marginal probabilities of each codeword bit
figure;
marg_mat = reshape( cell2mat( nodeMarg_par ), [2,num_bits] );
plot( 1:num_bits, marg_mat(2,:), '.-b', 'LineWidth', 1 );
xlim([0, num_bits]);
title('Bitwise Marginal Probability p(x_i=1)');
xlabel('Bit #');
ylabel('p(x_i=1)');

clear codeWord noisyCodeWord F iters noise

%% QUESTION 1c %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\nQuestion 1c:');
num_runs = 10;
noise = 0.06;

codeWord = zeros(num_bits, 1);

% err_mat(i,j): stores the hamming distance for run i at iteration j
err_mat = zeros(num_runs, max_iters);

longest = 0;
for m = 1:num_runs
  fprintf('\n\n## Run %d ##', m);  

  % generate data    
  noisyCodeWord = channel_noise(codeWord, noise);
  F = init_ldpc_graph( H, noisyCodeWord, 1-noise );
  fprintf('\nActual error %0.3f\n', sum(codeWord ~= noisyCodeWord) / numel(noisyCodeWord));

  % Run Parallel Loopy BP
  tic;
  [F, iters] = run_loopy_bp_parallel(F, max_iters, conv_tol);
  t = toc;
  nodeMarg_par = get_beliefs(F);
  if iters < max_iters,
    fprintf('Parallel LBP converged in %d iterations.', iters);
  else
    fprintf('Parallel LBP did not converge.  Terminated at %d iterations.', max_iters);
  end
  fprintf('\n%0.3f Seconds.\n', t);

  % determine code
  decoded = estimate_code( nodeMarg_par );
  ham_dist = sum( decoded ~= codeWord );
  fprintf('\nHamming Distance: %d', ham_dist);
  fprintf('\nError After Correction: %0.3f', ham_dist / numel(noisyCodeWord));

  % store error at each iteration of this run
  for(it=1:iters)
      decoded  = estimate_code( F.nodeMargs{it} );
      err_mat(m,it) = sum( decoded ~= codeWord );
  end
  if iters < max_iters
    err_mat(m,(iters+1):end) = err_mat(m,iters);
  end
  
  % longest run (for plotting)
  if longest < iters
    longest = iters;
  end
end

% plot
figure;
hold on;
for m=1:num_runs
  plot( 1:max_iters, err_mat(m,:), '-b' );
end
hold off;
xlabel('Iteration #');
ylabel('Hamming Distance');
xlim([1 min(max_iters, longest+1)]);
title(['Channel Noise ', num2str(noise)]);

clear codeWord noisyCodeWord F iters noise longest


%% QUESTION 1d %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use modified code from 1c

%% QUESTION 1e %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\nQuestion 1e:\n');
load('ldpc36-1600.mat', 'G', 'H', 'logo');
num_bits = size(G, 1);
max_iters = 30;

% generate data 
noise = 0.06;  
w = reshape( logo, [ prod(size(logo)), 1 ] );
codeWord = mod(double(G) * w, 2);
noisyCodeWord = channel_noise(codeWord, noise);
F = init_ldpc_graph( H, noisyCodeWord, 1-noise );
fprintf('\nActual error %0.3f\n', sum(codeWord ~= noisyCodeWord) / numel(noisyCodeWord));

% Run Parallel Loopy BP
tic;
[F, iters] = run_loopy_bp_parallel(F, max_iters, conv_tol);
t = toc;
%nodeMarg_par = get_beliefs(F);
if iters < max_iters,
  fprintf('Parallel LBP converged in %d iterations.', iters);
else
  fprintf('Parallel LBP did not converge.  Terminated at %d iterations.', max_iters);
end
fprintf('\n%0.3f Seconds.\n', t);

% plot
plotAtIters = [ 0, 1, 2, 3, 5, 10, 20, 30 ];
figure();
for indx=1:numel(plotAtIters)
  i = plotAtIters(indx);
  subplot(2,4,indx);
  
  if i==0
    thisX = noisyCodeWord;
  elseif i > length(F.nodeMargs)
    thisX = estimate_code(F.nodeMargs{end});
  else
    thisX = estimate_code(F.nodeMargs{i});
  end
  
  msg = reshape( thisX(1:1600), [40,40] );
  par = reshape( thisX(1601:end), [40,40] );
  im = [msg; par];
  imshow( im );  
  xlabel(sprintf('Iter %d', i));
end

clear noise noisyCodeWord codeWord F iters


%% QUESTION 1f %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use modified code from 1e
