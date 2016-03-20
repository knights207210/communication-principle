% AM���ƽ��
clear all;close all;echo on
%----------------ϵͳ�������
A=3; %ֱ������
fc=250; %�ز�Ƶ�ʣ�Hz��
t0=0.15;%�ź�ʱ��
snr=25; %��������������dB
dt=0.001% ϵͳʱ��������
fs=1/dt;%ϵͳ����Ƶ�� 
df = 0.2; %�����Ƶ�ʷֱ���
t=0:dt:t0;
Lt=length(t);%��������У��źų���
snr_lin = 10^(snr/10); %��������������
%-------------���������źŲ��μ�Ƶ��
% ����ģ������ź�
m=[ones(1,t0/(3*dt)),-2*ones(1,t0/(3*dt)),zeros(1,t0/(3*dt)+1)];
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
sf_max=max(abs(M));
[Bw_eq]=signalband(M,df,t0);%����źŵ�Ч����
f_start=fc-Bw_eq;
f_cutoff=fc+Bw_eq;
plot(f,fftshift(abs(M)))% ���������ź�Ƶ��
xlabel('f');ylabel('�����ź�Ƶ��');

subplot(323); 
c=cos(2*pi*fc*t);%�ز�
plot(t,c);
axis([0 t0 -1.2 1.2]);
xlabel('t');ylabel('�ز�');
subplot(324)% �ز�Ƶ��
[C,c,df1,f]=T2F1(c,dt,df,fs);
plot(f,fftshift(abs(C)))% �����ز�Ƶ��
xlabel('f');ylabel('�ز�Ƶ��');

subplot(325)% ���ѵ��ź�
u=(A+m(1:Lt)).*c(1:Lt);%�ѵ��ź�
plot(t,u);% �����ѵ��źŲ���
axis([0 t0 -R R]);
xlabel('t');ylabel('�ѵ��ź�');
subplot(326); 
[U,u,df1,f]=T2F1(u,dt,df,fs);
plot(f,fftshift(abs(U)))% �����ѵ��ź�Ƶ��
xlabel('f');ylabel('�ѵ��ź�Ƶ��');

%-----------���ѵ��ź������ŵ�
%�ȸ�����������Ȳ�����˹������ 
signal_power = power_x(u(1:Lt)); %�ѵ��źŵ�ƽ������
noise_power=(signal_power*fs)/(snr_lin*4* Bw_eq);%����������������ֵΪ0��
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
xlabel('f');
ylabel('�ŵ����ź�Ƶ��');
[H,f]=bp_f(length(sam),f_start,f_cutoff,df1,fs,1);%���ͨ�˲���
subplot(326); 
plot(f,fftshift(abs(H)))% ������ͨ�˲���
xlabel('f');ylabel('��ͨ�˲���');

%-----------------������ͨ�˲���
%���������ͨ�˲�������źż���Ƶ��
DEM = H.*samf; %�˲��������Ƶ��
[dem]=F2T1(DEM,fs);%�˲������������
figure(3)
subplot(321)%���������ͨ�˲�������źŲ���
plot(t,dem(1:Lt))%�������������ͨ�˲�������źŲ���
axis([0 t0 -R R]);
xlabel('t');
ylabel('����BPF����ź�');
[demf,dem,df1,f]=T2F1(dem(1:Lt),dt,df,fs);%�󾭹������ͨ�˲������ź�Ƶ��
subplot(322)
plot(f,fftshift(abs(demf)));% �������������ͨ�˲������ź�Ƶ��
xlabel('f');
ylabel('����BPF����ź�Ƶ��');
%--------------�ͱ����ز���ˣ�����Ƶ
%��Ƶ����źţ��Ȼ������ز�����Ƶ��
subplot(323)
plot(t,c(1:Lt));
axis([0 t0 -1.2 1.2]);
xlabel('t');
ylabel('�����ز�');
subplot(324)% �ز�Ƶ��
[C,c,df1,f]=T2F1(c(1:Lt),dt,df,fs);
plot(f,fftshift(abs(C)))% �����ز�Ƶ�� 
xlabel('f');
ylabel('�����ز�Ƶ��');
%�ٻ���Ƶ���źż���Ƶ��
der=dem(1:Lt).*c(1:Lt);%��Ƶ
subplot(325)%������Ƶ����ź�
plot(t,der);
axis([0 t0 -R R]);
xlabel('t');
ylabel('��Ƶ����ź�');
subplot(326)
[derf,der,df1,f]=T2F1(der,dt,df,fs);%���Ƶ����ź�Ƶ��
plot(f,fftshift(abs(derf)))%������Ƶ����źŵ�Ƶ��
xlabel('f');
ylabel('��Ƶ���ź�Ƶ��');
%--------------------������ͨ�˲���
%���������ͨ�˲���
figure(4)
[LPF,f]=lp_f(length(der),Bw_eq,df1,fs,2);%���ͨ�˲���
subplot(322)
plot(f,fftshift(abs(LPF)));% ���������ͨ�˲���
xlabel('f');
ylabel('����LPF');%��Ƶ�źž������ͨ�˲������Ƶ�׼����� 
DM = LPF.*derf; %�����ͨ�˲��������Ƶ��
[dm]=F2T1(DM,fs);%�˲������������ 
subplot(323)
plot(t,dm(1:Lt));%����������ͨ�˲�����Ľ�����Ĳ���
axis([0 t0 -R R]);
xlabel('t');
ylabel('LPF����ź�');
subplot(324)
[dmf,dm,df1,f]=T2F1(dm(1:Lt),dt,df,fs);%��LPF����źŵ�Ƶ��
plot(f,fftshift(dmf));%����LPF����źŵ�Ƶ��
xlabel('f');
ylabel('LPF����ź�Ƶ��');
axis([-fs/2 fs/2 0 0.5]);

%ȥ������ź��е�ֱ������
dmd=dm(1:Lt)-mean(dm(1:Lt));
subplot(325)
plot(t,dmd);%�����ָ��ź�(ȥ��ֱ������)
axis([0 t0 -R/2 R/2]);
xlabel('t');
ylabel('�ָ��ź�');
[dmdf,dmd,df1,f]=T2F1(dmd,dt,df,fs);%��ָ��źŵ�Ƶ��
subplot(326)
plot(f,fftshift(dmdf));%�����ָ��źŵ�Ƶ�� 
xlabel('f');
ylabel('�ָ��źŵ�Ƶ��');
axis([-fs/2 fs/2 0 0.2]);
subplot(321); 
plot(t,m(1:Lt));% ���������źŲ���
axis([0 t0 -R/2 R/2]);
xlabel('t');
ylabel('�����ź�');