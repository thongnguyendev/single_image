load('images.mat');

for i=10:19
    fprintf('Starting deghost prova (%s)...\n', image(i).name);
    my_deghost(image(i).name, image(i).configs);
end