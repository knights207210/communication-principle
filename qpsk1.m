%QPSK snr=5
clear all;
close all;
%------------------系统仿真参数
fc=2;    
snr=5;   
fs=16; 
N=10000;   
Ts=1;  
fd=1;  
ts=1/fs;  
t=0:ts:N*Ts-ts;

N_sample=Ts*fs ;
%-----------画出调制信号波形及功率谱
% 产生二进制信源
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
sinv=sin(2*pi*fc*t);

X1=C1.*cos(2*pi*fc*t)+C2.*sin(2*pi*fc*t);

figure(1)

plot(t(1 :200),X1(1 :200)); 
X2= S1+1i*S2;
scatterplot(X2,16,0,'bx');
X=awgn(X1,snr-10*log10(fs/(4*fd)),'measured');

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
biterror=sum(B1~=ber)/(N-5)/2
        
