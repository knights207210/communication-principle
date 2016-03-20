clear all
T=1;
N_sample=128;%Ϊ�˻����Σ�����ÿ�����ڵĲ�������
dt=1/ N_sample;%ʱ��ֱ���
t=0:dt:T -dt; 
st=[ones(1, N_sample/2), zeros(1, N_sample/2)];%���� T ���ź���ɢ��
subplot(311);plot(t,st);axis([0 1 -2 2]);xlabel('t');ylabel('s(t)');
subplot(312) ;
[f,sf]=T2F(t,st) ;
plot(f,abs(sf)) ;hold on ;%���� sf �ķ����ף�������λ
axis([-10 10 0 1]);
xlabel('f');ylabel('|S(f)|');
sff=T/2.*exp(-j*2*pi*f*T).*sinc(f*T*0.5) ;%���ݸ���Ҷ�任��%�ź�Ƶ��
plot(f,abs(sff),'r-')
[t,st]= F2T (f,sf);%������ɢ����Ҷ���任����ԭʼ�ź�
subplot(313) ;
axis([0 1 -2 2]);
xlabel('t');ylabel('�ָ��� s(t)');
plot(t,st) ;hold on ;