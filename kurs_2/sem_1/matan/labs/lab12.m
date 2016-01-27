syms n fn fn1 x L;
fn = 9^n*x^(2*n)*sin(3*x-pi*n)/(2*n);
fn1=subs(fn,n,(n+1));
L=limit(abs(simplify(fn1/fn)),n,inf);
roots=solve(L==1,x);
roots = sort(roots);
roots=cat(1,inf,roots);
roots=cat(1,roots,inf);
for i=1:1:length(roots)-1
    dot=(roots(i)+roots(i+1))/2;
    if (abs(subs(L,dot))<1)
        fprintf('(%s;%s) ',char(roots(i)),char(roots(i+1)));
    end;
end;
fprintf('-равномерная сходимость\n');



syms  a Sn n l l1;
roots=solve(L==1,x);
for i=1:1:length(roots)
   fn=subs(fn,x,roots(i));
   l = limit(fn, n, inf);
    if (l == 0)
        l1 = limit(abs(simplify(subs(fn, n+1) / fn)), n, inf);
        if (l1 < 1)
            fprintf('в %s сходится абсолютно\n',char(roots(i)));
        else 
            fprintf('в %s сходится условно\n',char(roots(i)));
        end;
    else
        fprintf('в %s расходится\n',char(roots(i)));
    end;
   
end;




