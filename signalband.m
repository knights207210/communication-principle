function [Bw_eq]=signalband(sf,df,T)
%计算信号等效带宽
%sf：信号频谱
%df:频率分辨率
%T：信号持续时间
sf_max=max(abs(sf));
Bw_eq=sum(abs(sf).^2)*df/T/sf_max.^2