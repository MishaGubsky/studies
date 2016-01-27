assume(-1 <= x <= 1);

hold on
syms x n ak Fx fx;
%ak=sin(x)/(sqrt(2*pi)*x);
%bk=0;

ck=1/sqrt(2*pi)*int((1+x)*exp(-1i*x*n),x,-1,0);
ck=ck+1/sqrt(2*pi)*int((1-x)*exp(-1i*x*n),x,0,1)

Fx = 1/sqrt(2*pi)*int(ck*exp(1i*n*x),x,-1,1);

n=-1:0.001:1;
assume(-1 <= x <= 1);

plot(n,vpa(subs(Fx,n)));
   % R=2/sqrt(2*pi)*int(sin(x)/x*exp(1i*n*x),x,-50,50);
   % plot(n,vpa(subs(R,n)));
