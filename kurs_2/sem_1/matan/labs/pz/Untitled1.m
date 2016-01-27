syms a0 n bn cn f1 Fx f2 x ax
f1=x+pi;
f2=-x-pi;
subplot(1,3,1);
a0=(int(f1,x,-pi,0)+int(f2,x,0,pi))/(2*pi)
an=(int(f1*cos(n*x),x,-pi,0)+int(f2*cos(n*x),x,0,pi))/(pi)
bn=(int(f1*sin(n*x),x,-pi,0)+int(f2*sin(n*x),x,0,pi))/(pi)
Fx=a0+symsum(an*cos(n*x)+bn*sin(n*x),n,-pi,pi)
ax=-pi:0.1:pi;
plot(ax,vpa(subs(Fx,ax)));
subplot(1,3,2);
ck=sqrt(an^2+bn^2)
line([0,0],[0,abs(a0)],'Marker','o');
for ax=1:1:5
    R=vpa(subs(ck,ax));
    line([ax,ax],[0,R],'Marker','o');
end;
subplot(1,3,3);
fi=atan(bn/an)

for ax=0:1:5
    R=vpa(subs(fi,ax));
    line([ax,ax],[0,R],'Marker','o');
end;