% scale=input('Input scale for image: ');
% try
%     diary('log_2.4.13.14_rgb.txt');
%     scale = 1;
% 
%     load('synthetic.mat');
%     fprintf('Starting deghost synthetic (20 images)...\n');
%     ii = [2 4 13 14];
%     for i=1:4
%         fprintf('Starting deghost prova_%s...\n', int2str(ii(i)));
%         time = my_deghost(synthetic(ii(i)).name, synthetic(ii(i)).configs, scale, 0);
%     end
%     fprintf('Done!!!!!!!!!!!!!!!!!');
%     diary off
%     system('shutdown -s');
% catch
%     fprintf('Error\n');
%     diary off
%     system('shutdown -s');
% end
% load('synthetic_54.mat');
% fprintf('Starting deghost synthetic_54 (20 images)...\n');
% for i=1:20
%     fprintf('Starting deghost prova_%s...\n', int2str(i));
%     my_deghost(synthetic(i).name, synthetic(i).configs, scale);
% end


try
    diary('log_hcmus_rgb.txt');
    scale = 1;
    configs.dx = 20;
    configs.dy = 30;
    configs.c = 0.69;
    fprintf('Starting deghost hcmus1...\n');
    time = my_deghost('us1.png', configs, scale, 0);
    configs.dx = 15;
    configs.dy = 20;
    configs.c = 0.5;
    fprintf('Starting deghost hcmus2...\n');
    time = my_deghost('us2.png', configs, scale, 0);
%     end
    fprintf('Done!!!!!!!!!!!!!!!!!');
    diary off
catch
    fprintf('Error\n');
    diary off
end