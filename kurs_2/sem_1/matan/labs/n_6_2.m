clc;
clear all;
syms res r t
W(t) = [cos(t) sin(t); -sin(t) cos(t)];
res = W(t)*W(0)^(-1)*[1;1]+W(t)*int(W(r)^(-1)*[sin(r);0],r,0,t);
disp(simplify(res))
t_new = -50:0.1:50;
plot(subs(res(1),t,t_new),subs(res(2),t,t_new))
