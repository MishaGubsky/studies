hold on
syms Fx fx f x n w
assume (-1<w<1);
f=exp(-2*x);
Fx=fourier(f,w)
Fu=(int(f*exp(-1i*w*x),x,0,inf))%/sqrt(2*pi);
fx=ifourier(Fu,w)
ax=0:0.1:10;
plot(ax,vpa(subs(fx,ax)));
