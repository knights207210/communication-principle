function [M,m,df]=fftseq(m,ts,df)
%各参数含义与子函数T2F中的完全相同，完成
fs = 1/ts;
if nargin ==2
n1 =0;
else
n1 = fs/df;
end 
n2 = length(m);
n = 2^(max(nextpow2(n1),nextpow2(n2)));
M = fft(m,n);
m = [m,zeros(1,n-n2)];
df = fs/n;