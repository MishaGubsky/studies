syms x y
syms x y Left Right
syms x_new y_new real;
Left='D2y+4*Dy+4*y=x*cos(x)';
y=simplify(dsolve(Left,'x'));
pretty(y);
x_new=-pi:0.1:pi;
for cycle1=-5:1:5;
    y_new=subs(y,'C18',cycle1);
    for cycle2=-3:1:3
        y_new=subs(y_new,'C19',cycle2);
        y_new=((subs(y_new,x_new)));
        plot(x_new,y_new);
        hold on
    end;
end;





