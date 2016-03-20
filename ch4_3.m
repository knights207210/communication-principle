%FSK
fs=2000;   %采样频率
dt=1/fs; 
f1=20;  
f2=120;        %两个信号的频率
a=round(rand(1,10));   %随机信号
g1=a  
g2=~a;            %信号反转，和g1反向
g11=(ones(1,2000))'*g1;    %抽样
g1a=g11(:)';  
g21=(ones(1,2000))'*g2; 
g2a=g21(:)'; 
t=0:dt:10-dt; 
t1=length(t);  
fsk1=g1a.*cos(2*pi*f1.*t); 
fsk2=g2a.*cos(2*pi*f2.*t);  
fsk=fsk1+fsk2;              %产生的信号
no=0.01*randn(1,t1);        %噪声
sn=fsk+no; 
subplot(311);  
plot(t,no);     %噪声波形
title('噪声波形') 
ylabel('幅度') 
subplot(312); 
plot(t,fsk); 
title('产生的波形') 
ylabel('幅度') 
hold on;
plot(t,g1a,'r--');
subplot(313); 
plot(t,sn);  
title('将要通过滤波器的波形') 
ylabel('幅度的大小') 
xlabel('t')  
figure(2)     %FSK解调
b1=fir1(101,[10/800 20/800]);  
b2=fir1(101,[90/800 110/800]);  %设置带通参数
H1=filter(b1,1,sn);  
H2=filter(b2,1,sn);          %经过带通滤波器后的信号
subplot(211); 
plot(t,H1);  
title('经过带通滤波器f1后的波形') 
ylabel('幅度') 
subplot(212); 
plot(t,H2);  
title('经过带通滤波器f2后的波形') 
ylabel('幅度') 
xlabel('t') 
sw1=H1.*H1;  
sw2=H2.*H2; %经过相乘器
figure(3)  
subplot(211); 
plot(t,sw1);  
title('经过相乘器h1后的波形') 
ylabel('幅度') 
subplot(212); 
plot(t,sw2);  
title('经过相乘器h2后的波形') 
ylabel('·幅度') 
xlabel('t')  
bn=fir1(101,[2/800 10/800]);   %经过低通滤波器
figure(4)  
st1=filter(bn,1,sw1); 
st2=filter(bn,1,sw2); 
subplot(211); 
plot(t,st1);  
title('经过低通滤波器sw1后的波形') 
ylabel('幅度') 
subplot(212); 
plot(t,st2); 
title('经过低通滤波器sw2后的波形')
ylabel('幅度') 
xlabel('t') %判决
for i=1:length(t)  
if (st1(i)>=st2(i)) 
    st(i)=0;  
else
    st(i)=st2(i); 
end
end
figure(5) 
st=st1+(-1*st2+0.5); 
subplot(211); 
plot(t,st);  
title('经过抽样判决器后的波形') 
ylabel('幅度') 
hold on;
plot(t,g1a,'r--');
subplot(212); 
plot(t,sn); 
title('原始的波形') 
ylabel('幅度') 
xlabel('t') 
