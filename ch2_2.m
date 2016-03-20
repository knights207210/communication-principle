% AM调制解调
clear all;close all;echo on
%----------------系统仿真参数
A=2; %直流分量
fc=10; %载波频率（Hz）
t0=3;%信号时长
snr=50; %解调器输入信噪比dB
dt=0.001% 系统时域采样间隔
fs=1/dt;%系统采样频率 
df = 0.2; %所需的频率分辨率
t=0:dt:t0;
Lt=length(t);%仿真过程中，信号长度
snr_lin = 10^(snr/10); %解调器输入信噪比
%-------------画出调制信号波形及频谱
% 产生模拟调制信号
f0=1;
m=cos(2*pi*f0.*t);
L=2*min(m);
R=2*max(abs(m))+A;
%画出调制信号波形及频谱
clf;
figure(1);subplot(321); 
plot(t,m(1:length(t)));% 画出调制信号波形
axis([0 t0 -R/2 R/2]);
xlabel('t');
ylabel('调制信号');
subplot(322);  
[M,m,df1,f]=T2F1(m,dt,df,fs);%求出调制信号频谱
Bw_eq=2*f0;%求出信号带宽
f_start=fc-Bw_eq;
f_cutoff=fc+Bw_eq;
plot(f,fftshift(abs(M)))% 画出调制信号频谱
axis([-50,50,0,2]);
xlabel('f');ylabel('调制信号频谱');

subplot(323); 
c=cos(2*pi*fc*t);%载波
plot(t,c);
axis([0 t0 -1.2 1.2]);
xlabel('t');ylabel('载波');
subplot(324)% 载波频谱
[C,c,df1,f]=T2F1(c,dt,df,fs);
plot(f,fftshift(abs(C)))% 画出载波频谱
axis([-50,50,0,2]);
xlabel('f');ylabel('载波频谱');

subplot(325)% 画已调信号
u=(A+m(1:Lt)).*c(1:Lt);%已调信号
plot(t,A+m(1:length(t)),'r--');
hold on;
plot(t,-(A+m(1:length(t))),'r--');
hold on;
plot(t,u);% 画出已调信号波形

axis([0 t0 -R R]);
xlabel('t');ylabel('已调信号');
subplot(326); 
[U,u,df1,f]=T2F1(u,dt,df,fs);
plot(f,fftshift(abs(U)))% 画出已调信号频谱
axis([-50,50,0,3.5]);
xlabel('f');ylabel('已调信号频谱');

%先根据所给信噪比产生高斯白噪声 
signal_power = power_x(u(1:Lt)); %已调信号的平均功率
noise_power=(signal_power*A*A)/(snr_lin*Bw_eq);%求出噪声方差（噪声均值为0）
noise_std = sqrt(noise_power); %噪声标准偏差
noise = noise_std*randn(1,Lt); %产生噪声
%画出信道高斯白噪声波形及频谱，此时，噪声已实现，为确知信号，可求其频谱
figure(2);subplot(321); 
plot(t,noise);% 画出噪声波形
axis([0 t0 -R R]);
xlabel('t');ylabel('噪声信号');
subplot(322); 
[noisef,noise,df1,f]=T2F1(noise,dt,df,fs);%噪声频谱
plot(f,fftshift(abs(noisef)))% 画出噪声频谱
axis([-50,50,-0.01,0.05]);
xlabel('f');ylabel('噪声频谱');
%画出叠加了噪声的已调信号波形及频谱
sam=u(1:Lt)+noise(1:Lt);%叠加了噪声的已调信号
subplot(323); %画出叠加了噪声的已调信号波形
plot(t,sam);
axis([0 t0 -R R]);
xlabel('t');
ylabel('信道中的信号');
subplot(324); 
[samf,sam,df1,f]=T2F1(sam,dt,df,fs);%求出叠加了噪声的已调信号频谱
plot(f,fftshift(abs(samf)))% 画出叠加了噪声的已调信号频谱
axis([-50,50,-0.1,3]);
xlabel('f');
ylabel('信道中信号频谱');
[H,f]=bp_f(length(sam),f_start,f_cutoff,df1,fs,1);%求带通滤波器
subplot(326); 
plot(f,fftshift(abs(H)))% 画出带通滤波器
axis([-50,50,0,1.5]);
xlabel('f');ylabel('带通滤波器');


