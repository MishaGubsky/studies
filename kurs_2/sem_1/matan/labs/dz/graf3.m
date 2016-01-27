hold on;
syms Sx S n x;
assume(-pi <= x <= 0);

ax = 0 : 0.001: 1;
Sx = 2*(1-(-1)^n)/n^2*cos(n*x);
S=symsum(Sx,n,1,100);
p=plot(ax, vpa(subs(S, x, ax )));
set(p, 'Color', 'green', 'LineWidth', 2);


    
