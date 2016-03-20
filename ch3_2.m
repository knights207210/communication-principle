bpsk_sym=[-1;1];
ask4_sym=[-3;-1;1;3];

Fs=64;
Fd=1;
N=1000;
sym=bpsk_sym;
snr=20;

syn_start=1;
alpha=1;
delay=3;

iX=randint(N,1,[1,length(sym)]);
S0=sym(iX);

P=sum(abs(sym).^2)/length(sym);

ch=[0.9806,-0.1961 ];
ch=ch/norm(ch);
S=filter(ch,1,S0);
std_v=sqrt(P/10^(snr/10));
H=rcosine(Fd,Fs,'fir',alpha);
S1=upsample(S1,Fs/Fd);
X=filter(H,1,S1);

Y=X(Fs*4+1:end-Fs*4);
eyediagram(Y,Fs*2);
grid on;
