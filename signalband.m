function [Bw_eq]=signalband(sf,df,T)
%�����źŵ�Ч����
%sf���ź�Ƶ��
%df:Ƶ�ʷֱ���
%T���źų���ʱ��
sf_max=max(abs(sf));
Bw_eq=sum(abs(sf).^2)*df/T/sf_max.^2