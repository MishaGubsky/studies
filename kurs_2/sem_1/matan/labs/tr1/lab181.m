syms f1 f2 f3 n x s
assume(-1<x<1);
s = symsum(x^n,n,0,inf);
f1 = simplify(-5*s);
f2 = simplify(8*x*diff(symsum(int(n*x^(n-1)),n,0,inf)));
f3 = simplify(2*x^2*diff(diff(symsum(int(int(n^2*x^(n-2))),n,0,inf))));
disp(simplify(f1+f2+f3));