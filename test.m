clear all;
N=20;%取展开式的项数为 2N+1 项
%可以改为N=input('input N:')
T=1;%周期为 1
fs=1/T; 
N_sample=128;%为了画波形，设置每个周期的采样点数
dt=1/ N_sample;%时间分辨率
t=0:dt:10*T -dt;%取 10 个周期
n=-N:N;
Fn=sinc(n/2).*exp(-j*n*pi/2);%求傅立叶系数
Fn(N+1)=0;%当 n=0 时，代入 Fn 得 Fn=0，由于数组的序号是从 1 开始的，即 n=-N 时对%应 Fn(1), n=0 时对%应 Fn(n+1)，即 n=N 时对%应 Fn(2N+1)
ft=zeros(1,length(t));%建立一个全零数组，其长度和原始信号长度相同，用来存放由傅里叶%展开恢复的信号
for m=-N:N;%一共 2N+1 项累加。
ft=ft+Fn(m+N+1)*exp(j*2*pi*m*fs*t) ;%Fn 是一个数组，而 MATLAB 中数组中元素的序%号是从 1 开始的， 故 Fn 序号是从 1 开始的，到 2N＋1 结束，该语句中体现为为 Fn(m+N+1)
%而当 n=0 时，Fn=0，在数组中的位置为第 N+1 个元素，故令 Fn(N+1)=0
end
plot(t,ft)