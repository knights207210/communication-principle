bpsk_sym=[-1;1];     %BPSK
ask4_sym=[-3;-1;1;3];     %4ASK
Fs=64;                  %ϵͳ������
Fd=1;                   %������
N=1000;
sym=bpsk_sym;
snr=10;                 %�����
alpha=1;                %����ϵ��
syn_start=1;            

iX=randint(N,1,[1,length(sym)]);     %���������������
SO=sym(iX);                         %����

P=sum(abs(sym).^2)/length(sym);     

ch=[1;-0.2];
ch=ch/norm(ch);
S=filter(ch,1,SO);    %��䴮��

std_v=sqrt(P/10^(snr/10));
S1=S+randn(size(S))*std_v;   %��˹������
S2=SO;
H=rcosine(Fd,Fs,'fir',alpha);     %�����˲���
S1=upsample(S1,Fs/Fd);
S2=upsample(S2,Fs/Fd);
X1=filter(H,1,S1);            %�ŵ�������
X2=filter(H,1,S2);            %�����ŵ�

Y1=X1(Fs*4+1:end-Fs*4);       %��ȡһ�μ�����ʾ
eyediagram(Y1,Fs*2);          %������ͼ
grid on;

Y2=X2(Fs*4+1:end-Fs*4);
eyediagram(Y2,Fs*2);
grid on;
