function [w,h,t]=nmfro(v,r,epsilon)
%
% r       : number of desired factors (rank of the factorization)
%
% w    : N x r NMF factor
% h    : r x M NMF factor

% test for negative values in v
if min(min(v)) < 0
error('matrix entries can not be negative');
return
end

[n,m]=size(v);
temp=0;
w=rand(n,r);
h=rand(r,m); 

while 1
   % distance-reducing NMF iterations
   t=norm(v-w*h,'fro')^2;
   wv=w'*v;
   wwh=w'*w*h;
   wwh=max(wwh,eps);
   h=h.*wv./wwh;
   vh=v*h';
   whh=w*h*h';
   whh=max(whh,eps);
   w=w.*vh./whh;
  
   if abs(norm(v-w*h,'fro')^2-t)<epsilon
       temp=temp+1;
   else 
       temp=0;
   end
   if temp==100
       break
   end
end