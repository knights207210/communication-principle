sym=[0;1];    
Fs=64;                  %ϵͳ������
Fd=1;                   %������
N=10;
snr=10;                 %�����
fc=2; 
ts=1/Fs;
Ts=1; 
t=0:ts:N*Ts-ts;
t=t.';

iX=randint(N,1,sym);     %��������������� 
out=convolutionX(iX);
%------------BPSK--------------%
Bpskout=Bpsk(out);
Zout=deconvolution(Bpskout);