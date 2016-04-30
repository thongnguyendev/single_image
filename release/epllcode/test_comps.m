function  test_comps(X, covs)
   

d = size(X,1);
num_comp = size(covs,3);

Rs = zeros(d, d, num_comp);

tic;
for i = 1 : num_comp
  R = chol(covs(:,:,i));
  R = inv(R');
  Rs(:,:,i) = R; 
end
Rs = reshape(Rs, [d*num_comp d]);
toc

tic;
%for i = 1 : num_comp
  q = sum((Rs*X).^2,1);  % quadratic term (M distance)
%end
toc
%foo2 = bsxfun(@times, foo1, Ds_inv); 
%q = sum(foo2,1);
  
