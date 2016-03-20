% AM调制解调
clear all;close all;echo on
%----------------系统仿真参数
A=3; %直流分量
fc=250; %载波频率（Hz）
t0=0.15;%信号时长
snr=25; %解调器输入信噪比dB
dt=0.001% 系统时域采样间隔
fs=1/dt;%系统采样频率 
df = 0.2; %所需的频率分辨率
t=0:dt:t0;
Lt=length(t);%仿真过程中，信号长度
snr_lin = 10^(snr/10); %解调器输入信噪比
%-------------画出调制信号波形及频谱
% 产生模拟调制信号
m=[ones(1,t0/(3*dt)),-2*ones(1,t0/(3*dt)),zeros(1,t0/(3*dt)+1)];
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
sf_max=max(abs(M));
[Bw_eq]=signalband(M,df,t0);%求出信号等效带宽
f_start=fc-Bw_eq;
f_cutoff=fc+Bw_eq;
plot(f,fftshift(abs(M)))% 画出调制信号频谱
xlabel('f');ylabel('调制信号频谱');

subplot(323); 
c=cos(2*pi*fc*t);%载波
plot(t,c);
axis([0 t0 -1.2 1.2]);
xlabel('t');ylabel('载波');
subplot(324)% 载波频谱
[C,c,df1,f]=T2F1(c,dt,df,fs);
plot(f,fftshift(abs(C)))% 画出载波频谱
xlabel('f');ylabel('载波频谱');

subplot(325)% 画已调信号
u=(A+m(1:Lt)).*c(1:Lt);%已调信号
plot(t,u);% 画出已调信号波形
axis([0 t0 -R R]);
xlabel('t');ylabel('已调信号');
subplot(326); 
[U,u,df1,f]=T2F1(u,dt,df,fs);
plot(f,fftshift(abs(U)))% 画出已调信号频谱
xlabel('f');ylabel('已调信号频谱');

%-----------将已调信号送入信道
%先根据所给信噪比产生高斯白噪声 
signal_power = power_x(u(1:Lt)); %已调信号的平均功率
noise_power=(signal_power*fs)/(snr_lin*4* Bw_eq);%求出噪声方差（噪声均值为0）
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
xlabel('f');
ylabel('信道中信号频谱');
[H,f]=bp_f(length(sam),f_start,f_cutoff,df1,fs,1);%求带通滤波器
subplot(326); 
plot(f,fftshift(abs(H)))% 画出带通滤波器
xlabel('f');ylabel('带通滤波器');

%-----------------经过带通滤波器
%经过理想带通滤波器后的信号及其频谱
DEM = H.*samf; %滤波器输出的频谱
[dem]=F2T1(DEM,fs);%滤波器的输出波形
figure(3)
subplot(321)%经过理想带通滤波器后的信号波形
plot(t,dem(1:Lt))%画出经过理想带通滤波器后的信号波形
axis([0 t0 -R R]);
xlabel('t');
ylabel('理想BPF输出信号');
[demf,dem,df1,f]=T2F1(dem(1:Lt),dt,df,fs);%求经过理想带通滤波器后信号频谱
subplot(322)
plot(f,fftshift(abs(demf)));% 画出经过理想带通滤波器后信号频谱
xlabel('f');
ylabel('理想BPF输出信号频谱');
%--------------和本地载波相乘，即混频
%混频后的信号，先画本地载波及其频谱
subplot(323)
plot(t,c(1:Lt));
axis([0 t0 -1.2 1.2]);
xlabel('t');
ylabel('本地载波');
subplot(324)% 载波频谱
[C,c,df1,f]=T2F1(c(1:Lt),dt,df,fs);
plot(f,fftshift(abs(C)))% 画出载波频谱 
xlabel('f');
ylabel('本地载波频谱');
%再画混频后信号及其频谱
der=dem(1:Lt).*c(1:Lt);%混频
subplot(325)%画出混频后的信号
plot(t,der);
axis([0 t0 -R R]);
xlabel('t');
ylabel('混频后的信号');
subplot(326)
[derf,der,df1,f]=T2F1(der,dt,df,fs);%求混频后的信号频谱
plot(f,fftshift(abs(derf)))%画出混频后的信号的频谱
xlabel('f');
ylabel('混频后信号频谱');
%--------------------经过低通滤波器
%画出理想低通滤波器
figure(4)
[LPF,f]=lp_f(length(der),Bw_eq,df1,fs,2);%求低通滤波器
subplot(322)
plot(f,fftshift(abs(LPF)));% 画出理想低通滤波器
xlabel('f');
ylabel('理想LPF');%混频信号经理想低通滤波器后的频谱及波形 
DM = LPF.*derf; %理想低通滤波器输出的频谱
[dm]=F2T1(DM,fs);%滤波器的输出波形 
subplot(323)
plot(t,dm(1:Lt));%画出经过低通滤波器后的解调出的波形
axis([0 t0 -R R]);
xlabel('t');
ylabel('LPF输出信号');
subplot(324)
[dmf,dm,df1,f]=T2F1(dm(1:Lt),dt,df,fs);%求LPF输出信号的频谱
plot(f,fftshift(dmf));%画出LPF输出信号的频谱
xlabel('f');
ylabel('LPF输出信号频谱');
axis([-fs/2 fs/2 0 0.5]);

%去除解调信号中的直流分量
dmd=dm(1:Lt)-mean(dm(1:Lt));
subplot(325)
plot(t,dmd);%画出恢复信号(去除直流分量)
axis([0 t0 -R/2 R/2]);
xlabel('t');
ylabel('恢复信号');
[dmdf,dmd,df1,f]=T2F1(dmd,dt,df,fs);%求恢复信号的频谱
subplot(326)
plot(f,fftshift(dmdf));%画出恢复信号的频谱 
xlabel('f');
ylabel('恢复信号的频谱');
axis([-fs/2 fs/2 0 0.2]);
subplot(321); 
plot(t,m(1:Lt));% 画出调制信号波形
axis([0 t0 -R/2 R/2]);
xlabel('t');
ylabel('调制信号');