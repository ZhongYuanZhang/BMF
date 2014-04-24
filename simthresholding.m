function [w,h] = simthresholding(V,W,H)
II=max(max(H,[],2)');
testh=[0:.01:II];%discretize h and w;
[m,n]=size(testh);
ll=max(max(W,[],2)');
testw=[0:.01:ll];
[mm,nn]=size(testw);
temp=1e10;
  for i=1:n
        for j=1:nn
            newH=signstar(H,testh(i));
            newW=signstar(W,testw(j));
            newtemp=norm(V-newW*newH,'fro');
            if newtemp<temp
                temp=newtemp;
                h=testh(i);
                w=testw(j);
            end
        end
  end