hold on;
axis([0 pi 0 10])
syms Sx S n x p;
ax = 0 : 0.001: pi;
Sx = (pi-x)*((cos(n*x))^2)/((n^7+1)^(1/4));
S=vpa(symsum(Sx,n,0,100));
p=plot(ax, vpa(subs(S, x, ax)));
set(p, 'Color', 'red', 'LineWidth', 2);

e=0.3;
p=plot(ax, vpa(subs(S, x, ax))+e);
set(p, 'Color', 'black', 'LineWidth', 2);
p=plot(ax, vpa(subs(S, x, ax))-e);
set(p, 'Color', 'black', 'LineWidth', 2);

Sx=pi*1.1/((n^7+1)^(1/4));
S1=vpa(symsum(Sx,n,0,100));
p=plot(ax, vpa(subs(S1, x, ax)));
set(p, 'Color', 'blue');
