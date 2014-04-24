function y=dff(a,V,W,H,Wstar,Hstar,w,h)
    %gradient of the objective function.
    y=zeros(1,2);
    W_H_H=Wstar*Hstar*Hstar';
    V_H=V*Hstar';
    phi_W=a*exp(-a*(W-w))./(1+exp(-a*(W-w))).^2;
    W_H_H_phi_W=W_H_H.*phi_W;
    V_H_phi_W=V_H.*phi_W;
    W_W_H=Wstar'*Wstar*Hstar;
    W_V=Wstar'*V;
    phi_H=a*exp(-a*(H-h))./(1+exp(-a*(H-h))).^2;
    W_W_H_phi_H=W_W_H.*phi_H;
    W_V_phi_H=W_V.*phi_H;
    y(1)=sum(sum(V_H_phi_W-W_H_H_phi_W)');
    y(2)=sum(sum(W_V_phi_H-W_W_H_phi_H)');


