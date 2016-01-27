syms n S Un
x=1/3;
S=limit(((n*6^n)/((n+1)*11^n)^(1/n)),n,inf);
%S=limit(S,n,inf);
%S=solve(x^2<1);
disp(simplify(S));