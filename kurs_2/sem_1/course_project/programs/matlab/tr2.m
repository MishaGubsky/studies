syms x y yy C
hold on
xx = -4:0.001:8;

 x = [-4 -2.79 1.14 3.04 3.85 5.17 8];
 y = [-7.48  -5.56  1.25  3.77  6.94  0.42 3.69];
 [yy, C] = mycubic(x, y, xx);
 
 plot(x,y,'Color','black');
 
 fprintf('Matrix of coeff=\n');
 disp(C);
 
 plot(x, y, 'o', xx, yy,'LineWidth',2,'Color','r')
 %xlim([x(1)-0.1 x(end)+0.1])
 pp=spline(x,y);
 fnplt(pp);
 

 
 
 
 