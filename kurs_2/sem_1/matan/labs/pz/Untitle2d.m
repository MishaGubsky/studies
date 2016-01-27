syms f x n a0 Fx an bn fi absck Freturn
assume(0<x<pi);
a0=int((x+pi),x,-pi,0)/2/pi+int((x-pi),x,0,pi)/2/pi
an=int((x+pi)*cos(n*x),x,-pi,0)/pi+int((x-pi)*cos(n*x),x,0,pi)/pi
bn=int((x+pi)*sin(n*x),x,-pi,0)/pi+int((x-pi)*sin(n*x),x,0,pi)/pi

subplot(1,4,1);
Fx=a0+symsum(an*cos(n*x)+bn*sin(n*x),n,1,30)
ax=-pi:0.1:pi;
plot(ax,vpa(subs(Fx,ax)))

subplot(1,4,2);
absck=sqrt(an^2+bn^2);
line([0,0],[0,a0],'Color','r','Marker','o');
for ax=1:1:10
    R=vpa(subs(absck,ax));
    line([ax,ax],[0,R],'Color','r','Marker','o');
end;

subplot(1,4,3);
fi=atan(bn/an);
for ax=0:1:10
    R=vpa(subs(fi,ax));
    line([ax,ax],[0,R],'Color','r','Marker','o');
end;


subplot(1,4,4);
ck=absck*exp(1i*atan(bn/an))
%Freturn=ifourier(ck)
Freturn=int(ck*exp(1i*n*x),n,0,10)%/2/pi
ax=-pi:0.1:pi;
plot(ax,vpa(subs(Freturn,ax)))