function time = my_deghost(image_path, configs, scale, gray, psize)
format shortg
begin = fix(clock);

%pre-process
fprintf('Pre-process...\n');

% Dependency on Patch-GMM prior
addpath('epllcode');                  

% Dependency on bounded-LBFGS Optimization package
addpath('lbfgsb/lbfgsb3.0_mex1.2');   

% mycode
[pathstr,name,ext] = fileparts(image_path);
out_t = strcat(pathstr, '/', name, '_t',ext);
out_r = strcat(pathstr, '/', name, '_r',ext);

I_in = im2double(imread(image_path));
d3 = size(I_in, 3);
if gray == 1 && d3 > 1
    I_in = rgb2gray(I_in);
end
if scale <= 0 || scale > 1
    print('Unavailable scale');
    return;
end
I_in = imresize(I_in, scale);
configs.dx = round(configs.dx * scale);
configs.dy = round(configs.dy * scale);
% d3 = size(I_in, 3);
% if d3 > 1
%     fprintf('Estimating ghosting kernel...\n');
%     %[configs.dx, configs.dy, configs.c] = kernel_est(I_in, threshold);
%     %load('prova00.mat')
%     %configs.dx = dx
%     %configs.dy = dy
%     %configs.c = c
%     fprintf('Est done!\n');
%     configs.padding = configs.dx + 10;
%     if configs.dx == 0 && configs.dy == 0
%         configs.c = 1;
%     end
%     fprintf('dx = %d | dy = %d | c = %f\n', configs.dx, configs.dy, configs.c);
% else
%     configs.dx = 15;
%     configs.dy = 7;
%     configs.c = 0.5;
%     configs.padding = 0;
%     configs.match_input = 0;
%     configs.linear = 0;
% end
% end

configs.padding = max(configs.dx, configs.dy) + 10;
[h, w, ~] = size(I_in);
configs.h = h;
configs.w = w;
configs.num_px = h*w;
fprintf('Pre-process done!\n');

chanels = cellstr(['red  ';'green';'blue ']);
for i = 1 : size(I_in,3) 
    fprintf('Optimize %s chanel...\n', chanels{i});
  configs.ch=i;

  % Applying our optimization to each channel independently. 
  [I_t_k, I_r_k ] = patch_gmm(I_in(:,:,i), configs, psize);
    
  fprintf('Post-process %s chanel...\n', chanels{i});
  % Post-processings to enhance the results. 
  I_t(:,:,i) = I_t_k-valid_min(I_t_k, configs.padding);
  I_r(:,:,i) = I_r_k-valid_min(I_r_k, configs.padding);
  I_t(:,:,i) = match(I_t(:,:,i), I_in(:,:,i));
end

% Write out the results.
fprintf('Write out the results...\n');
imwrite(I_t, out_t);
imwrite(I_r, out_r);
fprintf('All done!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');
time = etime(fix(clock), begin);
fprintf('Total time: %d seconds\n', time);

function deghost(test_case)

% Dependency on Patch-GMM prior
addpath('epllcode');                  

% Dependency on bounded-LBFGS Optimization package
addpath('lbfgsb/lbfgsb3.0_mex1.2');   

if strcmp(test_case, 'apples')
  % Read the input image from the linearized raw file.
  % apples.mat contains I_in. We will write it out to [0-255] for visualization.
  load('apples.mat');
  % Estimate ghosting kernel, including spatial shift configs.dx, dy 
  % and the attenuation factor configs.c.
  [configs.dx configs.dy configs.c] = kernel_est(I_in);

  % Set up padding size. 
  %The padding size needs to be larger than the spatial shift.
  configs.padding = 40;
else                    % Check the environment by testing on synthetic data. 
   
  [I_in configs] = simple([]);
  dx = configs.dx;
  dy = configs.dy;
  c  = configs.c;
end

[h w nc] = size(I_in);
configs.h = h;
configs.w = w;
configs.num_px = h*w;

for i = 1 : size(I_in,3) 
  configs.ch=i;

  % Applying our optimization to each channel independently. 
  [I_t_k I_r_k ] = patch_gmm(I_in(:,:,i), configs);

  % Post-processings to enhance the results. 
  I_t(:,:,i) = I_t_k-valid_min(I_t_k, configs.padding);
  I_r(:,:,i) = I_r_k-valid_min(I_r_k, configs.padding);
  I_t(:,:,i) = match(I_t(:,:,i), I_in(:,:,i));
