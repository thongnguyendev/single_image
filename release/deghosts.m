load('synthetic_43.mat');
fprintf('Starting deghost synthetic 43 (20 images)...\n');
for i=1:20
    fprintf('Starting deghost prova_%s...\n', int2str(i));
    my_deghost(synthetic(i).name, synthetic(i).configs);
end

load('synthetic_54.mat');
fprintf('Starting deghost synthetic 54 (20 images)...\n');
for i=1:20
    fprintf('Starting deghost prova_%s...\n', int2str(i));
    my_deghost(synthetic(i).name, synthetic(i).configs);
end