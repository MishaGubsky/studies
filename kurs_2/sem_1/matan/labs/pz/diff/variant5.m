syms x y
res=dsolve('D3y-Dy=1/cos(x)','x');
disp(res);
y(x)=subs(res,'C18',0);
y(x)=subs(y,'C19',0);
y(x)=subs(y,'C19',0);
dy(x)=diff(y(x));
x=-10:0.01:10;
plot3(subs(dy,x),subs(y,x),x);