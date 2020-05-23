% ----------
% Author: Wei Tan
% E-mail: twtanwei1992@163.com; wtan@stu.xidian.edu.cn
% "Multi-modal medical image fusion algorithm in the era of big data",
% Submitted to Neural Computing & Applications
% This code is only used for research.
% Please cite this publication if you use this code.

clear;
clc;
close all;

%
path(path,'nsst_toolbox')


Imr = imread('MRI.png');
Ipe = imread('PET.png');

I1 = im2double(Imr);
I1 = rgb2gray(I1);
IpeRGB = im2double(Ipe);
I3 = rgb2hsv(IpeRGB);
I2 = I3(:,:,3);
[m,n] = size(I1);
l = max(m,n);
J1 = zeros(l,l);
J2 = zeros(l,l);
J1(1:m,1:n) = I1;
J2(1:m,1:n) = I2;

%% Parameters for NSST
lpfilt = 'maxflat';
shear_parameters.dcomp =[ 4  4  3  3];
shear_parameters.dsize =[32 32 16 16];

%% Initialize Parameters for PCNN
Para.iterTimes=200;
Para.link_arrange=7;
Para.alpha_L=0.02;
Para.alpha_Theta=3;
Para.beta=3;
Para.vL=1;
Para.vTheta=20;

%%
disp('Decompose the image via nsst ...')
[dst1,shear_f1]=nsst_dec2(J1,shear_parameters,lpfilt);
[dst2,shear_f2]=nsst_dec2(J2,shear_parameters,lpfilt);

% Lowpass subband
disp('Process in Lowpass subband...')

X1_1= dst1{1};
X1_2 =dst2{1};

% EA strategy
mB1 = mean(X1_1(:));
mB2 = mean(X1_2(:));
MB1 = median(X1_1(:));
MB2 = median(X1_2(:));
G1 = (mB1+MB1)/2;
G2 = (mB2+MB2)/2;

w1 = zeros(m,n);
w2 = zeros(m,n);
a = 4;
t = 3;
for i = 1:m
    for j = 1:n
        w1(i,j) = exp(a*abs(X1_1(i,j)-G1));
        w2(i,j) = exp(a*abs(X1_2(i,j)-G2));
        WB1(i,j) = w1(i,j)/(w1(i,j)+w2(i,j));
        WB2(i,j) = w2(i,j)/(w1(i,j)+w2(i,j));
    end
end

X1 = zeros(l,l);
for i = 1:m
    for j = 1:n
        X1(i,j) = WB1(i,j)*X1_1(i,j)+WB2(i,j)*X1_2(i,j);
    end
end

dst{1} = X1;

% Bandpass subbands
disp('Process in  Bandpass subbands...')

for i = 1:16
    X2_1{i} = dst1{2}(:,:,i);
    X2_2{i} = dst2{2}(:,:,i);
end

for i = 1:16
    X2(:,:,i) = fusion_NSST_MSMG_PCNN(X2_1{i},X2_2{i},Para,t);
end

for i = 1:16
    X3_1{i} = dst1{3}(:,:,i);
    X3_2{i} = dst2{3}(:,:,i);
end

for i = 1:16
    X3(:,:,i) = fusion_NSST_MSMG_PCNN(X3_1{i},X3_2{i},Para,t);
end

for i = 1:8
    X4_1{i} = dst1{4}(:,:,i);
    X4_2{i} = dst2{4}(:,:,i);
end

for i = 1:8
    X4(:,:,i) = fusion_NSST_MSMG_PCNN(X4_1{i},X4_2{i},Para,t);
end

for i = 1:8
    X5_1{i} = dst1{5}(:,:,i);
    X5_2{i} = dst2{5}(:,:,i);
end

for i = 1:8
    X5(:,:,i) = fusion_NSST_MSMG_PCNN(X5_1{i},X5_2{i},Para,t);
end

dst{2} = X2;
dst{3} = X3;
dst{4} = X4;
dst{5} = X5;

% Reconstruction
Ir=nsst_rec2(dst,shear_f1,lpfilt);

Fi = Ir(1:m,1:n);
I3(:,:,3)=Fi;
FF = hsv2rgb(I3);

figure,imshow(FF);



