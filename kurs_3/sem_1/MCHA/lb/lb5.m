%%%%%%%%%%%%%%%Метод сеток решения волнового уравнения%%%%%%%%%%%%%%%%%%%%%
function lb5()
    k = 7;
    a = sin(k);
    b = cos(k);
    presition = 0.1;
    
    syms f(x, t) inital_cond(x) lbound_cond(t) rbound_cond(t)
    f(x, t) = a*t + b*x + 1;
    inital_cond(x) = x*(x - 1);
    lbound_cond(t) = 0;
    rbound_cond(t) = 0;
    
    clc
    disp('Уравнение: d2u/dt2 - d2u/dx2 = f(x, t), 0 < x < 1, 0 < t < T');
    disp('Начальные условия: u(x, 0) = x^2 / 2, u''(x, 0) = x');
    disp('Граничные условия: u(0, t) = 0, u(1, t) = 0');
    fprintf('\n');
    
    U = vpa(grid_method(f, inital_cond, diff(inital_cond), lbound_cond, rbound_cond, presition, presition));
    
    n = 1 / presition;
    disp('Решение уравнения в узлах сетки:');
    for i = 2: round(n / 5): n - 1
        for j = 2: round(n / 5): n - 1
            fprintf('(x = %.1f, y = %.1f): %f\n', (i - 1) * presition, (j - 1) * presition, double(U(i, j))); 
        end
    end
end


function Y = grid_method(f, ro, q, lbound_cond, rbound_cond, h, t)
    n = round((0 + 1) / h) + 1;
    m = round((0 + 1) / t) + 1;
    wx = 0: h: 1;
    wt = 0: t: 1;
    
    Y = zeros(m, n);
    Y(1, :) = ro(wx);
    Y(2, :) = ro(wx) + t*q(wx) + t^2 / 2 * (f(wx, wt(1))  - subs(diff(ro), wx));
    Y(:, 1) = lbound_cond(wt);
    Y(:, n) = rbound_cond(wt);
    for v = 2: 1: m - 1
        for k = 2: 1: n - 1
            Y(v+1, k) = t^2 * f(wx(k), wt(v)) + (2 * Y(v, k) - Y(v-1, k)) + (2 * Y(v, k) - Y(v, k-1) - Y(v, k+1)) * t^2 / h^2;
        end 
    end
end