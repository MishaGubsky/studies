syms x y
syms x y Left Right
syms x_new y_new real;
Left='D2y+4*Dy+4*y=x*cos(x)';
y=simplify(dsolve(Left,'x'))
pretty(y);
subplot(3,1,1);
x_new=0:0.1:10;
for cycle1=-5:1:5;
    y_new=subs(y,'C2',cycle1);
    for cycle2=-2:1:2
        y_new=subs(y_new,'C3',cycle2);
        y_new=((subs(y_new,x_new)));
        plot(x_new,y_new);
        hold on
    end;
end;

at=0:0.1:50;
y=subs(y,'C5',0);
Y=subs(y,'C6',0);
dY=diff(Y);

subplot(3,1,2);
plot(subs(dY,x,at),subs(Y,x,at));
subplot(3,1,3);
plot3(subs(dY,x,at),subs(Y,x,at),at);