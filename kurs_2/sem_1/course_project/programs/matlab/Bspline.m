hold on
points = [7.111 6.451;5.1 8.415;1.833 5.314;5.301 7.333;3.883 5.936;2.826 7.077;0.798 5.208;2.035 7.726;0.18 2.73;1.22 3.458;2.69 4.004;3.626 3.744].';
values = spcrv(points,3)
plot(points(1,:),points(2,:),'k','LineWidth',1.3);
%axis([-2 2.25 -2.1 2.2]);
plot(values(1,:),values(2,:),'r','LineWidth',1.5);
fnplt(cscvn(points), 'g',1.5);%конец функции [yy, C] = mycubic(x, y, xx)
legend({'Control Polygon' 'B-Spline Curve' 'Interpolating Spline Curve'},'location','SE');