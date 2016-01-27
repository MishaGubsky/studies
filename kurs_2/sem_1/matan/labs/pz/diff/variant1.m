hold on
%f=simplify((dsolve((y^2)*diff(y)+x^2==1)))

%f=dsolve('Dy*y^2+x^2==1','x')
%pretty(f(1));

%X=-10:0.1:10;
%for C=-10:1:10;
%    plot(X,vpa(subs(subs(f,x,X),C)))
%end

syms x y Ur Title
syms x_new y_new Expr Message
Ur='y^2+2*x*y-x^2-C2';
Expr=['Dy=',char(Ur)];
y=dsolve(Expr,'x');
pretty(simplify(y));
x_new=-10:0.1:10;
y=subs(y,'x',x_new);
for cycle=-5:1:5
    val=cycle;
    y_new=subs(y,'C2',val);
    
    plot(x_new,y_new);
end;



%f=tan(y/2/x)-x;
%ydiff=-(diff(f,x))/(diff(f,y))