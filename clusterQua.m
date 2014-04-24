function[acc,nmi]=clusterQua(classLabel,clusterLabel);

classNum=max(classLabel)+1;
clusterNum=max(clusterLabel)+1;
N=size(clusterLabel,1);
acc=0;

for j=1:classNum
	clusterPos{j,1}(1,1)=-1;
end

for i=1:N
	col=size(clusterPos{classLabel(i,1)+1,1},2);
	if(clusterPos{classLabel(i,1)+1,1}(1,1)==-1)
		clusterPos{classLabel(i,1)+1,1}(1,1)=i;
	else
		clusterPos{classLabel(i,1)+1,1}(1,col+1)=i;
	end
end
i=1;
while(i<=size(clusterPos,1))
    if(clusterPos{i,1}(1,1)==-1)
        clusterPos(i)=[];
        classNum=classNum-1;
        i=i-1;
    end
    i=i+1;
end
count=1; 
classes=zeros(clusterNum,1);
classSum=zeros(classNum,1);
clusterSum=zeros(clusterNum,1);
for i=1:classNum
	num=size(clusterPos{i,1},2);
    
	for j=1:num
		pos=clusterLabel(clusterPos{i,1}(1,j),1)+1;
		classes(pos,1)=classes(pos,1)+1;
		
	end
	maxClass=0;
	for j=1:clusterNum
		if(maxClass<classes(j,1)) 
			maxClass=classes(j,1);
		end
		classClust(count,j)=classes(j,1);
        classSum(count,1)=classSum(count,1)+classes(j,1);
        clusterSum(j,1)=clusterSum(j,1)+classes(j,1);
    end
	count=count+1;    
	for j=1:clusterNum
		classes(j,1)=0;
    end
end
%---------------------------Normalized mutual information
clusterEnt=0;classEnt=0;nmi=0;
for j=1:clusterNum
    if(clusterSum(j)~=0)
        clusterEnt=clusterEnt-(clusterSum(j)/N)*log2(clusterSum(j)/N);
    end
end
for i=1:classNum
    if(classSum(i)~=0)
        classEnt=classEnt-(classSum(i)/N)*log2(classSum(i)/N);
    end
    for j=1:clusterNum
        if(classClust(i,j)~=0)
            nmi=nmi+(classClust(i,j)/N)*log2((N*classClust(i,j))/(classSum(i)*clusterSum(j)));
        end
    end
end
nmi=nmi/max(clusterEnt,classEnt);
%disp(classClust);
%---------------------------accuracy-------------------------------------
round=clusterNum*clusterNum*10;
previousClass=classClust;
while(round>0)
	diaSum=0;
	for i=1:classNum
		electedNums(1,i)=i;
	end
	
	for i=1:min(classNum,clusterNum)
		electedRow=ceil(rand*size(electedNums,2));
        	maxValue=0;
		col=1;
		for j=1:size(classClust,2)
			if(classClust(electedNums(1,electedRow),j)>maxValue)
                		col=j;
                		maxValue=classClust(electedNums(1,electedRow),j);
            	end
        	end
		diaSum=diaSum+maxValue;
		classClust(:,col)=[];
		electedNums(:,electedRow)=[];
	end
	if(diaSum>acc) 
		acc=diaSum;
	end
	round=round-1;
	classClust=previousClass;
end

acc=acc/N;
