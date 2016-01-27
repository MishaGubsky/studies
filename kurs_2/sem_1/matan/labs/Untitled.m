syms t y(t) Y
Y=simplify(dsolve('D2y(t)-9*y(t)==0','y(0)==1','Dy(0)==1','t'));
at=0:0.1:3;

subplot(2,1,1);
plot(at,subs(Y,t,at));


subplot(2,1,2);
dY=diff(Y);
plot(subs(dY,t,at),subs(Y,t,at));