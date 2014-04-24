function [W,H] =normalization_W_H(W,H)
H=H';;
D_W=diag(max(W));
D_H=diag(max(H));
D_W_1_2=sqrt(D_W);;
D_H_1_2=sqrt(D_H);
Inver_D_W=inv(D_W);
Inver_D_W_1_2=sqrt(Inver_D_W);
Inver_D_H=inv(D_H);
Inver_D_H_1_2=sqrt(Inver_D_H);
W=W*Inver_D_W_1_2*D_H_1_2;
H=H*Inver_D_H_1_2*D_W_1_2;