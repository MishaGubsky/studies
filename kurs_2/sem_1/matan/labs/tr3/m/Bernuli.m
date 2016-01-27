syms Y t at x
ax=-5:0.1:5;
Y=dsolve('Dy==y^2*log(x)/(3*x)-y/x','y(1)==3','x')
pretty(simplify(Y));
plot(ax,subs(Y,ax));
