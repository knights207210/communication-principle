clear all;
close all;
echo on
%------------------ϵͳ�������
fc=2; %�ز�Ƶ�ʣ�Hz��
snr=5; %�����dB
fs=16;% ϵͳ������
N=1000; %  ��Ԫ��
Ts=1; % ��Ԫ���
B=1/Ts; % ������
ts=1/fs; % ϵͳ�������
t=0:ts:N*Ts-ts;
t=t.';
Lt=length(t);
N_sample=Ts*fs ;
%-----------���������źŲ��μ�������
% ������������Դ
B=randint(1,N);
sym=[-1;1]; 
A=sym(B+1);
P=sum(abs(sym).^2)/length(sym);
std_v=sqrt(P/10^(snr/10))
A1=A+randn(size(A))*std_v;
S=rectpulse(A1, N_sample);
X=S.*cos(2*pi*fc*t);
figure(1)
plot(t(1 :200),X(1 :200));% ���������źŲ���
r=X.*cos(2*pi*fc*t)
Sr=zeros(1,N);
H=rectpulse(1, N_sample);
for k=1:N
Sr(k)=sum(r((k-1)*N_sample+1:k*N_sample).*rectpulse(1, ...
N_sample)); 
end
Br=Sr>0;
errbit=sum(Br~=B);
ber=errbit/N; % ������