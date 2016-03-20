clear all
T=1;
N_sample=128;%为了画波形，设置每个周期的采样点数
dt=1/ N_sample;%时间分辨率
t=0:dt:T -dt; 
st=[ones(1, N_sample/2), zeros(1, N_sample/2)];%依据 T 将信号离散化
subplot(311);plot(t,st);axis([0 1 -2 2]);xlabel('t');ylabel('s(t)');
subplot(312) ;
[f,sf]=T2F(t,st) ;
plot(f,abs(sf)) ;hold on ;%画出 sf 的幅度谱，不含相位
axis([-10 10 0 1]);
xlabel('f');ylabel('|S(f)|');
sff=T/2.*exp(-j*2*pi*f*T).*sinc(f*T*0.5) ;%依据傅里叶变换求%信号频谱
plot(f,abs(sff),'r-')
[t,st]= F2T (f,sf);%进行离散傅立叶反变换，求原始信号
subplot(313) ;
axis([0 1 -2 2]);
xlabel('t');ylabel('恢复的 s(t)');
plot(t,st) ;hold on ;