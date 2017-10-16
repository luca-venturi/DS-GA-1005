function y = channel_noise( x, noise )
% CHANNEL_NOISE - Simulates a noisy channel with specified noise level.
%
% Brown CS242

  num_bits = numel(x);
  I_flip = rand(num_bits,1) < noise;
  y = x;
  y(I_flip) = ~y(I_flip);
end

