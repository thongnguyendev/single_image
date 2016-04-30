function [I_t_k I_r_k configs] = grad_lasso(I_in, configs)
% IRLS on gradient domain
% Under cannoical LASSO expression 
% z:=[tx;ty]
%     argmin |z|_p
% s.t. [ Id | k ]z = Ix;
% Use  separable or non-separable weights


  dx=configs.dx;
  dy=configs.dy;
  c=configs.c;
  dims=configs.dims;
  num_px=configs.num_px;
  k=configs.ch;

  configs.eps=1e-4;
  configs.p=1;
  configs.niter=20;
  configs.lambda=1e-8;
  configs.non_sep=0;
  configs.alpha=0.1;
  configs.wt = 1.0; 
  configs.wc = abs(imfilter(imfilter(I_in, fspecial('gaussian', [6 6], 1)), [0 -1 0; -1 4 -1; 0 -1 0])).^3*0+1; 

  mk = get_k(configs.h, configs.w, dx, dy, c);
  Id = speye(num_px);

  I_x=imfilter(I_in, [-1 1]);
  I_y=imfilter(I_in, [-1; 1]);

  out_xi=I_x; out_yi=I_y;

  wcs = spdiags(configs.wc(:), 0, num_px, num_px);
  z0 = [I_x(:); I_x(:)*0];
  z = lasso(z0, [wcs*Id wcs*mk], wcs*I_x(:), configs, []);
  out_x = reshape(z(1:num_px), dims);
  outr_x = reshape(z(num_px+1:end), dims);

  z0 = [I_y(:);I_y(:)*0];
  z = lasso(z0, [Id mk], I_y(:), configs, []);
  out_y = reshape(z(1:num_px), dims);
  outr_y = reshape(z(num_px+1:end), dims);

  I_t_k=Integration2D(out_x, out_y, I_in);
  I_r_k=Integration2D(outr_x, outr_y, I_in);
  I_t_k = I_t_k-min(min(I_t_k(:), 0));
  I_r_k = I_r_k-min(min(I_r_k(:), 0));

