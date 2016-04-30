function out = merge_patches(patches, h, w, psize)
% Merge patches (in vector form)
% patches needs to be psize^2 x (h-psize+1)*(w-psize+1)

patches = reshape(patches', h-psize+1, w-psize+1, psize^2); 

out = zeros(h, w);
k=1;
for j = 1 : psize 
  for i = 1 : psize
    out(i:i+h-psize, j:j+w-psize) = out(i:i+h-psize, j:j+w-psize) + patches(:,:,k); 
    k=k+1;
  end
end


