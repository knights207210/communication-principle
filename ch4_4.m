clc;
 clear all;
 %�ٶ����ն��Ѿ�ʵ���ز�ͬ����λͬ����ä�źŽ���ص�Ҫ��������⣺�ز�ͬ����costas����δ������ش��룩����λͬ����Gardner�㷨��δ����ش��룩����֡ͬ����
% carrier frequency  for modulation and demodulation  
 fc=5e6;
 %QPSK transmitter
 data=5000  ;   %������Ϊ5MHZ     %ԭ�����
rand_data=randn(1,5000);
 for  i=1:data
     if rand_data(i)>=0.5
         rand_data(i)=1;
     else
         rand_data(i)=0;
     end
 end
 %seriel to parallel        %ͬʱ��������תΪ˫������
for  i=1:data
     if rem(i,2)==1
         if  rand_data(i)==1
             I(i)=1;
             I(i+1)=1;
         else
             I(i)=-1;
             I(i+1)=-1;
         end
     else
         if rand_data(i)==1
             Q(i-1)=1;
             Q(i)=1;
         else
             Q(i-1)=-1;
             Q(i)=-1;
         end
     end
 end
 % zero insertion   ���˹��̳�Ϊ���Ρ����ε���˼����ʵ������Ϣ�����ε�ת�����Ա㷢�䣬�������Ӧ�����ڻ�������֮��
zero=5;         %sampling  rate  25M HZ  ,�����ˣ�zeroΪ�������ʡ������� ������fs/�����ʡ�
for  i=1:zero*data     % ��������Ŀ=��������*ԭ����Ŀ
    if rem(i,zero)==1
         Izero(i)=I(fix((i-1)/zero)+1);
         Qzero(i)=Q(fix((i-1)/zero)+1);
     else
         Izero(i)=0;
         Qzero(i)=0;
     end
 end
 %pulse shape filter�� ���ţ������е�ͨ�˲�����Ϊ ���Ŵ������ʵ����󣬻��������Ƶ�׽����
%������˲������������˲������е�ͨ�˲����������Ƶ��ʱ����ܻ�������ѡ�
%ƽ�����������˲���
% psf=rcosfir(rf,n_t,rate,fs,'sqrt')   rate:�������ʣ�rf:�������ӣ�n_t:�˲���������fs:������
%���ڵ��ƻ���֮ǰ�����ڽ�������֮���������͹���������������������ISI����䴮�ţ�
  
NT=50;
 N=2*zero*NT;    % =500
 fs=25e6;
 rf=0.1;
 psf=rcosfir(rf,NT,zero,fs,'sqrt');% psf��СΪ500
 Ipulse=conv(Izero,psf);
 Qpulse=conv(Qzero,psf);
 %Ϊʲô�����źŴ���ҲҪ�������������˲���
%�𣺹������������źŴ��������Ե�ͨ�˲�����Ҫ����Խϵͣ���������������˲���ʱ���˲�����Ҫ�ܶ��ͣ�ָ�����ϸ�
%�����˲��������Ǳ�֤�����㲻ʧ�档���û���������ź��ھ��������ŵ�����ͼ�Ų�����ISI�ǳ����ء������˲���λ���ڻ�������֮��
%��Ϊ�������˲����źŵ���Ϣ�Ѿ�������ʧ����Ҳ��Ϊ����ISI�����Ĵ��ۡ����仰˵�������˲���λ�����ز�����֮ǰ���������ز����ơ�
%���������Ͷˣ���ֵ��������-����-�˲���LPF)-����Ƶ(�ز�����)-�������������նˣ��˱���-��ͨ-��ʱ��ȡ-�о���

