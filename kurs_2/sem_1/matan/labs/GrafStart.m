
hold on
syms x n bk ak Fx fx a0;

bk=(int((2*x+1)*sin(n*x),x,-pi,pi))/pi
ak=(int((2*x+1)*cos(n*x),x,-pi,pi))/pi
a0=(int(2*x+1,x,-pi,pi))/(2*pi);

Fx =a0+symsum(ak*cos(n*x)+bk*sin(n*x),n,1,100);

x=-pi:0.01:pi;
plot(x,y);

    
 
