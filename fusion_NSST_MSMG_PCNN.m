function cp=fusion_NSST_MSMG_PCNN(matrixA,matrixB,Para,t)

%%
MSMG_A=multiscale_morph(abs(matrixA),t);
MSMG_B=multiscale_morph(abs(matrixB),t);

%%
PCNN_timesA=PCNN_withParameters(MSMG_A,Para);
PCNN_timesB=PCNN_withParameters(MSMG_B,Para);
map=(PCNN_timesA>=PCNN_timesB);

%%
cp=map.*matrixA+~map.*matrixB;