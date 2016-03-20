%BPSK snr=5
clear all;
close all;
%------------------系统仿真参数
fc=2;    
Snr=5;   
fs=16; 
N=1000;   
Ts=1;  
fd=1;  
ts=1/fs;  
t=0:ts:N*Ts-ts;
t=t.';
N_sample=Ts*fs ;
%-----------画出调制信号波形及功率谱
% 产生二进制信源
B=randint(1,N);
sym=[-1;1]; 
A=sym(B+1);

H=rcosine(fd, fs,  'sqrt');
S1=upsample([A], fs/fd);
S=filter(H, 1, S1);

X1=S.*cos(2*pi*fc*t);
figure(1)
plot(t(1 :200),X1(1 :200));% 画出调制信号波形
title('调制信号波形')

scatterplot(A,16,0,'bx');
 X=awgn(X1,Snr-10*log10(fs/(2*fd)),'measured');

r=X.*cos(2*pi*fc*t);


S2=filter(H, 1, r);
S3=S2(5/fd*fs+1:end);
Sr=zeros(N,1);
for k=1:(N)
    M=S3(k*Ts*fs);
    if(M>0)
       Sr(k)=1;
    else
       Sr(k)=-1;
    end
end
A2=A(1:end-5);
biterror=sum(A2~=Sr)/(N-5);

Ber=biterror


   
