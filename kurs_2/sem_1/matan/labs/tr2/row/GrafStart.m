
hold on
syms x n bk ak Fx fx a0;

bk=4*(-1)^(n+1)/n;
ak=0
a0=(int(2*x+1,x,-pi,pi))/(2*pi)

Fx =a0+symsum(ak*cos(n*x)+bk*sin(n*x),n,1,100)

x=-pi:0.01:pi;
plot(x,vpa(subs(Fx,x)));

        
 
