%
clear;

display_flag=1;
I1 = imread('Camp_IR.jpg');
I1 = im2double(I1);
I2 = imread('Camp_Vis.jpg');
I2 = im2double(I2);
[m,n] = size(I1);
l = max(m,n);
J1 = zeros(l,l);
J2 = zeros(l,l);
J1(1:m,1:n) = I1;
J2(1:m,1:n) = I2;

lpfilt = 'maxflat';

shear_parameters.dcomp =[ 1  3  4  ];
shear_parameters.dsize =[32 32 16 ];

Tscalars=[0 3 4];

%shear_version=0; %nsst_dec1e
%shear_version=1; %nsst_dec1
shear_version=2; %nsst_dec2

% compute the shearlet decompositon
if shear_version==0,
  [dst1,shear_f1]=nsst_dec1e(J1,shear_parameters,lpfilt);
  [dst2,shear_f2]=nsst_decle(J2,shear_parameters,lpfilt);
elseif shear_version==1, 
  [dst1,shear_f1]=nsst_dec1(J1,shear_parameters,lpfilt);
  [dst2,shear_f2]=nsst_dec1(J2,shear_parameters,lpfilt);
elseif shear_version==2
  [dst1,shear_f1]=nsst_dec2(J1,shear_parameters,lpfilt);
  [dst2,shear_f2]=nsst_dec2(J2,shear_parameters,lpfilt);
end

X1_1 = dst1{1};
X1_2 = dst2{1};

for i = 1:2
    X2_1{i} = dst1{2}(:,:,i);
    X2_2{i} = dst2{2}(:,:,i);
end

for i = 1:8
    X3_1{i} = dst1{3}(:,:,i);
    X3_2{i} = dst2{3}(:,:,i);
end

for i = 1:16
    X4_1{i} = dst1{4}(:,:,i);
    X4_2{i} = dst2{4}(:,:,2);
end

X1 = (X1_1+X1_2)/2;
X2(:,:,1) = max(X2_1{1},X2_2{1});
X2(:,:,2) = max(X2_2{2},X2_2{2});
for i = 1:8
    X3(:,:,i) = max(X3_1{i},X3_2{i});
end

for i = 1:16
    X4(:,:,i) = max(X4_1{i},X4_2{i});
end

dst{1} = X1;
dst{2} = X2;
dst{3} = X3;
dst{4} = X4;

% reconstruct the image from the shearlet coefficients
if shear_version==0,
    Ir=nsst_rec1(dst,lpfilt);      
elseif shear_version==1,
    Ir=nsst_rec1(dst,lpfilt);      
elseif shear_version==2,
    Ir=nsst_rec2(dst,shear_f1,lpfilt);      
end

F = Ir(1:m,1:n);
% figure,imshow(I1);
figure,imshow(F);

% D = I1-Ir;
% figure,imshow(D,[]);