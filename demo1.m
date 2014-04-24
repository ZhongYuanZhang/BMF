clear 

V=load('ALL-AML gene expression data.txt');

k=2;

[Final_v,Final_UP,Final_DOWN,Final_N,acc] = discretize(V,k,[1 2 3 4 5 6 7 8 9],[1/3 1/5 1/7 1/9 1],[0 1]); % discretize the original micro-array matrix.

demo2; % get the bi-cluster results

[row, column]=find(ww==1); % select the active genes.

