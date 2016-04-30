function [I_t I_r configs]=grad_irls(I_in, configs)

  dx=configs.dx;
  dy=configs.dy;
  c=configs.c;
  configs.dims=[size(I_in,1) size(I_in,2)];
  dims=configs.dims;

  configs.delta=1e-4;
  configs.p=0.2;
  configs.use_lap=1;
  configs.use_diagnoal=1;
  configs.use_lap2=1;
  configs.use_cross=0;
  configs.niter=20;

  mk = get_k(configs.h, configs.w, dx, dy, c);
  mh = inv(mk);

  mx = get_fx(configs.h, configs.w);
  my = get_fy(configs.h, configs.w);

  mu = get_fu(configs.h, configs.w);
  mv = get_fv(configs.h, configs.w);

  mlap = get_lap(configs.h, configs.w);

  k=configs.ch;
  I_x=imfilter(I_in, [-1 1]);
  I_y=imfilter(I_in, [-1; 1]);

  out_xi=I_x/2; out_yi=I_y/2;

  out_x=irls_grad(I_x, [], out_xi, mh, configs, mx, my,  mu, mv, mlap);
  outr_x = reshape(mh*(I_x(:)-out_x(:)), dims);

  out_y=irls_grad(I_y, [], out_yi, mh, configs, mx, my, mu, mv, mlap);
  outr_y = reshape(mh*(I_y(:)-out_y(:)), dims);

  I_t=Integration2D(out_x, out_y, I_in);
  I_r=Integration2D(outr_x, outr_y, I_in);
