A=1; % Amplitude 
fc=2; % frequency of Carrier 
snr=30; % SNR 
fs=80;% sample frequency 
N=10000; % number of symbols 
Ts=1; % symbol period B=1/Ts; % baud rate 
ts=1/fs; % sample period 
t=0:ts:N*Ts-ts; 
t=t.'; 
Lt=length(t); 
N_sample=Ts*fs ; % generate sending signal
%------------BPSK------------%
B=randint(1,N); sym=[-1;1]; A=sym(B+1); P=sum(abs(sym).^2)/length(sym); 
std_v=sqrt(P/10^(snr/10)/2); 
A1=A+randn(size(A))*std_v; 
S=rcosflt(A1, 1, fs); 
phi0=rand()*2*pi; % random initial phase 
X=S(1:length(t)).*cos(2*pi*fc*t+phi0); % $$$ % $$$ 
figure(1) % $$$ 
plot(t(1:800),X(1:800)); % channel % time delay 
delay=floor(rand()*fs); Xd=[zeros(delay, 1);X(1:end-delay)]; Y=Xd; % $$$ 
figure(2); % $$$ 
plot(t(1:800), real(Y(1:800))); % square 
Y2=Y.*Y; % $$$ 
figure(3); % $$$ 
pwelch(Y2,[],[],[],fs); fc2=2*fc/(fs/2); 
df=0.1/(fs/2); [b ,a]=butter(2, [fc2-df fc2+df]); % bandpass filtering 
Yf=filter(b,a, Y2); 
aa=0.99; 
Z=zeros(length(Y),1); 
kk1=2; e1=0; ee=Z; Z2=Z; 
for k=1:length(Y)-1 
    e0=Z(k)*Yf(k); 
    e1=e1+(1-aa)*e0; % loop filtering 
    Z(k+1)=sin(4*pi*(fc)*t(k)+e1*kk1); % 2fc 
    ee(k)=e1; 
    Z2(k+1)=sin(2*pi*fc*t(k)+e1*kk1/2); % fc 
end
% remove carrier at receiver
Zr=Y.*conj(Z2(1:length(Y))); 
[b2,a2]=butter(5, 1/fs*2, 'low'); 
Zr2=filter(b2,a2,Zr); % use orignal carrier from sender 
Zr1=filter(b2,a2, Y.*cos(2*pi*fc*(t-delay/fs)+phi0)); 
idx=12001:13000; % 0 or pi
ss=sign(sum(cos(2*pi*fc*(t(idx)-delay/fs)+phi0).*Z2(idx))); 
figure(4);
plot(t(idx), cos(2*pi*fc*(t(idx)-delay/fs)+phi0), t(idx), ss*Z2(idx)); 
legend('carrier(send)', 'carrier(sq_loop)'); 
figure(5); 
plot(Zr2(delay+40:fs:end), '.'); %optimal sample time