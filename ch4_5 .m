T=1;                          % 基带信号宽度，也就是频率 
fc=10/T;                      % 载波频率 
ml=2;                         % 调制信号类型的一个标志位 
nb=100;                       % 传输的比特数 
delta_T=T/200;                % 采样间隔 
fs=1/delta_T;                 % 采样频率 
SNR=0;                        % 信噪比  
t=0:delta_T:nb*T-delta_T;     % 限定t的取值范围 
N=length(t);                  % 采样数
%基带信号的产生
data=randn(1,nb)>0.5;
datanrz=data.*2-1;
data1=zeros(1,nb/delta_T);
for q=1:nb
    data1((q-1)/delta_T+1:q/delta_T)=datanrz(q);
end
%串并转换，将奇偶位数据分开
idata=datanrz(1:ml:(nb-1));    
qdata=datanrz(2:ml:nb); 
%qpsk信号的调制
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
%高斯信道
s1=awgn(s,SNR);              
s11=abs(fft(s1));                
s111=s1-s; 
%解调部分（高斯信道）
idata2=s1.*a;
qdata2=s1.*b;
idata3=zeros(1,nb/2);
qdata3=zeros(1,nb/2);
%抽样判决过程，与0作比较，data》=0置1，否则置0
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
%为了显示星座图，将信号进行处理
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
%将判决之后的数据存放进数组
demodata=zeros(1,nb);
demodata(1:ml:(nb-1))=idata3;
demodata(2:ml:nb)=qdata3;
%为了显示，将它变成波形信号（即传输一个1代表单位宽度的高电平）
demodata1=zeros(1,nb/delta_T);
for q=1:nb
   demodata1((q-1)/delta_T+1:q/delta_T)=demodata(q);
end
% 累计误码数  
% abs(demodata-data)求接收端和发射端 
% 数据差的绝对值，累计之后就是误码个数
Awgn_num_BER=sum(abs(demodata-data));
%高斯信道
%误码率计算
SNRindB1=0:1:6;
SNRindB2=0:0.1:6;
echo on;%决定是否显示指令内容
for i=1:length(SNRindB1)
    [pb1,ps1]=cm_sm33(SNRindB1(i)); 
    smld_bit_awgn_err_prb(i)=pb1;
    smld_symbol_awgn_err_prb(i)=ps1;
    disp([ps1,pb1]); 
    echo off;
end
%理论曲线
echo on;
for i=1:length(SNRindB2)
    SNR=exp(SNRindB2(i)*log(10)/10);
    theo_err_awgn_prb(i)=0.5*erfc(sqrt(SNR));
    theo_err_ray_prb(i)=0.5*(1-1/sqrt(1+1/SNR));
    echo off;
end
h = spectrum.welch; 
%输出显示部分
figure(1)
subplot(3,2,1); 
plot(data1),title('基带信号');
axis([0 20000 -2 2]);
subplot(3,2,2);  
psd(h,data1,'fs',fs);
title('基带信号功率谱密度');
subplot(3,2,3); 
plot(s);
title('调制信号');
axis([0 500 -3 3]);
subplot(3,2,4);  
psd(h,s,'fs',fs);
title('调制信号功率谱密度'); 
subplot(3,2,5);  
plot(demodata1);
title('解调输出');
axis([0 20000 -2 2]);
subplot(3,2,6);
psd(h,demodata1,'fs',fs);
title('解调输出功率谱密度');
%通过高斯信道
figure(2)
subplot(2,2,1);  
plot(s1);
title('调制信号(Awgn)');
axis([0 500 -5 5]); 
subplot(2,2,2);
psd(h,s1,'fs',fs),title('调制信号功率谱密度(Awgn)');
subplot(2,2,3);  
plot(s111);
title('高斯噪声曲线');
axis([0 2000 -5 5]);
figure(3)
for i=1:nb/2 
    plot(idata(i),qdata(i),'r+');
    title('QPSK信号星座图（Awgn）');hold on;
    axis([-2 2 -2 2]);
    plot(Awgn_ichsum(i),Awgn_qchsum(i),'*');
    hold on; 
    legend('理论值（发射端）','实际值（接收端）'); 
end


    
 