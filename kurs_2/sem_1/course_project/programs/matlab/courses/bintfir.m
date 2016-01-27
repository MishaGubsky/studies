function [Y,er,ph]=bintfir(x,b,nopre)
% [s,er,ph]=bintfir(x,b,nopre)
% Interpolation spline, composed from given basic splines,
% If the base not hermites, is applied prefilter
%  x  input datas
%  b  a basic spline, that consists of four fragments
%  nopre 0 - prefilter off (to Hermite spline) optional 1
%  s  of reference values
%  er an error of approximate account prefilter
%  ph coefficients of prefilter
%
%  also  preints, crbspl

%       I.V.Shelevitsky 27-05-02 Shelev@yahoo.com
%       Revised  02/08/03
%       Copyright (c) 2002 by the Shelevitsky
%

if nargin<3
   nopre=1;
end
[k,m]=size(b);
if k>m
   m=k;
   b=b';
end
m=fix(m/4);
ph=[];
er=0;
if nopre>0
   [ph,er]=preIntS(b(2*m+1),b(m+1));
   y=filter(ph,1,x);
else
   y=x;
end;
M=[b(3*m+1:4*m)',b(2*m+1:3*m)',b(m+1:2*m)',b(1:m)'];
[k,n]=size(y);
if k>n
   n=k;
   y=y';
end
s=M*[y(1),y(1:3)]';
Y=[s'];
for j=1:n-3
    s=M*y(j:j+3)';
    Y=[Y,s'];
end
s=M*[y(n-2:n),y(n)]';
Y=[Y,s'];
s=M*[y(n-1:n),y(n),y(n)]';
Y=[Y,s'];

