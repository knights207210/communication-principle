bpsk_sym=[-1;1];     %BPSK
ask4_sym=[-3;-1;1;3];     %4ASK
Fs=64;                  %系统采样率
Fd=1;                   %符号率
N=1000;
sym=bpsk_sym;
snr=10;                 %信噪比
alpha=1;                %滚降系数
syn_start=1;            

iX=randint(N,1,[1,length(sym)]);     %产生随机输入序列
SO=sym(iX);                         %编码

P=sum(abs(sym).^2)/length(sym);     

ch=[1;-0.2];
ch=ch/norm(ch);
S=filter(ch,1,SO);    %码间串扰

std_v=sqrt(P/10^(snr/10));
S1=S+randn(size(S))*std_v;   %高斯白噪声
S2=SO;
H=rcosine(Fd,Fs,'fir',alpha);     %产生滤波器
S1=upsample(S1,Fs/Fd);
S2=upsample(S2,Fs/Fd);
X1=filter(H,1,S1);            %信道加噪声
X2=filter(H,1,S2);            %无噪信道

Y1=X1(Fs*4+1:end-Fs*4);       %截取一段加以显示
eyediagram(Y1,Fs*2);          %产生眼图
grid on;

Y2=X2(Fs*4+1:end-Fs*4);
eyediagram(Y2,Fs*2);
grid on;
