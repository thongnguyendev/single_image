function y = loggausspdf3(X, sigma)
% Approx. log gauss by Eigen value decomp. and eigen vector thresholding

d = size(X,1);

[R,p]= chol(sigma);
if p ~= 0
    error('ERROR: sigma is not SPD.');
end

phi = R';
q1 = sum((phi\X).^2,1);  % quadratic term (M distance)

[V D] = eig(sigma);
D_inv = 1./diag(D);
num_eig = 64;
foo1 = (V(:,1:num_eig)' * X).^2; 
foo2 = bsxfun(@times, foo1, D_inv(1:num_eig)); 
q = sum(foo2,1);

%sum(abs(q1-q))/sum(abs(q1))

%c = d*log(2*pi)+2*sum(log(diag(R)));   % normalization constant
c = d*log(2*pi)+sum(log(1./D_inv));   % normalization constant
y = -(c+q)/2;
