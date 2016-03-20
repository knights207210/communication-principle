function [H,f]=lp_f(n,f_cutoff,df1,fs,p)
%低通滤波器函数  输入设计的滤波器参数，产生低通滤波器频率特性函数H和频率向量f 
%------------------------输入参数
%n  低通滤波器的输入信号长度
%f_cutoff  低通滤波器的截止频率
%df1  频率分辨率
%fs  抽样频率
%p  滤波器幅度
%---------------------输出(返回)参数
%H  低通滤波器频率响应
%f  频率向量
n_cutoff = floor(f_cutoff/df1); %设计滤波器
f = [0:df1:df1*(n-1)] -fs/2; %频率向量
H = zeros(size(f));
H(1:n_cutoff) = p*ones(1,n_cutoff);
H(length(f) - n_cutoff+1:length(f)) = p*ones(1,n_cutoff);