syms x y n
y(x)=1+1*exp(-x)-symsum(cos(n*x)/(n^2*(n^2+1))+sin(n*x)/(n^2*(n^2+1)),n,1,50)
dy(x)=diff(y(x));
x=-40:1:40;
subplot(1,2,1);
plot(dy(x),y(x));
subplot(1,2,2);
plot3(subs(dy(x),x),subs(y(x),x),x);