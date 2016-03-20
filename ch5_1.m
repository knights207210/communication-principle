sym=[0;1];    
Fs=64;                  %系统采样率
Fd=1;                   %符号率
N=10;
snr=10;                 %信噪比
fc=2; 
ts=1/Fs;
Ts=1; 
t=0:ts:N*Ts-ts;
t=t.';

iX=randint(N,1,sym);     %产生随机输入序列 
out=convolutionX(iX);
%------------BPSK--------------%
Bpskout=Bpsk(out);
Zout=deconvolution(Bpskout);