hold on;
%syms Sx x n real;
%assume(-pi <= x <= pi);
ax = -pi : 0.1 : pi;
%Sx = 2/pi*((1+(-1)^n) * sin(x*n) / n);
n=1;
S1=0;
%disp(S1);
while n<1000
   S1=S1+2/pi*((1-(-1)^n) * sin(x*n) / n);
   S1=subs(S1,n,n);
   n=n+1;
end;
plot(ax, vpa(subs(S1,x,ax)));


syms sn x n
sn = 0;
for n = 1:1:10
    sn = sn+2/pi*(1-(-1)^n)/n * sin(x*n);
    sn=subs(sn,n,n);
    p = plot(ax, vpa(subs(sn,x,ax)+2));
    set(p, 'Color','Red','LineWidth',2);
end
%set(p, 'Color', 'red', 'LineWidth', 2);


%eps = 0.1;
%while (eps > 0.001)
%p = plot(ax, vpa(subs(Sx, x, ax)) + eps);
%set(p, 'Color', 'black', 'LineWidth', 2);
%p = plot(ax, vpa(subs(Sx, x, ax)) - eps);
%set(p, 'Color', 'black', 'LineWidth', 2);

%syms Sn;
%N = fix((1 + 11*eps) / (7*eps) + 1);    
%Sn = symsum((-1)^n * (x^n) / (7*n - 11), n, 1, N);
%p = plot(ax, vpa(subs(Sn, x, ax)));
    
   %eps = eps / 10;
%end;