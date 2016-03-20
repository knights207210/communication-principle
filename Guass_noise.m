function B=Guass_noise(A,snr)
L=length(A);
B=awgn(A,snr,'measured');
for i=1:L
    if B(i)>=0.5
        B(i)=1;
    else
        B(i)=0;
    end
end
end
