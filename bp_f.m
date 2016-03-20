function[H,f]=bp_f(n,f_start,f_cutoff,df1,fs,p)
%带通滤波器函数  输入设计的滤波器参数，产生带通滤波器频率特性函数H和频率向量f
%------------------------输入参数
%n  带通滤波器的输入信号长度
%f_start  通带起始频率
%f_cutoff  带通滤波器的截止频率
%df1  频率分辨率
%fs  抽样频率
%p  滤波器幅度
%----------------------输出(返回)参数
%H  带通滤波器频率响应
%f  频率向量
%设计滤波器   
n_cutoff = floor(f_cutoff/df1); 
n_start = floor(f_start/df1); 
f = [0:df1:df1*(n-1)] -fs/2; %频率向量
H = zeros(size(f));
H(n_start+1:n_cutoff) = p*ones(1,n_cutoff-n_start);
H(length(f) - n_cutoff+1:length(f)-n_start) = p*ones(1,n_cutoff-n_start);