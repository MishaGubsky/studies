
hold on
syms x w bk ak Fx fx;

fx=exp(-2*x);

%((-1)^(w+1))*2*sinh(2*pi)/pi/(-2*-1i*w)
%int(fx*exp(-1i*w*x),x,-pi,pi)
ak=int(fx*cos(w*x),x,0,inf)/pi%real(ck)
bk=int(fx*sin(w*x),x,0,inf)/pi%imag(ck)
Fx=int(ak*cos(w*x)+bk*sin(w*x),w,0,inf)

X=0:0.1:pi;
plot(X,vpa(subs(fx,X)));