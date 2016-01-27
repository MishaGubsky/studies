%%%%%%%%%Метод сеток решения задачи Дирихле для уравнения Пуассона%%%%%%%%%
function lb41()
    k = 4;
    a = sin(k);
    b = cos(k);
    presition = 0.1;

    syms f(x, y)
    f(x, y) = a*x^2 + b*y^2 + 1;
    
    clc;
    
    U = simple_iteration_method(f, presition);
    
    n = 1 / presition;
   
    for i = 2: round(n / 10): n - 1
        for j = 2: round(n / 10): n - 1
            fprintf('(x = %f, y = %f): %f\n', (i - 1) * presition, (j - 1) * presition, U(i, j)); 
        end
    end
end


function U = simple_iteration_method(f, h)
    n = floor((0 + 1) / h);
    presition = 0.001;
    
    du = 1;
    U = zeros(n);
    while (du > presition)
        du = 0;
        new_u = zeros(n);
        for i = 2: 1: n - 1
            for j = 2: 1: n - 1
                new_u(i, j) = 0.25 * (U(i-1, j) + U(i+1, j) + U(i, j-1) + U(i, j+1) + h^2 * f(i*h, j*h));
                du = max(abs(new_u(i, j) - U(i, j)), du); 
            end
        end
        U = new_u;
    end
end