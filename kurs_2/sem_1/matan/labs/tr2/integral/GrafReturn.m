hold on
syms x Fx fx a0 w absck;
%ck=int(exp(-1i*w*x),x,0,100)/sqrt(2*pi)
%x=-pi:0.01:pi;
%Fx=int(ck*exp(1i*w*x),w,1,2)/sqrt(2*pi)
%plot(x,vpa(subs(Fx,x)));


%ak=((-1)^w*2*sinh(2*pi))*2/(4+w^2);
%bk=((-1)^(w+1)*2*sinh(2*pi))*w/(4+w^2);
assume(0<w<pi)
absck=1/sqrt(w^2+4);
Fi=atan(w/2);
Fabs=(2-1i*w)/(w^2+4);
Fx=absck*exp(1i*atan(w/2))
%ak=real(absck*(cos(fi)+1i*sin(fi)))
fx=(int(Fabs*exp(1i*w*x),w,-10,10))/(2*pi)
ax=0:0.1:10;
plot(ax,vpa(subs(fx,ax)))

