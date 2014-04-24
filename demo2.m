r=k;temp=10e7;

for i=1:5
        [w,h]=nmfro(Final_v,r,.001);
        [d,index]=max(h);
        for iteration=1:10
            [temp_w,temp_h]=nmfro(Final_v,r,.001);
            for iteration0=1:r
                Cluster=find(index==iteration0);
                if size(Cluster,2)~=0
                    [d,temp_index]=max(temp_h(:,Cluster));
                    temp_Cluster=round(sum(temp_index)/size(Cluster,2));
                     temp_plus=find(temp_index==temp_Cluster);
                      if size(temp_plus,2)~=0
                          w(:,index(Cluster(1)))=temp_w(:,temp_Cluster)+w(:,index(Cluster(1)));
                          h(index(Cluster(1)),:)=temp_h(temp_Cluster,:)+h(index(Cluster(1)),:);
                      end
                end
            end
        end
        w=w/(iteration+1); h=h/(iteration+1);
[W,H] =normalization_W_H(w,h);
clear w h;
[aa,bb] = simthresholding(Final_v,W,H');
[a,b] = dirivatithres2(Final_v,100,.0001,W,H',aa,bb);
ww=signstar(W,a);
hh = signstar(H',b);
if temp>norm(Final_v-ww*hh,'fro')
    temp=norm(Final_v-ww*hh,'fro');
    Final_ww=ww;
    Final_hh=hh;
end
end
