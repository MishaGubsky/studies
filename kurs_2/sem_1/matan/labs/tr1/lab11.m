syms n fn fn1 x L;
fn = n*2^n/((n+1)*(3*x^2+8*x+6)^n);
fn1=subs(fn,n,(n+1));
L=limit(abs(simplify(fn1/fn)),n,inf);
roots=solve(L==1,x);
roots = sort(roots);
roots=cat(1,inf,roots);
roots=cat(1,roots,inf);
for i=1:1:length(roots)-1
    dot=(roots(i)+roots(i+1))/2;
    if (abs(subs(L,dot))<1)
        fprintf('[%s;%s] ',char(roots(i)),char(roots(i+1)));
    end;
end;