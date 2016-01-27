syms x sum xn y n f

assume(-5<y<5);
A=[0,1;-1,0];
y=dsolve('Dw==w*A','w(0)==0')
pretty(simplify(y));
ax=-5:0.1:5;
f=subs(y,'t',x);
subplot(1,2,1);
axis([-5 5 -5 5]);
hold on; 
s=x^3/factorial(3)-5*x^5/factorial(5)+31*x^7/factorial(7);
plot(ax,subs(s,ax));
plot(ax,vpa(subs(f,ax)),'r');
subplot(1,2,2);
y=dsolve('D2y==-x*Dy-y','y(0)==0','Dy(0)==0')
pretty(simplify(y));
ax=-1:0.001:1;
f=subs(y,'t',x);
hold on; 
s=0;
plot(ax,subs(s,ax));
plot(ax,vpa(subs(f,ax)),'r');