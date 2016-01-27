syms n Sn S;
Sn = symsum(7/(49*n^2-7*n-12),1,n);
S = limit(Sn,n,inf);
disp(S);