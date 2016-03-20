clear all;
close all;
echo on
%------------------系统仿真参数
fc=2; %载波频率（Hz）
snr=5; %信噪比dB
fs=16;% 系统采样率
N=1000; %  码元数
Ts=1; % 码元宽度
B=1/Ts; % 波特率
ts=1/fs; % 系统采样间隔
t=0:ts:N*Ts-ts;
t=t.';
Lt=length(t);
N_sample=Ts*fs ;
%-----------画出调制信号波形及功率谱
% 产生二进制信源
B=randint(1,N);
sym=[-1;1]; 
A=sym(B+1);
P=sum(abs(sym).^2)/length(sym);
std_v=sqrt(P/10^(snr/10))
A1=A+randn(size(A))*std_v;
S=rectpulse(A1, N_sample);
X=S.*cos(2*pi*fc*t);
figure(1)
plot(t(1 :200),X(1 :200));% 画出调制信号波形
r=X.*cos(2*pi*fc*t)
Sr=zeros(1,N);
H=rectpulse(1, N_sample);
for k=1:N
Sr(k)=sum(r((k-1)*N_sample+1:k*N_sample).*rectpulse(1, ...
N_sample)); 
end
Br=Sr>0;
errbit=sum(Br~=B);
ber=errbit/N; % 误码率