Fc=10;   %载频
Fs=40;   %系统采样频率
Fd=1;    %码速率
N=Fs/Fd; 
df=10;  
numSymb=25;%进行仿真的信息代码个数
M=2;       %进制数
SNRpBit=60;%信噪比
SNR=SNRpBit/log2(M); 
seed=[12345 54321]; 
numPlot=25;  %产生25个二进制随机码
x=randsrc(numSymb,1,[0:M-1]);%产生25个二进制随机码
figure(1)  
stem([0:numPlot-1],x(1:numPlot),'bx'); 
title('二进制随机序列') 
xlabel('Time');  
ylabel('Amplitude'); %调制
y=dmod(x,Fc,Fd,Fs,'fsk',M,df); 
numModPlot=numPlot*Fs; 
t=[0:numModPlot-1]./Fs; 
figure(2)  
plot(t,y(1:length(t)),'b-'); 
axis([min(t) max(t) -1.5 1.5]); 
title('调制后的信号') 
xlabel('Time');  
ylabel('Amplitude');  %在已调信号中加入高斯白噪声
randn('state',seed(2));  
y=awgn(y,SNR-10*log10(0.5)-10*log10(N),'measured',[],'dB');%在已调信号中加入高斯白噪声
figure(3)  
plot(t,y(1:length(t)),'b-');%画出经过信道的实际信号
axis([min(t) max(t) -1.5 1.5]); 
title('加入高斯白噪声后的已调信号') 
xlabel('Time');  
ylabel('Amplitude'); %相干解调
figure(4)  
z1=ddemod(y,Fc,Fd,Fs,'fsk/eye',M,df); 
title('相干解调后的信号的眼图') %带输出波形的相干M元频移键控解调
figure(5)  
stem([0:numPlot-1],x(1:numPlot),'bx'); 
hold on;  
stem([0:numPlot-1],z1(1:numPlot),'ro'); 
hold off;  
axis([0 numPlot -0.5 1.5]);  
title('相干解调后的信号原序列比较')
legend('原输入二进制随机序列','相干解调后的信号') 
xlabel('Time');  
ylabel('Amplitude'); %非相干解调
figure(6)  
z2=ddemod(y,Fc,Fd,Fs,'fsk/eye/noncoh',M,df); 
title('非相干解调后的信号的眼图') 
%带输出波形的非相干M元频移键控解调
figure(7)  
stem([0:numPlot-1],x(1:numPlot),'bx'); 
hold on;  
stem([0:numPlot-1],z2(1:numPlot),'ro'); 
hold off;  
axis([0 numPlot -0.5 1.5]); 
title('非相干解调后的信号')  
legend('原输入二进制随机序列','非相干解调后的信号') 
xlabel('Time');  
ylabel('Amplitude'); %误码率统计
[errorSym ratioSym]=symerr(x,z1); 
figure(8)  
simbasebandex([0:1:5]);  
title('相干解调后误码率统计')  
[errorSym ratioSym]=symerr(x,z2);       
figure(9)  
simbasebandex([0:1:5]);  
title('非相干解调后误码率统计') %滤除高斯白噪声
Delay=3;R=0.5
ropD=0;   %滞后3s  
[yf,tf]=rcosine(Fd,Fs,'fir',R,Delay);     %升余弦函数
[yo2,to2]=rcosflt(y,Fd,Fs,'filter',yf); %加入高斯白噪声后的已调信号和经过升余弦滤波器后的已调信号
t=[0:numModPlot-1]./Fs; 
figure(10)  
plot(t,y(1:length(t)),'r-'); 
hold on;  
plot(to2,yo2,'b-'); 
hold off;  
axis([0 30 -1.5 1.5]); 
xlabel('Time');  
ylabel('Amplitude');  
legend('加入高斯白噪声后的已调信号','经过升余弦滤波器后的已调信号') 
title('升余弦滤波前后波形比较') 
eyediagram(yo2,N);%眼图
title('加入高斯白噪声后的已调信号的眼图')
