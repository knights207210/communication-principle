Fs=64; Fd=1;N=200;
sym=[-1;1];
alpha=1;
iS=randint(N,1, [1,length(sym)]);
S=sym(iS);
H=rcosine(Fd, Fs, 'fir', alpha);
S1=upsample(S, Fs/Fd);
X=filter(H, 1, S1);
plot(X(1:2000)); %  обм╪вС
Y=X(Fs*4+1:end-Fs*4);
eyediagram(Y, Fs*2); %  обм╪ср