function configs =  kernel_est(I_in, threshold, sign_dx, sign_dy) 

  I_in = rgb2gray(I_in);
  Laplacian=[0 -1 0; -1 4 -1; 0 -1 0];
  resp = imfilter(I_in, Laplacian);
  auto_corr = xcorr2(resp, resp);
  [m, n] = size(auto_corr);
  bdry = 1; % floor(min(m, n) * 0.4); %0.4625
  auto_corr = auto_corr(bdry:end-bdry, bdry:end-bdry);
  
  max_1 = ordfilt2(auto_corr, 25, true(5));
  max_2 = ordfilt2(auto_corr, 24, true(5));
  auto_corr(fix(end/2) - 4 : fix(end/2) + 4, fix(end/2) : fix(end/2) + 4) = 0;
  candidates = find((auto_corr == max_1) & ((max_1 - max_2) > threshold));
  candidates_val = auto_corr(candidates);

  cur_max = 0;
  dx = 0; 
  dy = 0;
  offset = size(auto_corr)/2 + 1;
  for i = 1 : length(candidates)
    if (candidates_val(i) > cur_max)  
      [dy, dx] = ind2sub(size(auto_corr), candidates(i)); 
      dy = dy - offset(1);
      dx = dx - offset(2);
      cur_max = candidates_val(i);
    end
  end
  if (dx * sign_dx < 0)
      dx = dx * -1;
  end
  if (dy * sign_dy < 0)
      dy = dy * -1;
  end
  c = est_attenuation(I_in, dx, dy);
  configs.dx = dx;
  configs.dy = dy;
  configs.c = c;
%   d1 = 0;
%   d2 = 0;
%   c = 0;
%   c = est_attenuation(I_in, dx, dy);
%   if c1 < 1 && c1 > c
%       d1 = dx; d2 = dy; c = c1;
%   end
%   c2 = est_attenuation(I_in, -dx, dy);
%   if c2< 1 && c2 > c
%       d1 = -dx; d2 = dy; c = c2;
%   end
%   c3 = est_attenuation(I_in, dx, -dy);
%   if c3 < 1 && c3 > c
%       d1 = dx; d2 = -dy; c = c3;
%   end
%   c4 = est_attenuation(I_in, -dx, -dy);
%   if c4 < 1 && c4 > c
%       d1 = -dx; d2 = -dy; c = c4;
%   end
%   dx = d1; dy = d2;