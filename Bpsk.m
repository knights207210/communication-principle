function Sr=Bpsk(X)
%BPSK snr=5
%------------------系统仿真参数
fc=2;    
Snr=5;   
fs=16; 
N=length(X);
Ts=1;  
fd=1;  
ts=1/fs;  
t=0:ts:N*Ts-ts;
t=t.';
N_sample=Ts*fs ;
%-----------画出调制信号波形及功率谱
% 产生二进制信源 
sym=[-1;1]; 
A=sym(X+1);
H=rcosine(fd, fs,  'sqrt');
S1=upsample([A], fs/fd);
S=filter(H, 1, S1);

X1=S.*cos(2*pi*fc*t);
figure
plot(t(1 :200),X1(1 :200));% 画出调制信号波形
title('调制信号波形')

 X3=awgn(X1,Snr-10*log10(fs/(2*fd)),'measured');

r=X3.*cos(2*pi*fc*t);


S2=filter(H, 1, r);
%S3=S2(5/fd*fs+1:end);
Sr=zeros(N,1);
for k=1:N
    M=S2(k*Ts*fs);
    if(M>0)
       Sr(k)=1;
    else
       Sr(k)=0;
    end
end
end

