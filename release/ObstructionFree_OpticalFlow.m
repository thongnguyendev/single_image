function [time, I_background, I_obstruction] = ObstructionFree_OpticalFlow( input, gray, scale, max_frame)
% OBSTRUCTION FREE PHOTOGRAPHY
%Implementation by Michela Testolina
%Data Hiding course
%2016

%-------------Initialization-------------%
fprintf('Initialization...\n');
mkdir('./frames');
mkdir('./edges');
mkdir('./backgrounds');
mkdir('./obstructions');
format shortg
begin = fix(clock);
video=VideoReader(input);
numTotFrames=get(video,'numberOfFrames');


%extract the reference frame (a frame in the middel, to have a shorter motion vector -> more precise)
fprintf('extract the reference frame...\n');
refIndex = floor(numTotFrames / 2) + 1;
fprintf('refIndex = %d\n', refIndex);
refFrame = imresize(read(video, refIndex), scale);
I1=refFrame;
if gray == 1
    I1 = rgb2gray(I1);
end
[rows, columns, numberOfColorChannels] = size(I1); %Get dimentions
for i = 1 : numberOfColorChannels
    I1_edge(:,:,i)=im2double(edge(I1(:,:,i),'Canny', 0.1));
end
filename=['./frames/' num2str(refIndex) '.png'];
imwrite(I1,filename);
filename=['./edges/' num2str(refIndex) '.png'];
imwrite(I1_edge,filename);
%Initialize the background
for i = 1 : numberOfColorChannels
    I_background(:,:, i) = ones(rows, columns);
end
I_background = im2uint8(I_background);

skip = 1;
if numTotFrames > max_frame
    skip = floor(numTotFrames / max_frame) + 1;
end
for k = 1 : skip : numTotFrames  %Extract a frame
    numFrame = k;
    if k~=refIndex
        fprintf('executing frame %d...\n', k);
        I2 = imresize(read(video, k), scale);
        if gray == 1
            I2 = rgb2gray(I2);
        end
        filename=['./frames/' num2str(numFrame) '.png'];
        imwrite(I2,filename);
        
        for i = 1 : numberOfColorChannels
            I2_edge(:,:,i)=im2double(edge(I2(:,:,i),'Canny', 0.1));
        end
        filename=['./edges/' num2str(numFrame) '.png'];
        imwrite(I2_edge,filename);
        for i = 1 : numberOfColorChannels
            [I_B, I_O] = Decompose_One_Color_Chanel(I1(:, :, i), I1_edge(:, :, i), I2(:, :, i), I2_edge(:, :, i), I_background(:, :, i));
            I_background(:, :, i) = I_B;
            I_obstruction(:, :, i) = I_O;
        end        
%       figure; imshowpair(uint8(I_background),I_obstruction,'montage');
        filename=['./backgrounds/' num2str(numFrame) '.png'];
        imwrite(uint8(I_background),filename);
        filename=['./obstructions/' num2str(numFrame) '.png'];
        imwrite(I_obstruction,filename);
    end
end
time = etime(fix(clock), begin);
fprintf('Total time: %d seconds\n', time);
end

