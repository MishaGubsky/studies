syms n S an a m
a=0.1;
n=1;
an=((-1)/3);
while abs(an)>=a
    n=n+1;
    an=((-1)^n*n^2)/(3^n);
end
S=symsum(((-1)^m*m^2/(3^m)),m,1,n-1);
disp(S);