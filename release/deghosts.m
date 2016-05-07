scale=input('Input scale for image: ');

load('synthetic_43.mat');
fprintf('Starting deghost synthetic_43 (20 images)...\n');
for i=1:20
    fprintf('Starting deghost prova_%s...\n', int2str(i));
    my_deghost(synthetic(i).name, synthetic(i).configs, scale);
end

load('synthetic_54.mat');
fprintf('Starting deghost synthetic_54 (20 images)...\n');
for i=1:20
    fprintf('Starting deghost prova_%s...\n', int2str(i));
    my_deghost(synthetic(i).name, synthetic(i).configs, scale);
end