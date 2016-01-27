hold on
syms f F fi ck absck an bn a0 n x
assume(0<x<pi);
f=x;
a0=int(f,x,0,pi)/2/pi;
an=int(f*cos(n*x),x,0,pi)/pi;
bn=int(f*sin(n*x),x,0,pi)/pi
disp(subs(bn,1));
F=a0+symsum(an*cos(n*x)+bn*sin(n*x),n,1,10);
subplot(1,3,1)
subplot(1,3,1)
ax=-pi:0.1:5;
plot(ax,vpa(subs(F,ax)))

subplot(1,3,2)
hold on
absck=simplify(sqrt(bn^2+an^2))
line([0,0],[0,abs(a0)],'Color','r','Marker','o')
for ax=1:1:10
    R=vpa(subs(absck,n,ax));
    line([ax,ax],[0,R],'Color','r','Marker','o')
end;

subplot(1,3,3)
fi=atan(an/bn);
%line([0,0],[0,a0],'Marker','o')
for ax=0:1:10
    R=vpa(subs(fi,n,ax));
    line([ax,ax],[0,R],'Color','r','Marker','o')
end;