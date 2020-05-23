function R=PCNN_withParameters(matrix,Para)

% Calulate the firing times of neurons in PCNN
% Please set the Para as follows:
% Parameters for PCNN
% Para.iterTimes=200;
% Para.link_arrange=3;
% Para.alpha_L=1;% 0.06931 Or 1
% Para.alpha_Theta=0.2;
% Para.beta=3;% 0.2 or 3
% Para.vL=1.0;
% Para.vTheta=20;

%=============================================================
% disp('PCNN is processing...')
%=============================================================
% get the parameters of PCNN
link_arrange=Para.link_arrange;
np=Para.iterTimes;
alpha_L=Para.alpha_L;
alpha_Theta=Para.alpha_Theta ;
beta=Para.beta;
vL=Para.vL;
vTheta=Para.vTheta;
%=============================================================
[p,q]=size(matrix);
F_NA=abs(matrix);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize the parameters. 
% You'd better change them according to your applications 
% alpha_L=1;
% alpha_Theta=0.2;
%  beta=3;
% vL=1.00;
% vTheta=20;
% Generate the null matrix that could be used
L=zeros(p,q);
U=zeros(p,q);
Y=zeros(p,q);
Y0=zeros(p,q);
Theta=zeros(p,q);
% Compute the linking strength.
center_x=round(link_arrange/2);
center_y=round(link_arrange/2);
W=zeros(link_arrange,link_arrange);
for i=1:link_arrange
    for j=1:link_arrange
        if (i==center_x)&&(j==center_y)
            W(i,j)=0;
        else
            W(i,j)=1./sqrt((i-center_x).^2+(j-center_y).^2);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
F=F_NA;
for n=1:np
    K=conv2(Y,W,'same');
    L=exp(-alpha_L)*L+vL*K;
    Theta=exp(-alpha_Theta)*Theta+vTheta*Y;
    U=F.*(1+beta*L);
    Y=im2double(U>Theta);
    Y0=Y0+Y;   
end
R=Y0;