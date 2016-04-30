function patches = im2patches(im, psize)

[h w]=size(im);
num_patches = (h-psize+1)*(w-psize+1);
patches = zeros(num_patches, psize^2);

k=1;
for j = 1 : psize
  for i = 1 : psize
    patches(:,k) = reshape(im(i:i+h-psize,j:j+w-psize), num_patches,1);
    k=k+1;
  end
end

patches = patches';



