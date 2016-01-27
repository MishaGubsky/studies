hold on;
x = 0:10;  y = sin(x);
xx = 0:.25:10;
yy = spline(x,y,xx);
plot(x,y,'o',xx,yy);
plot(x,vpa(subs(y)),'r');