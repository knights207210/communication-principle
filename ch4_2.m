Fc=10;   %��Ƶ
Fs=40;   %ϵͳ����Ƶ��
Fd=1;    %������
N=Fs/Fd; 
df=10;  
numSymb=25;%���з������Ϣ�������
M=2;       %������
SNRpBit=60;%�����
SNR=SNRpBit/log2(M); 
seed=[12345 54321]; 
numPlot=25;  %����25�������������
x=randsrc(numSymb,1,[0:M-1]);%����25�������������
figure(1)  
stem([0:numPlot-1],x(1:numPlot),'bx'); 
title('�������������') 
xlabel('Time');  
ylabel('Amplitude'); %����
y=dmod(x,Fc,Fd,Fs,'fsk',M,df); 
numModPlot=numPlot*Fs; 
t=[0:numModPlot-1]./Fs; 
figure(2)  
plot(t,y(1:length(t)),'b-'); 
axis([min(t) max(t) -1.5 1.5]); 
title('���ƺ���ź�') 
xlabel('Time');  
ylabel('Amplitude');  %���ѵ��ź��м����˹������
randn('state',seed(2));  
y=awgn(y,SNR-10*log10(0.5)-10*log10(N),'measured',[],'dB');%���ѵ��ź��м����˹������
figure(3)  
plot(t,y(1:length(t)),'b-');%���������ŵ���ʵ���ź�
axis([min(t) max(t) -1.5 1.5]); 
title('�����˹����������ѵ��ź�') 
xlabel('Time');  
ylabel('Amplitude'); %��ɽ��
figure(4)  
z1=ddemod(y,Fc,Fd,Fs,'fsk/eye',M,df); 
title('��ɽ������źŵ���ͼ') %��������ε����MԪƵ�Ƽ��ؽ��
figure(5)  
stem([0:numPlot-1],x(1:numPlot),'bx'); 
hold on;  
stem([0:numPlot-1],z1(1:numPlot),'ro'); 
hold off;  
axis([0 numPlot -0.5 1.5]);  
title('��ɽ������ź�ԭ���бȽ�')
legend('ԭ����������������','��ɽ������ź�') 
xlabel('Time');  
ylabel('Amplitude'); %����ɽ��
figure(6)  
z2=ddemod(y,Fc,Fd,Fs,'fsk/eye/noncoh',M,df); 
title('����ɽ������źŵ���ͼ') 
%��������εķ����MԪƵ�Ƽ��ؽ��
figure(7)  
stem([0:numPlot-1],x(1:numPlot),'bx'); 
hold on;  
stem([0:numPlot-1],z2(1:numPlot),'ro'); 
hold off;  
axis([0 numPlot -0.5 1.5]); 
title('����ɽ������ź�')  
legend('ԭ����������������','����ɽ������ź�') 
xlabel('Time');  
ylabel('Amplitude'); %������ͳ��
[errorSym ratioSym]=symerr(x,z1); 
figure(8)  
simbasebandex([0:1:5]);  
title('��ɽ����������ͳ��')  
[errorSym ratioSym]=symerr(x,z2);       
figure(9)  
simbasebandex([0:1:5]);  
title('����ɽ����������ͳ��') %�˳���˹������
Delay=3;R=0.5
ropD=0;   %�ͺ�3s  
[yf,tf]=rcosine(Fd,Fs,'fir',R,Delay);     %�����Һ���
[yo2,to2]=rcosflt(y,Fd,Fs,'filter',yf); %�����˹����������ѵ��źź;����������˲�������ѵ��ź�
t=[0:numModPlot-1]./Fs; 
figure(10)  
plot(t,y(1:length(t)),'r-'); 
hold on;  
plot(to2,yo2,'b-'); 
hold off;  
axis([0 30 -1.5 1.5]); 
xlabel('Time');  
ylabel('Amplitude');  
legend('�����˹����������ѵ��ź�','�����������˲�������ѵ��ź�') 
title('�������˲�ǰ���αȽ�') 
eyediagram(yo2,N);%��ͼ
title('�����˹����������ѵ��źŵ���ͼ')
