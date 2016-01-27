clc;
clear;
syms t 
y = simplify(dsolve('D2y(t)+4*Dy(t)+4*y(t)=t*cos(t),Dy(0) = -1,y(0) = 1'))
t_new = -30:0.1:30;
dy=diff(y)
    plot3(subs(dy,t,t_new),subs(y,t,t_new),t_new)
