syms ck n real bk ak fik
ck=1/pi*(2/n-2*(-1)^n/n)*sin(n*x);
fik=(1-(-1)^n)*pi/4;
n=0:1:100;
S=symsum(ck,n,1,500)
ax=0:pi/200:10;
%bk=simplify(sin(fik)*abs(ck));%(symsum(subs(sin(fik)*abs(ck),n),n,1,inf));
%ak=simplify(subs(cos(fik),n)*subs(abs(ck),n))
p=plot(ax,vpa(subs(S,x,ax)));