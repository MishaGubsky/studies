syms x y
res=dsolve('D3y-Dy=1/cos(x)','x');
disp(res);
y(x)=log((1-tan(x/2))/(1+tan(x/2)))-x*cos(x)+log(abs(cos(x)))*sin(x)
%y(x)=subs(res,'C21',1);
%y(x)=subs(y,'C22',1);
%y(x)=subs(y,'C23',1);
%dy(x)=diff(y(x));
x=-10:0.01:10;
plot3(subs(dy,x),subs(y,x),x);