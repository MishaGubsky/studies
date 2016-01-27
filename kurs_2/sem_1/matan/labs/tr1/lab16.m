hold on;
axis([0 10 0 3.3])
syms Sx S n x p;
ax = 0 : 0.3: 100;
Sx = (pi-x)*((cos(n*x))^2)/((n^7+1)^(1/4));
for i=0 : 0.1: pi;
    S=simplify(subs(Sx,x,i));
    p=plot(ax, vpa(subs(S, n, ax)));
end;
Smx=pi*1.1/((n^7+1)^(1/4));
p = plot(ax, subs(Smx,ax));
set(p, 'Color', 'red', 'LineWidth', 2);


