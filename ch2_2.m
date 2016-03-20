% AM���ƽ��
clear all;close all;echo on
%----------------ϵͳ�������
A=2; %ֱ������
fc=10; %�ز�Ƶ�ʣ�Hz��
t0=3;%�ź�ʱ��
snr=50; %��������������dB
dt=0.001% ϵͳʱ��������
fs=1/dt;%ϵͳ����Ƶ�� 
df = 0.2; %�����Ƶ�ʷֱ���
t=0:dt:t0;
Lt=length(t);%��������У��źų���
snr_lin = 10^(snr/10); %��������������
%-------------���������źŲ��μ�Ƶ��
% ����ģ������ź�
f0=1;
m=cos(2*pi*f0.*t);
L=2*min(m);
R=2*max(abs(m))+A;
%���������źŲ��μ�Ƶ��
clf;
figure(1);subplot(321); 
plot(t,m(1:length(t)));% ���������źŲ���
axis([0 t0 -R/2 R/2]);
xlabel('t');
ylabel('�����ź�');
subplot(322);  
[M,m,df1,f]=T2F1(m,dt,df,fs);%��������ź�Ƶ��
Bw_eq=2*f0;%����źŴ���
f_start=fc-Bw_eq;
f_cutoff=fc+Bw_eq;
plot(f,fftshift(abs(M)))% ���������ź�Ƶ��
axis([-50,50,0,2]);
xlabel('f');ylabel('�����ź�Ƶ��');

subplot(323); 
c=cos(2*pi*fc*t);%�ز�
plot(t,c);
axis([0 t0 -1.2 1.2]);
xlabel('t');ylabel('�ز�');
subplot(324)% �ز�Ƶ��
[C,c,df1,f]=T2F1(c,dt,df,fs);
plot(f,fftshift(abs(C)))% �����ز�Ƶ��
axis([-50,50,0,2]);
xlabel('f');ylabel('�ز�Ƶ��');

subplot(325)% ���ѵ��ź�
u=(A+m(1:Lt)).*c(1:Lt);%�ѵ��ź�
plot(t,A+m(1:length(t)),'r--');
hold on;
plot(t,-(A+m(1:length(t))),'r--');
hold on;
plot(t,u);% �����ѵ��źŲ���

axis([0 t0 -R R]);
xlabel('t');ylabel('�ѵ��ź�');
subplot(326); 
[U,u,df1,f]=T2F1(u,dt,df,fs);
plot(f,fftshift(abs(U)))% �����ѵ��ź�Ƶ��
axis([-50,50,0,3.5]);
xlabel('f');ylabel('�ѵ��ź�Ƶ��');

%�ȸ�����������Ȳ�����˹������ 
signal_power = power_x(u(1:Lt)); %�ѵ��źŵ�ƽ������
noise_power=(signal_power*A*A)/(snr_lin*Bw_eq);%����������������ֵΪ0��
noise_std = sqrt(noise_power); %������׼ƫ��
noise = noise_std*randn(1,Lt); %��������
%�����ŵ���˹���������μ�Ƶ�ף���ʱ��������ʵ�֣�Ϊȷ֪�źţ�������Ƶ��
figure(2);subplot(321); 
plot(t,noise);% ������������
axis([0 t0 -R R]);
xlabel('t');ylabel('�����ź�');
subplot(322); 
[noisef,noise,df1,f]=T2F1(noise,dt,df,fs);%����Ƶ��
plot(f,fftshift(abs(noisef)))% ��������Ƶ��
axis([-50,50,-0.01,0.05]);
xlabel('f');ylabel('����Ƶ��');
%�����������������ѵ��źŲ��μ�Ƶ��
sam=u(1:Lt)+noise(1:Lt);%�������������ѵ��ź�
subplot(323); %�����������������ѵ��źŲ���
plot(t,sam);
axis([0 t0 -R R]);
xlabel('t');
ylabel('�ŵ��е��ź�');
subplot(324); 
[samf,sam,df1,f]=T2F1(sam,dt,df,fs);%����������������ѵ��ź�Ƶ��
plot(f,fftshift(abs(samf)))% �����������������ѵ��ź�Ƶ��
axis([-50,50,-0.1,3]);
xlabel('f');
ylabel('�ŵ����ź�Ƶ��');
[H,f]=bp_f(length(sam),f_start,f_cutoff,df1,fs,1);%���ͨ�˲���
subplot(326); 
plot(f,fftshift(abs(H)))% ������ͨ�˲���
axis([-50,50,0,1.5]);
xlabel('f');ylabel('��ͨ�˲���');


