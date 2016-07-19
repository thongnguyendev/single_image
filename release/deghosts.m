% scale=input('Input scale for image: ');
try
    diary('log_else_rgb.txt');
    scale = 1;

    load('synthetic.mat');
    fprintf('Starting deghost synthetic (15 images)...\n');
    ii = [1 3 5 6 7 9 10 11 12 15 16 17 18 19 20];
    for i=1:15
        fprintf('Starting deghost prova_%s...\n', int2str(ii(i)));
        [time, T, R] = my_deghost(synthetic(ii(i)).name, synthetic(ii(i)).configs, scale, 0);
    end
    fprintf('Done!!!!!!!!!!!!!!!!!');
    diary off
    system('shutdown -s');
catch
    fprintf('Error\n');
    diary off
    system('shutdown -s');
end


% try
%     diary('log_hcmus_rgb.txt');
%     scale = 1;
%     configs.dx = 20;
%     configs.dy = 30;
%     configs.c = 0.69;
%     fprintf('Starting deghost hcmus1...\n');
%     time = my_deghost('us1.png', configs, scale, 0);
%     configs.dx = 15;
%     configs.dy = 20;
%     configs.c = 0.5;
%     fprintf('Starting deghost hcmus2...\n');
%     [time, T, R] = my_deghost('us2.png', configs, scale, 0);
% %     end
%     fprintf('Done!!!!!!!!!!!!!!!!!');
%     diary off
% catch
%     fprintf('Error\n');
%     diary off
% end