function [B,M]=crbspl(f1,f2)
% [B,M]=crbspl(f1,f2)
% Creation in B-spline by a convolution of local
% symmetric functions
% f1,f2 - Local symmetric functions
% B - B-spline
% M - Interpolational matrix
%

%       I.V.Shelevitsky 27-05-02
%       Revised  27/05/02
%       Copyright (c) 2002 by the Shelevitsky
%       Shelev@yahoo.com

n1=length(f1);
n2=length(f2);
if n1~=n2
   error('f1,f2 different length')
end
B=conv(f1,f2);
n=fix(n1/2);
B=B/(n-1);
B=B(1:4*n);
M=[B(1:n)',B(n+1:2*n)',B(2*n+1:3*n)',B(3*n+1:4*n)'];
