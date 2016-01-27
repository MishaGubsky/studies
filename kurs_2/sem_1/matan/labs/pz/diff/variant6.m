hold on
grid on
syms x y
res=dsolve('D2y-2*Dy=4*x^2*exp(x^2)','x');
disp(res);
y(x)=subs(res,'C18',0)
y(x)=subs(y,'C19',0)
dy(x)=diff(y(x));
x=-5:0.1:5;
plot(dy(x),y(x));