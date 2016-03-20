%FSK
fs=2000;   %����Ƶ��
dt=1/fs; 
f1=20;  
f2=120;        %�����źŵ�Ƶ��
a=round(rand(1,10));   %����ź�
g1=a  
g2=~a;            %�źŷ�ת����g1����
g11=(ones(1,2000))'*g1;    %����
g1a=g11(:)';  
g21=(ones(1,2000))'*g2; 
g2a=g21(:)'; 
t=0:dt:10-dt; 
t1=length(t);  
fsk1=g1a.*cos(2*pi*f1.*t); 
fsk2=g2a.*cos(2*pi*f2.*t);  
fsk=fsk1+fsk2;              %�������ź�
no=0.01*randn(1,t1);        %����
sn=fsk+no; 
subplot(311);  
plot(t,no);     %��������
title('��������') 
ylabel('����') 
subplot(312); 
plot(t,fsk); 
title('�����Ĳ���') 
ylabel('����') 
hold on;
plot(t,g1a,'r--');
subplot(313); 
plot(t,sn);  
title('��Ҫͨ���˲����Ĳ���') 
ylabel('���ȵĴ�С') 
xlabel('t')  
figure(2)     %FSK���
b1=fir1(101,[10/800 20/800]);  
b2=fir1(101,[90/800 110/800]);  %���ô�ͨ����
H1=filter(b1,1,sn);  
H2=filter(b2,1,sn);          %������ͨ�˲�������ź�
subplot(211); 
plot(t,H1);  
title('������ͨ�˲���f1��Ĳ���') 
ylabel('����') 
subplot(212); 
plot(t,H2);  
title('������ͨ�˲���f2��Ĳ���') 
ylabel('����') 
xlabel('t') 
sw1=H1.*H1;  
sw2=H2.*H2; %���������
figure(3)  
subplot(211); 
plot(t,sw1);  
title('���������h1��Ĳ���') 
ylabel('����') 
subplot(212); 
plot(t,sw2);  
title('���������h2��Ĳ���') 
ylabel('������') 
xlabel('t')  
bn=fir1(101,[2/800 10/800]);   %������ͨ�˲���
figure(4)  
st1=filter(bn,1,sw1); 
st2=filter(bn,1,sw2); 
subplot(211); 
plot(t,st1);  
title('������ͨ�˲���sw1��Ĳ���') 
ylabel('����') 
subplot(212); 
plot(t,st2); 
title('������ͨ�˲���sw2��Ĳ���')
ylabel('����') 
xlabel('t') %�о�
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
title('���������о�����Ĳ���') 
ylabel('����') 
hold on;
plot(t,g1a,'r--');
subplot(212); 
plot(t,sn); 
title('ԭʼ�Ĳ���') 
ylabel('����') 
xlabel('t') 
