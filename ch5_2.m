clear all
clc
snr=-10:10;
for i=1:21
    N=1000;
    input=randi([0,1],1,N);
    A=encode(input);
    B=Guass_noise(A,snr(i));
    output=decode(B);
    err(i)=sum(output~=input)/N;
end
figure(1)
i=1:21;
semilogy(snr,err(snr+11));
title('误码率与信噪比曲线');
