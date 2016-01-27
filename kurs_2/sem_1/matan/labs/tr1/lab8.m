syms an  Sn n d l l1;
an = ((-1)^(n+1)) / (n*(2*n+3)^(1/4));

d = simplify(subs(an, n+1) / an);
assume(n > 1);
l = limit(an, n, inf)
if (l == 0)
    l1 = limit(simplify(subs(an, n+1) / an), n, inf);
    if (l1 < 1)
        disp('Ряд сходится абсолютно');
    else 
        disp('Ряд сходится условно');
    end;
else
    disp('Ряд расходится');
end;

