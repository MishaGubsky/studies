hold on
syms x y C1 C2
t=[-pi:0.3:pi];
s=dsolve('Dx=-x','Dy=-2*y');
x=subs(s.x); y=subs(s.y);
for C5=[-2:2]
    for C6=[-2:2]
        fx=subs(x)*10
        fy=subs(y)
        plot(fx,fy);
        px=gradient(fx);
        py=gradient(fy);
        quiver(fx,fy,px,py,0.6);
    end;
end;