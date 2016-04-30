function xo=lasso(xi, A, y, configs, tx);
% Solving argmin |y-Ax|^2 + lambda * |x|_p --(1)
% if use_alpha_map: |y-Ax|^2 + alpha.*|x|_p --(2)
% xi  : initial estimation
% A, x: see Eq. (1)
% tx  : true x, used for reporting error.
% xo  : outpout x

  num_elements=length(xi);
  Id = speye(size(A,1));

  x=xi; 
  w=ones(num_elements,1);
  W = spdiags(1./w(:), 0, num_elements, num_elements);  

  for i = 1 : configs.niter
    w = (x.^2 + configs.eps).^(configs.p/2-1); 
    w = w.*[configs.wt*ones(configs.num_px,1) ; ones(configs.num_px,1)];

    W = spdiags(1./w(:), 0, num_elements, num_elements);  
    x = W*A'*( (configs.lambda*Id + A*W*A')\y);
  end
  xo=x;

