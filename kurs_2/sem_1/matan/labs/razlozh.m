syms x an Fx S n x0
Fx=log(1-2*x);
S=0;
x0=0;
S=symsum(Fx,x,0,n)
for i=1:1:10
    an=diff(Fx,x,i);
    an=subs(an,n);
    an=an*x^i/factorial(i);
    S=S+an;
end;
disp(simplify(S));