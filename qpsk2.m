
%QPSK 误码率曲线
clear all;
close all;
%------------------系统仿真参数
fc=2;    
snr=-10:0.4:12;
fs=16; 
N=80000;   
Ts=1;  
fd=1;  
ts=1/fs;  
t=0:ts:N*Ts-ts;

N_sample=Ts*fs ;
Ber=size(snr);
pe=size(snr);
%-----------画出调制信号波形及功率谱
% 产生二进制信源
for j=1:length(snr)
    Snr=snr(j);
B=randint(1,N,[1 4]);
 
f=sqrt(2)/2;
sc=[1,-1,-1,1]*f;
ss=[-1,-1,1,1]*f;
A1=sc(B);
A2=ss(B);
 
S1=upsample(A1,N_sample);
S2=upsample(A2,N_sample);
H=rcosine(fd, fs, 'sqrt');
C1=filter(H,1,S1);
C2=filter(H,1,S2);

X1=C1.*cos(2*pi*fc*t)+C2.*sin(2*pi*fc*t);
X=awgn(X1,Snr-10*log10(fs/(4*fd)),'measured');


r1=X.*cos(2*pi*fc*t);
Sr1=filter(H,1,r1);
Sr1=Sr1(5/fd*fs+1:end);

r2=X.*sin(2*pi*fc*t);
Sr2=filter(H,1,r2);
Sr2=Sr2(5/fd*fs+1:end);

ber1=zeros(1,N-5);
ber2=zeros(1,N-5);
for k=1:(N-5)
    M=Sr1(k*Ts*fs);
    if(M>0)
        ber1(k)=1;
    else
        ber1(k)=0;
    end
    
      M=Sr2(k*Ts*fs);
    if(M>0)
        ber2(k)=1;
    else
        ber2(k)=0;
    end
end

D=[2,1,3,4];
ber=D(ber1+ber2*2+1);

B1=B(1:end-5);
biterror=sum(B1~=ber)/(N-5)/2;
Ber(j)=biterror;
ber0(j)=1/2*erfc(sqrt(10^(Snr/10)));
end
figure(1);
semilogy(snr,Ber);
hold on
semilogy(snr,ber0,'r');
