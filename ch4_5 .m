T=1;                          % �����źſ�ȣ�Ҳ����Ƶ�� 
fc=10/T;                      % �ز�Ƶ�� 
ml=2;                         % �����ź����͵�һ����־λ 
nb=100;                       % ����ı����� 
delta_T=T/200;                % ������� 
fs=1/delta_T;                 % ����Ƶ�� 
SNR=0;                        % �����  
t=0:delta_T:nb*T-delta_T;     % �޶�t��ȡֵ��Χ 
N=length(t);                  % ������
%�����źŵĲ���
data=randn(1,nb)>0.5;
datanrz=data.*2-1;
data1=zeros(1,nb/delta_T);
for q=1:nb
    data1((q-1)/delta_T+1:q/delta_T)=datanrz(q);
end
%����ת��������żλ���ݷֿ�
idata=datanrz(1:ml:(nb-1));    
qdata=datanrz(2:ml:nb); 
%qpsk�źŵĵ���
ich=zeros(1,nb/delta_T/2);
for i=1:nb/2
    ich((i-1)/delta_T+1:i/delta_T)=idata(i);
end
for ii=1:N/2
    a(ii)=sqrt(2/T)*cos(2*pi*fc*t(ii));
end
idata1=ich.*a;
qch=zeros(1,nb/2/delta_T);
for j1=1:nb/2 
    qch((j1-1)/delta_T+1:j1/delta_T)=qdata(j1);
end
for jj=1:N/2 
    b(jj)=sqrt(2/T)*sin(2*pi*fc*t(jj));
end
qdata1=qch.*b;
s=idata1+qdata1;             
ss=abs(fft(s));
%��˹�ŵ�
s1=awgn(s,SNR);              
s11=abs(fft(s1));                
s111=s1-s; 
%������֣���˹�ŵ���
idata2=s1.*a;
qdata2=s1.*b;
idata3=zeros(1,nb/2);
qdata3=zeros(1,nb/2);
%�����о����̣���0���Ƚϣ�data��=0��1��������0
for n=1:nb/2
    if sum(idata2((n-1)/delta_T+1:n/delta_T))>=0
        data3(n)=1;
    else idata3(n)=0;
    end
    if sum(qdata2((n-1)/delta_T+1:n/delta_T))>=0
        qdata3(n)=1;
    else qdata3(n)=0;
    end
end
%Ϊ����ʾ����ͼ�����źŽ��д���
idata4=zeros(1,nb/2);
qdata4=zeros(1,nb/2);
for n=1:nb/2
    Awgn_ichsum(n)=sum(idata2((n-1)/delta_T+1:n/delta_T))*delta_T;
    if Awgn_ichsum(n)>=0
        idata4(n)=1; 
        else idata4(n)=0;
    end
    Awgn_qchsum(n)=sum(qdata2((n-1)/delta_T+1:n/delta_T))*delta_T;
    if Awgn_qchsum(n)>=0
         qdata4(n)=1;
         else qdata4(n)=0;
    end
end
%���о�֮������ݴ�Ž�����
demodata=zeros(1,nb);
demodata(1:ml:(nb-1))=idata3;
demodata(2:ml:nb)=qdata3;
%Ϊ����ʾ��������ɲ����źţ�������һ��1����λ��ȵĸߵ�ƽ��
demodata1=zeros(1,nb/delta_T);
for q=1:nb
   demodata1((q-1)/delta_T+1:q/delta_T)=demodata(q);
end
% �ۼ�������  
% abs(demodata-data)����ն˺ͷ���� 
% ���ݲ�ľ���ֵ���ۼ�֮������������
Awgn_num_BER=sum(abs(demodata-data));
%��˹�ŵ�
%�����ʼ���
SNRindB1=0:1:6;
SNRindB2=0:0.1:6;
echo on;%�����Ƿ���ʾָ������
for i=1:length(SNRindB1)
    [pb1,ps1]=cm_sm33(SNRindB1(i)); 
    smld_bit_awgn_err_prb(i)=pb1;
    smld_symbol_awgn_err_prb(i)=ps1;
    disp([ps1,pb1]); 
    echo off;
end
%��������
echo on;
for i=1:length(SNRindB2)
    SNR=exp(SNRindB2(i)*log(10)/10);
    theo_err_awgn_prb(i)=0.5*erfc(sqrt(SNR));
    theo_err_ray_prb(i)=0.5*(1-1/sqrt(1+1/SNR));
    echo off;
end
h = spectrum.welch; 
%�����ʾ����
figure(1)
subplot(3,2,1); 
plot(data1),title('�����ź�');
axis([0 20000 -2 2]);
subplot(3,2,2);  
psd(h,data1,'fs',fs);
title('�����źŹ������ܶ�');
subplot(3,2,3); 
plot(s);
title('�����ź�');
axis([0 500 -3 3]);
subplot(3,2,4);  
psd(h,s,'fs',fs);
title('�����źŹ������ܶ�'); 
subplot(3,2,5);  
plot(demodata1);
title('������');
axis([0 20000 -2 2]);
subplot(3,2,6);
psd(h,demodata1,'fs',fs);
title('�������������ܶ�');
%ͨ����˹�ŵ�
figure(2)
subplot(2,2,1);  
plot(s1);
title('�����ź�(Awgn)');
axis([0 500 -5 5]); 
subplot(2,2,2);
psd(h,s1,'fs',fs),title('�����źŹ������ܶ�(Awgn)');
subplot(2,2,3);  
plot(s111);
title('��˹��������');
axis([0 2000 -5 5]);
figure(3)
for i=1:nb/2 
    plot(idata(i),qdata(i),'r+');
    title('QPSK�ź�����ͼ��Awgn��');hold on;
    axis([-2 2 -2 2]);
    plot(Awgn_ichsum(i),Awgn_qchsum(i),'*');
    hold on; 
    legend('����ֵ������ˣ�','ʵ��ֵ�����նˣ�'); 
end


    
 