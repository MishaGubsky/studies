%%%%%%%%%%%%%%%%%%%%%%%%метод разностных апроксимаций%%%%%%%%%%%%%%%%%%%%%%
clc;
syms y n x f1 f2 i fi k toSolve ;
n = 10;
yArray = sym('y%d',[ 1 n+1]);
a = -1;
b = 1;

h = (b - a) / n;
Y(1) = 0;
values = a:h:b;
equations(1) = subs( sin(4) * (yArray(2) - 2 * yArray(1)  + Y(1)) / h^2 + (1+ cos(4) * x^2)*yArray(1) + 1,'x',values(1));
for i=2:1:n-2
    equations(i) = subs(sin(4)*(yArray(i+1) - 2 * yArray(i) + yArray(i-1) ) / h^2 +  (1+ cos(4) *x^2)*yArray(i) + 1,'x',values(i));
end
equations(n-1) = subs( sin(4)*(- 2 * yArray(n-1)  + yArray(n-2)) / h^2 + (1+ cos(4)*x^2)*yArray(n-1) + 1,'x',values(n-1));

array = solve(equations ==0);
a(1) = 0;
a(2) = double(array.y1);
a(3) = double(array.y2);
a(4) = double(array.y3);
a(5) = double(array.y4);
a(6) = double(array.y5);
a(7) = double(array.y6);
a(8) = double(array.y7);
a(9) = double(array.y8);
a(10) = double(array.y9);
a(11) = 0;
disp(a);

plot(values, a)




