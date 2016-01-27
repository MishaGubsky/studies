syms x an F S n x0 e Sn
F=exp(-3*x^2);
S=0;
e=0.001;
x0=0;
i=0;

an=diff(F,x,i);
an=subs(an,x0);
an=an*x^i/factorial(i);
Sn=int(an,x,0,0.2);
    
while ((abs(Sn) > e)||(Sn == 0))
    S=S+Sn;
    i=i+1;
    an=diff(F,x,i);
    an=subs(an,x0);
    an=an*x^i/factorial(i);
    Sn=int(an,x,0,0.2);
end;
 disp(S);