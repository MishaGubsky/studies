%%%%%%%%%%%%%%%%%%метод сеток решения уравнения теплопроводности%%%%%%%%%%%
clc;
clear;
reset(symengine);
syms u t tau v x p q ;
p(t) = t*t/2;
q(t) = 1/2 + 1/2 * t * t + t;
s(x) = 1 / 2 * x * x;
n = 20;
m = 20;
tau = 1/m;
h = 1/n;

%строим сетку 
matrix = zeros(n+1,m+1);
for i=2:n
    matrix(i,1) = s(h * (i-1));
end

for i = 1:m+1
    matrix(1,i) = p(tau *(i-1));
    matrix(n+1,i) = q(tau *(i-1));
end
f(t,x) =  sin(4) *t + cos(4)* x + 1;% наша функция

for i = 2:n
    for j = 2:m+1
        matrix(i,j) = tau / h^2 * matrix(i-1,j-1) + (1 - 2 * tau/h^2) * matrix(i,j-1) + tau / h^2 * matrix(i+1,j-1) + tau *f(j-1,i);
    end
end
%plot3(0:h:1,0:tau:1,matrix);
%figure(2);
%surf(matrix);
disp(matrix)