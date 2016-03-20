function output = convolutionX(X)
n=length(X);
n1=0.01:0.01:n;
for(i=1:n)
    is((i-1)*100+1:i*100)=X(i);
end
figure(1)
plot(n1,is);
axis([0,n+1,-0.1,1.1]);
title('原始序列');
grid;

Y=[0 0 0];
for(i=1:n)
    Y(1)=Y(2);
    Y(2)=Y(3);
    Y(3)=X(i);
    Y;
    output(2*(i-1)+1)=mod(sum(Y),2);
    output(2*(i-1)+2)=mod((Y(1)+Y(3)),2);
end
output;

a=length(output);
a;
t=0.01:0.01:a;
for(i=1:a)
    st(((i-1)*100+1):i*100)=output(i);
end
st;

figure(2);
plot(t,st);
axis([0,a+1,-0.1,1.1]);
title('卷积波形');
grid;
end