end

% Write out the results.
imwrite(I_in, 'in.png');
imwrite(I_t, 't.png');
imwrite(I_r, 'r.png');

function [I_t, I_r ] = patch_gmm(I_in, configs, psize)
% Setup for patch-based reconstruction 
h = configs.h;
w = configs.w;
c = configs.c;
dx = configs.dx;
dy = configs.dy;

% Identity matrix
Id_mat = speye(h*w, h*w); 

% Ghosting kernel K
k_mat = get_k(h, w, dx, dy, c); 

% Operator that maps an image to its ghosted version
A = [Id_mat k_mat]; 
 
lambda = 1e6; 

% patch size for patch-GMM
% psize = 16;

num_patches = (h-psize+1)*(w-psize+1);

mask=merge_two_patches(ones(psize^2, num_patches),...
            ones(psize^2, num_patches), h, w, psize);

% Use non-negative constraint
configs.non_negative = true;

% Parameters for half-quadratic regularization method
configs.beta_factor = 2;
configs.beta_i = 200;
configs.dims = [h w];

% Setup for GMM prior
load GSModel_8x8_200_2M_noDC_zeromean.mat
excludeList=[];
%noiseSD=25/255;

% Initialization, may takes a while. 
fprintf('Init...\n');
[I_t_i, I_r_i ] = grad_irls(I_in, configs);
% faster option, but results are not as good.
% [I_t_i I_r_i ] = grad_lasso(I_in, configs);


% Apply patch gmm with the initial result.
% Create patches from the two layers.
est_t = im2patches(I_t_i, psize);
est_r = im2patches(I_r_i, psize);

niter = 25;
beta  = configs.beta_i;

fprintf('Optimizing...\n');
for i = 1 : niter
  fprintf('Optimizine iter %d of %d...\n', i, niter);
  % Merge the patches with bounded least squares
  f_handle = @(x)(lambda * A'*(A*x) + beta*(mask.*x));
  sum_piT_zi = merge_two_patches(est_t, est_r, h, w, psize);
  sum_zi_2 = norm(est_t(:))^2 + norm(est_r(:))^2;
  z = lambda * A'*I_in(:) + beta * sum_piT_zi; 

  % Non-neg. optimization by L-BFGSB
  opts    = struct( 'factr', 1e4, 'pgtol', 1e-8, 'm', 50);
  opts.printEvery     = 50;
  l = zeros(numel(z),1);
  u = ones(numel(z),1);

  fcn = @(x)( lambda * norm(A*x - I_in(:))^2 + ...
      beta*( sum(x.*mask.*x - 2 * x.* sum_piT_zi(:)) + sum_zi_2));
  grad = @(x)(2*(f_handle(x) - z));
  fun     = @(x)fminunc_wrapper( x, fcn, grad); 
  [out, ~, info] = lbfgsb(fun, l, u, opts );

  out = reshape(out, h, w, 2);
  I_t = out(:,:,1); 
  I_r = out(:,:,2); 

  % Restore patches using the prior
  est_t = im2patches(I_t, psize);
  est_r = im2patches(I_r, psize);
  noiseSD=(1/beta)^0.5;
  [est_t, t_cost]= aprxMAPGMM(est_t,psize,noiseSD,[h w], GS,excludeList);
  [est_r, r_cost]= aprxMAPGMM(est_r,psize,noiseSD,[h w], GS,excludeList);

  beta = beta*configs.beta_factor;

end

function out = merge_two_patches(est_t, est_r, h, w, psize)
  % Merge patches and concat
  t_merge = merge_patches(est_t, h, w, psize);
  r_merge = merge_patches(est_r, h, w, psize);
  out = cat(1, t_merge(:), r_merge(:));

function out = match(i,ex)
  % Match the global color flavor to 
  sig = sqrt(sum((ex-mean(ex(:))).^2)/sum((i-mean(i(:))).^2));
  out = sig*(i-mean(i(:))) + mean(ex(:)); 
  out = out;


