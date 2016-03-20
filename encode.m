function B=encode(A)
L=length(A);
B=zeros(1,2*L+4);
pulse=[1,1,1,0,1,1];
for i=1:L
    if A(i)==1
        B(2*i-1:2*i+4)=mod(B(2*i-1:2*i+4)+pulse(1:6),2);
    end
end
end