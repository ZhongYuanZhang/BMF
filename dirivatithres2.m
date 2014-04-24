function [w,h] = dirivatithres2(V,a,epsilon,W,H,w0,h0)
%plus linear search.
w=w0;
h=h0;
errate=norm(V-signstar(W,w0)*signstar(H,h0),'fro')^2;
while 1
    t=norm(V-phi(a,W-w)*phi(a,H-h),'fro')^2;
    %linesear
    Wstar=phi(a,W-w);
    Hstar=phi(a,H-h);
    d=-dff(a,V,W,H,Wstar,Hstar,w,h);
    if norm(dff(a,V,W,H,Wstar,Hstar,w,h))^2<epsilon
         break
    end
    i=1;
    alpha=2;
    Wstar_alpha=phi(a,W-w-alpha*d(1));
    Hstar_alpha=phi(a,H-h-alpha*d(2));
    sigma=0.1;
    delta=.4;
    tt=0;
    scalara=0;
    scalarb=10;
    while tt==0
       if .5*norm(V-phi(a,W-(w+alpha*d(1)))*phi(a,H-(h+alpha*d(2))),'fro')^2-.5*t<=alpha*sigma*dff(a,V,W,H,Wstar,Hstar,w,h)*d'
            if dff(a,V,W,H,Wstar_alpha,Hstar_alpha,w+alpha*d(1),h+alpha*d(2))*d'>=delta*dff(a,V,W,H,Wstar,Hstar,w,h)*d'
                tt=1;
            else
                if scalarb<10
                    scalara=alpha;
                    alpha=(scalara+scalarb)/2;
                    i=i+1;
                    if i==400
                        break
                    end
                else 
                    alpha=1.2*alpha;
                    i=i+1;
                    if i==400
                        break
                    end
                end
            end
        else
            scalarb=alpha;
            alpha=(scalara+scalarb)/2;
            i=i+1;
            if i==400
                break
            end
        end
    end
    alpha;
    %linesear
    w=w+alpha*d(1);
    h=h+alpha*d(2);
    if abs(norm(V-phi(a,W-w)*phi(a,H-h),'fro')^2-t)<epsilon
        break
    end
end
if norm(V-signstar(W,w)*signstar(H,h),'fro')^2>errate
    w=w0;
    h=h0;
end


