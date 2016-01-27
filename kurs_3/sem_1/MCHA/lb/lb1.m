%%%%%%%%%%%%%%%%%%%%%%Решение краевых задач%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
syms y n x f1 f2 i fi k toSolve ;
aArray = sym('a%d',[ 1 9]);
a = -1;
b = 1;
hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%метод коллокаций%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%выбираем базисную систему
fi(n) = x^n * (1 - x);
y =  0 ;
n = 10;
for i=1:n-1
    y =  y + aArray(i) * fi(i);    %приближенное решение
end

psi(x) = sin(4) * diff(y,'x',2) + (1 + cos(4)*x*x)* y + 1;   %исходное уравнение
xEs = (-1 + 2/n):2/n:(1 - 2/n);       %точки коллокации                                       

for i=1:length(xEs)
    toSolve(i) = psi(xEs(i));
end
array = solve(toSolve == zeros(1,length(xEs)));

a(1) = double(array.a1);
a(2) = double(array.a2);
a(3) = double(array.a3);
a(4) = double(array.a4);
a(5) = double(array.a5);
a(6) = double(array.a6);
a(7) = double(array.a7);
a(8) = double(array.a8);
a(9) = double(array.a9);
disp('метод коллокаций');
disp(a);

ResultY(x) = subs(y,aArray,a);
plot(xEs,ResultY(xEs)-0.01,'green')


%%%%%%%%%%%%%%%%%%%%%%%%%%% интегральный метод%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = -1;
b = 1;
for i=1:length(xEs)
    I(i) = 2 * int ( psi(x) * diff(psi(x),aArray(i)),'x',a,b); 
end

array = solve(I == 0);
a(1) = double(array.a1);
a(2) = double(array.a2);
a(3) = double(array.a3);
a(4) = double(array.a4);
a(5) = double(array.a5);
a(6) = double(array.a6);
a(7) = double(array.a7);
a(8) = double(array.a8);
a(9) = double(array.a9);
disp('метод интегральный');
disp(a);

ResultY(x) = subs(y,aArray,a);
plot(xEs,ResultY(xEs), 'red');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% дискретный мнк%%%%%%%%%%%%%%%%%%%%%%%%%%
a = -1;
b = 1;
points = 100;
axis = a:(b-a)/points:b;
    S(1) = 0;
   
for i=1:length(axis);
    S = S + psi(axis(i))^2; 
end

for i=1:length(xEs)
    Ds(i) = diff(S,aArray(i)); 
end

array = solve(Ds == 0);
a(1) = double(array.a1);
a(2) = double(array.a2);
a(3) = double(array.a3);
a(4) = double(array.a4);
a(5) = double(array.a5);
a(6) = double(array.a6);
a(7) = double(array.a7);
a(8) = double(array.a8);
a(9) = double(array.a9);
disp('метод дискретный');
disp(a);
ResultY(x) = subs(y,aArray,a);
plot(xEs,ResultY(xEs)+0.01, 'blue');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% галеркина метод%%%%%%%%%%%%%%%%%%%%%%%%%
a = -1;
b = 1;
for i=1:length(xEs)
    I(i) = int (psi(x)*fi(i),x,a,b); 
end

array = solve(I == 0);
a(1) = double(array.a1);
a(2) = double(array.a2);
a(3) = double(array.a3);
a(4) = double(array.a4);
a(5) = double(array.a5);
a(6) = double(array.a6);
a(7) = double(array.a7);
a(8) = double(array.a8);
a(9) = double(array.a9);
disp('метод Голеркина');
disp(a);

ResultY(x) = subs(y,aArray,a);
plot(xEs,ResultY(xEs)+0.02, 'black');



