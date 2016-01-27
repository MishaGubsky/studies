hold on;
syms Sx S n x;
assume(-pi <= x <= 0);

ax = 0 : 0.001: 1;
Sx = (-1)^n*(x^n)/((n^3-2)^(1/3));
S=symsum(Sx,n,0,100);
p=plot(ax, vpa(subs(S, x, ax )));
set(p, 'Color', 'green', 'LineWidth', 2);

eps = 0.1;
p = plot(ax, vpa(subs(S, x, ax)) + eps);
set(p, 'Color', 'red', 'LineWidth', 2);
p = plot(ax, vpa(subs(S, x, ax)) - eps);
set(p, 'Color', 'red', 'LineWidth', 2);

syms Sn ;
M = fix(solve(1/(((n+1)^3-2)^(1/3))==eps)+1);   
Sn = symsum(Sx, n, 0, M(1));
p = plot(ax, vpa(subs(Sn, x, ax)));
    
