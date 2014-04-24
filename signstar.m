function b = signstar(a,param)
%UNTITLED1 Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(a);
b=zeros(m,n);
l=find((a-param)>0);
b(l)=1;
