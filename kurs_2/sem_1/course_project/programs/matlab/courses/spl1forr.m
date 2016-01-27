function [x]=spl1forr(n)
% [x]=spl1forr(n) 
% расчет кубического эрмитового базисного сплайна 
% на равномерной сетке
% n  число точек на фрагменте

 dt=1/(n);
 i=1;
 for a = 0:dt:1,
        b = 1 - a     ;
        c = a * b * b ;
        d = a * a * b ;
        x(i+n+n+n) = - c/2  ;
        x(i+n+n)   =   c  - d/2 + b ;
        x(i+n)     = - c/2  + d + a ;
        x(i)       = - d/2  ;
        i=i+1;
 end
