
function [img_direct] = poisson_solver_function(gx,gy,boundary_image);

% TODO: write a sparse version

% function [img_direct] = poisson_solver_function(gx,gy,boundary_image)
% Inputs; Gx and Gy -> Gradients
% Boundary Image -> Boundary image intensities
% Gx Gy and boundary image should be of same size


% Based on the paper by
% @article{simchony_pami90,
% author = "Simchony, T. and Chellappa, R. and Shao, M.",
% title = "Direct Analytical Methods for solving poisson equations in computer vision problems",
% journal = PAMI,
% year = "1990",
% pages = "435--446",
% volume = "12",
% number = "5",
% month = may,
% }



[H,W] = size(boundary_image);
[H1,W1] = size(gx);
[H2,W2] = size(gy);

if(H~=H1 | H1~=H2 | W~=W1 | W1~=W2)
    error('Size of gx,gy and boundary images is not same');
end



gxx = zeros(H,W);
gyy = zeros(H,W);
f = zeros(H,W);
j = 1:H-1;
k = 1:W-1;

% Laplacian
gyy(j+1,k) = gy(j+1,k) - gy(j,k);
gxx(j,k+1) = gx(j,k+1) - gx(j,k);
f = gxx + gyy;


clear j k gxx gyy gyyd gxxd

% boundary image contains image intensities at boundaries
boundary_image(2:end-1,2:end-1) = 0;

%disp('2D Integration');
j = 2:H-1;
k = 2:W-1;
f_bp = zeros(H,W);
f_bp(j,k) = -4*boundary_image(j,k) + boundary_image(j,k+1) + boundary_image(j,k-1) + boundary_image(j-1,k) + boundary_image(j+1,k);
clear j k

f1 = f - reshape(f_bp,H,W);% subtract boundary points contribution
clear f_bp f

% DST algo starts here
f2 = f1(2:end-1,2:end-1);
clear f1

%compute sine transform
tt = dst(f2);
f2sin = dst(tt')';
clear f2

%compute eigen values
[x,y] = meshgrid(1:W-2,1:H-2);
denom = (2*cos(pi*x/(W-1))-2) + (2*cos(pi*y/(H-1)) - 2) ;

%divide
f3 = f2sin./denom;
clear f2sin x y

%compute inverse sine transform
tt = idst(f3);
clear f3

img_tt = idst(tt')';
clear tt


%disp('Done...');

% put solution in inner points; outer points obtained from boundary image
img_direct = boundary_image;
img_direct(2:end-1,2:end-1) = 0;
img_direct(2:end-1,2:end-1) = img_tt;

