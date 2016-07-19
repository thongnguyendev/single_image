path = 'synthetic_data/prova_';
gtpath = 'synthetic_data/groud_truth/prova_';
diary('log_ssim.txt');
for i=1:20
    img = imread([path int2str(i) '_t.png']);
    gtimg = imread([gtpath int2str(i) '.png']);
    [m1,n1,~] = size(img);
    [m2,n2,~] = size(gtimg);
    img = imresize(img, [min(m1, m2) min(n1, n2)]);
    gtimg = imresize(gtimg, [min(m1, m2) min(n1, n2)]);
    s = ssim(img(:,:,1), gtimg(:,:,1));
    s = s + ssim(img(:,:,2), gtimg(:,:,2));
    s = s + ssim(img(:,:,3), gtimg(:,:,3));
    s = s/3;
    fprintf('ssim prova_%d = %f\n', i, s);
end
fprintf('Done!!!!!!!!!!!!!!!!!');
diary off