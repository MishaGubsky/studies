





tol = (.05)^2*(2*pi);

x = linspace(0,2*pi,51);
noisy_y = cos(x) + .2*(rand(size(x))-.5);
plot(x,noisy_y,'x')
axis([-1 7 -1.2 1.2])
fnplt( csapi(x, noisy_y));
%fnplt( spaps(x, noisy_y,  tol), 'r', 2 )

noisy_y([1 end]) = mean( noisy_y([1 end]) );
lx = length(x);
lx2 = round(lx/2);
range = [lx2:lx 2:lx 2:lx2];
sps = spaps([x(lx2:lx)-2*pi x(2:lx) x(2:lx2)+2*pi],noisy_y(range),2*tol);
hold on
fnplt(sps, [0 2*pi], 'k', 2)
hold off
