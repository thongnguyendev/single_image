function [I_in, configs]=simple(configs)
% Generates a 64-by-64 synthetic result that contains a  
% circle as transmission layer and ghosted square as reflection layer.
% See Figure 2 in the paper.

  dims=[64 64];

  I1 = drawCircle(dims(1), dims(2), 40, 40, 20)*0.4;

  I2=zeros(dims(1),dims(2));

  I2(10:50, 5:25)=0.3;

  configs.dx=15; configs.dy=7; configs.c=0.5;

  I_in = I1 + imfiltern(I2, two_pulses(configs.dx, configs.dy, configs.c));

  configs.padding=0;

  configs.match_input=0;

  configs.linear=0;

