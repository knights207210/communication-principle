function [H,f]=lp_f(n,f_cutoff,df1,fs,p)
%��ͨ�˲�������  ������Ƶ��˲���������������ͨ�˲���Ƶ�����Ժ���H��Ƶ������f 
%------------------------�������
%n  ��ͨ�˲����������źų���
%f_cutoff  ��ͨ�˲����Ľ�ֹƵ��
%df1  Ƶ�ʷֱ���
%fs  ����Ƶ��
%p  �˲�������
%---------------------���(����)����
%H  ��ͨ�˲���Ƶ����Ӧ
%f  Ƶ������
n_cutoff = floor(f_cutoff/df1); %����˲���
f = [0:df1:df1*(n-1)] -fs/2; %Ƶ������
H = zeros(size(f));
H(1:n_cutoff) = p*ones(1,n_cutoff);
H(length(f) - n_cutoff+1:length(f)) = p*ones(1,n_cutoff);