%modulation
 for i=1:zero*data+N   %��������Ŀ�ı� ����Ϊ�����Ե�ʣ�
    t(i)=(i-1)/(fs);  %������Ϊ������Ƶ�������ʴ�С��ȣ���������Ƶfc���Թ�������=�����ʡ�
    Imod(i)=Ipulse(i)*sqrt(2)*cos(2*pi*fc*t(i));
     Qmod(i)=Qpulse(i)*(-sqrt(2)*sin(2*pi*fc*t(i)));
 end
 sum=Imod+Qmod;
 %QPSK  receiver
 %demodulation
    for i=1:zero*data+N
        Idem(i)=sum(i)*sqrt(2)*cos(2*pi*fc*t(i));
        Qdem(i)=sum(i)*(-sqrt(2)*sin(2*pi*fc*t(i)));
    end
    %matched  filter
    mtf=rcosfir(rf,NT,zero,fs,'sqrt');
    Imat=conv(Idem,mtf);
    Qmat=conv(Qdem,mtf);
    %data selection
    for  i=1:zero*data
        Isel(i)=Imat(i+N);
        Qsel(i)=Qmat(i+N);
    end
    %sampler        %��ȡ��Ԫ  
    for i=1:data
        Isam(i)=Isel((i-1)*zero+1);
        Qsam(i)=Qsel((i-1)*zero+1);
    end
    %decision  threshold
    threshold=0.2;
    for  i=1:data
        if Isam(i)>=threshold
            Ifinal(i)=1;
        else
            Ifinal(i)=-1;
        end
        if Qsam(i)>=threshold
            Qfinal(i)=1;
        else
            Qfinal(i)=-1;
        end
    end
    %parallel to serial
    for i=1:data
        if rem (i,2)==1
            if Ifinal(i)==1
                final(i)=1;
            else
                final(i)=0;
            end
        else
            if  Qfinal(i)==1
                final(i)=1;
            else
                final(i)=0;
            end
        end
    end
    % ��ͼ
   figure(1)
    plot(20*log(abs(fft(rand_data))));
    axis([0  data  -40  100]);
    grid on;
    title('spectrum  of input binary data');
    figure(2)
    subplot(221);
    plot(20*log(abs(fft(I))));
    axis([0 data -40 140]);
    grid  on;
    title('spectrum of I-channel data');
    subplot(222);
    plot(20*log(abs(fft(Q))));
    axis([0  data   -40  140]);
    grid  on;
    title('spectrum of Q-channel data');
    subplot(223);
    plot(20*log(abs(fft(Izero))));
    axis([0 zero*data  -20  140]);
    grid  on;
    title('spectrum of I-channel after zero insertion');
    subplot(224);
    plot(20*log(abs(fft(Qzero))));
    axis([0  zero*data   -20 140]);
    grid  on;
    title('spectrum of Q-channel after zero insertion');
    figure(3);
    subplot(221);
    plot(psf);
    axis([200    300     -0.2    0.6]);
    title('time domain response of pulse shaping filter');
    grid  on;
    subplot(222);
    plot(20*log(abs(fft(psf))));
    axis([0  N   -350 50]);
    grid on;
    title('transfer  function  of pulse  shaping filter');
    subplot(223);
    plot(20*log(abs(fft(Ipulse))));
    axis([0  zero*data+N  -250 150]);
    grid on;
    title('spectrum of I-channel after  impulse shaping filter');
    subplot(224);
    plot(20*log(abs(fft(Qpulse))));
    axis([0  zero*data+N -250  150]);
    grid  on;
    title('spectrum of Q-channel  after pluse shaping  filter');
    figure(4)
    subplot(211);
    plot(20*log(abs(fft(Imod))));
    axis([0  zero*data+N  -250 150]);
    grid  on ;
    title('spectrum of I-channel  after modulation');
    subplot(212);
    plot(20*log(abs(fft(Qmod))));
    axis([0  zero*data+N  -250 150]);
    grid  on;
    title('spectrum  of  Q-channel after modulation');
    figure(5)
    subplot(221);
    plot(20*log(abs(fft(Idem))));
    axis([0 zero*data  -200  150]);
    grid on;
    title('spectrum  of I-channel after  demodulation');
    subplot(222);
    plot(20*log(abs(fft(Qdem))));
    axis([0  zero*data+N  -200  150 ]);
    grid  on;
    title('spectrum of Q-channel after demodulation');
    subplot(223);
    plot(20*log(abs(fft(Imat))));
    axis([0  zero*data  -400  200]);
    grid  on;
    title('spectrum  of I-channel  after  matched filter');
    subplot(224);
    plot(20*log(abs(fft(Qmat))));
    axis([0  zero*data  -400  200]);
    grid  on;
    title('spectrum of  Q-channel after matched filter');
    figure(6)
    subplot(221);
    plot(20*log(abs(fft(Isam))));
    axis([0 data  -40  150]);
    grid  on;
    title('spectrum of I-channel after sampler');
    subplot(222);
    plot(20*log(abs(fft(Qsam))));
    axis([0  data -40  150 ]);
    grid  on;
    title('spectrum of Q-channel after  sampler');
    subplot(223);
    plot(20*log(abs(fft(Ifinal))));
    axis([0 data  -40  150]);
    grid on;
    title('spectrum of  I-channel after  decision threshold');
    subplot(224);
    plot(20*log(abs(fft(Qfinal))));
    axis([0 data  -40  150]);
    grid on;
    title('spectrum of  Q-channel after  decision threshold');
    figure(7)
    plot(Isel,Qsel);
    axis([-1.6 1.6  -1.6  1.6]);
    grid  on;
    title('constellation  of  matched  filter  output');
    figure(8)
    plot(Isam,Qsam,'X');
    axis([-1.2  1.2   -1.2  1.2]);
    grid on;
    title('constellation  of  sampler');
    figure(9)
    plot(20*log(abs(fft(final))));
    axis([0  data  0  100]);
    grid  on;
    title('aspectrum  of  final  received  binary  data');