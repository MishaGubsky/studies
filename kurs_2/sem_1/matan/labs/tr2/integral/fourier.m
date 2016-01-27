hold on
syms Fx fx f x n w Fu

f=exp(-2*x);
%Fx=fourier(f)
%W=-pi:0.1:pi;
%plot(W,vpa(subs(Fx,W))+1);



%W=0:0.1:5;
Fu=(int(f*exp(-1i*w*x),x,0,inf))/sqrt(2*pi)
%p=plot(W,vpa(subs(Fu,W)));

%fx=ifourier(Fx)
fx=(int(Fu*exp(1i*w*x),w,-10,10))/sqrt(2*pi);
fx=simplify(fx)
ax=0:0.1:10;
%disp(vpa(subs(fx,x,0)))
p=plot(ax,vpa(subs(fx,ax)))
set(p,'color','red');
