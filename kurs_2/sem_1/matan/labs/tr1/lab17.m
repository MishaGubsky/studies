syms x an Fx1 Fx2 S n
assume (-1<x<1);
Fx1=((-1)^(n-1))*x^(2*n+1)/(2*n+1);
Fx2=x^(2*n+1)/(2*n+1);
an=simplify(symsum(diff(Fx1,x),n,0,inf));
S=int(simplify(an),x);
an=simplify(symsum(diff(Fx2,x),n,0,inf));
S=S+int(simplify(an),x);
disp(S);