syms n S Un a k
a=0.1;
n=1;
Un=((-1)/3);
while abs(Un)>=a
    n=n+1;
    Un=((-1)^n*n^2)/(3^n);
end
S=symsum(((-1)^k*k^2/(3^k)),k,1,n);
disp(S);