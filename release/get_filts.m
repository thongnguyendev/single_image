function kernels= get_filts(configs)
% Return a bunch of normalized filtrs

  kernels={};
  k=1;
  if configs.gradients 
    g=zeros(3); g(2,2)=1;
    base=conv2(g,[-1 1], 'same');
    bank = steerable_filters(base, configs.gradients, 'nearest');
    %bank = mult_kernels(bank, 2);
    kernels=cat(2, kernels, bank);
  end
  if configs.grad_diag % Legacy
    kernels{k} = [-1 0;0 1]/2; k=k+1;
    kernels{k} = [0 -1; 1 0]/2; k=k+1;
  end
  if configs.laplacian
    %kernels{k} = [-1 2 -1]/4; k=k+1;
    %kernels{k} = [-1; 2 ; -1]/4; k=k+1;
    g=zeros(5); g(3,3)=1;
    base=conv2(g,[-1 2 -1], 'same');
    bank = steerable_filters(base, configs.laplacian, 'nearest');
    kernels=cat(2, kernels, bank);
  end
  if configs.lap_diag % Legacy
    kernels{k} = [-1 0 0;0 2 0;0 0 -1]/4; k=k+1;
    kernels{k} = [0 0 -1;0 2 0; -1 0 0]/4; k=k+1;
  end
  if configs.haar
    %kernels{k} = [-1 1; 1 -1]/4; k=k+1;
    base=zeros(4); 
    base(2:3,2:3)=[-1 1 ; 1 -1];
    bank = steerable_filters(base, configs.haar, 'nearest');
    %bank = mult_kernels(bank, 0.2);
    kernels=cat(2, kernels, bank);
  end
  if configs.g3
    kernels{k} = repmat([-1  1], [3 1])/6; k=k+1;
    kernels{k} = repmat([-1 ; 1], [1 3])/6; k=k+1;
  end 
  if configs.g5
    kernels{k} = repmat([-1  1], [5 1])/10; k=k+1;
    kernels{k} = repmat([-1 ; 1], [1 5])/10; k=k+1;
  end 

  if configs.g7
    kernels{k} = repmat([-1  1], [7 1])/14; k=k+1;
    kernels{k} = repmat([-1 ; 1], [1 7])/14; k=k+1;
  end 
  if configs.ddog
    %g = get_gaussian( 1.6,3.5, 0);
    g = get_gaussian( 0.6,2.5, 0);
    base=conv2(g,[-1 1], 'same');
    bank = steerable_filters(base, configs.ddog, 'bilinear');
    kernels=cat(2, kernels, bank);
  end

function kernels = steerable_filters(base, num_banks, interp)
  k=1;
  for i = 0 : num_banks-1 
    theta = 180/num_banks*i;
    filt =  imrotate(base, theta, interp);
    filt = filt/sqrt(sum(filt(:).^2))/(num_banks);
    kernels{k} = filt; k=k+1;
  end
 
function kernels = mult_kernels(kernels, g)
  for i = 1 : length(kernels)
    kernels{i}=kernels{i}*g;
  end

  
function out = get_gaussian(sx, sy, theta)

hsize = ceil(3*max(sx, sy))+1;
out=zeros(2*hsize+1);
for i = -hsize : hsize
  for j = -hsize : hsize
    out(i+hsize+1, j+hsize+1) = exp(-((i*sin(theta)+j*cos(theta))/2/sx)^2-((-i*cos(theta)+j*sin(theta))/2/sy)^2);
  end
end

 
