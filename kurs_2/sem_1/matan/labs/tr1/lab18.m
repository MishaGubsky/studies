syms x an Fx S n x0
assume(-1<x<1);
Fx=2*n^2*x^n+8*n*x^n-5*x^n;
S=symsum(Fx,n,0,inf);
disp(S);