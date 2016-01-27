syms S n x
assume(-1<x<1)
S=symsum(n/(n+1),n,0,inf);
disp(S);