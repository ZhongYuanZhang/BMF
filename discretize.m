function [Final_v,Final_UP,Final_DOWN,Final_N,acc] = discretize(V,k,up,down,n)

%============================================
% get the classlabel .
acc=0;
Final_v=0;Final_UP=0;Final_DOWN=0;Final_N=0;sparse=1;
Consensus = consensus(V,k,k,10,0);
[ordcons,clustid] = reorder(Consensus,k,k);
classlabel=clustid(:,k);

clear Consensus ordcons clusterid;
%=============================================

%=============================================
% get the discretized matrix v.
temp=zeros(size(V,1),size(V,2));
for i=1:size(up,2)
    for j=1:size(down,2)
        for l=1:2
            if up(i)==down(j)
                continue
            end
            if n(l)==1
                v=100*V./repmat(sqrt(sum(V.^2)),size(V,1),1);Mean=mean(v,2);UP=up(i)*Mean;DOWN=down(j)*Mean;
            else
                v=V;Mean=mean(v,2);UP=up(i)*Mean;DOWN=down(j)*Mean;
            end
            for kk=1:size(V,1)
                ll=find((v(kk,:)>=UP(kk))|(v(kk,:)<=DOWN(kk)));
                temp(kk,ll)=1;
            end
            clear kk ll;
            v=temp;temp=zeros(size(V,1),size(V,2));
 % get the discretized matrix v. 
 %=====================================================            
            temp2=10e7;
            for iteration1=1:5
                [w,h]=nmfro(v,k,.001);
                [d,index]=max(h);
                for iteration=1:10
                    [temp_w,temp_h]=nmfro(v,k,.001);
                    for iteration0=1:k
                        Cluster=find(index==iteration0);
                        if size(Cluster,2)~=0
                            [d,temp_index]=max(temp_h(:,Cluster));
                            temp_Cluster=round(sum(temp_index)/size(Cluster,2));
                            temp_plus=find(temp_index==temp_Cluster);
                            if size(temp_plus,2)~=0
                                w(:,index(Cluster(temp_plus(1))))=temp_w(:,temp_Cluster)+w(:,index(Cluster(temp_plus(1))));
                                h(index(Cluster(temp_plus(1))),:)=temp_h(temp_Cluster,:)+h(index(Cluster(temp_plus(1))),:);
                            end
                        end
                    end
                end
                w=w/(iteration+1); h=h/(iteration+1);
                [d,index]=max(h);
                clear temp_w temp_h iteration iteration0;
                clusterlabel=index';
                [newacc,nmi]=clusterQua(classlabel,clusterlabel);
                clear Final_h Final_w temp_acc clusterlabel;
                if (newacc>.75)&(newacc>=acc)
                    [ww,hh] = demo6(v,w,h,k);
                    clear  newacc;
                    if temp2>norm(v-ww*hh,'fro')
                        temp2=norm(v-ww*hh,'fro');
                        for iteration3=1:size(hh,2)
                            if sum(hh(:,iteration3))==1
                                index_1=find(hh(:,iteration3)==1);
                                clusterlabel(iteration3)=index_1;
                            else
                                clusterlabel(iteration3)=k+1;
                            end
                        end
                        clear iteration2 index_1;
                        temp_sum0=size((find(sum(hh,1)==0)),2);
                        temp_sum2=size((find(sum(hh,1)==2)),2);%non-zero coloumns are dominant.
                        [newacc,nmi]=clusterQua(classlabel,clusterlabel');
                        clear clusterlabel;
                        if (newacc>=acc)&(temp_sum0<=2)&(temp_sum2<2)
                            acc=newacc;
                            clear newacc newsparse;
                            Final_v=v;Final_UP=up(i);Final_DOWN=down(j);Final_N=n(l);
                            if acc>.99
                                return
                            end
                        end
                    end
                end
            end
        end
    end
end

function [ww,hh]=demo6(V,w,h,k)
[W,H] =normalization_W_H(w,h);
[aa,bb] = simthresholding(V,W,H');
[a,b] = dirivatithres2(V,100,.0001,W,H',aa,bb);
ww=signstar(W,a);
hh = signstar(H',b);