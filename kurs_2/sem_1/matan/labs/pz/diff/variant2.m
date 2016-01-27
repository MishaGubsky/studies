hold on
%f=simplify((dsolve((y^2)*diff(y)+x^2==1)))

%f=dsolve('Dy*y^2+x^2==1','x')
%pretty(f(1));

%X=-10:0.1:10;
%for C=-10:1:10;
%    plot(X,vpa(subs(subs(f,x,X),C)))
%end

syms x y P Q Dif_P_y Dif_Q_x
syms U Dif_Q Dif_fi_y Expr fi Answer

P='2*x+y';
Q='x+2*y';
Dif_Q=diff(U,y);
Dif_fi_y=Q-Dif_Q;

Dif_fi_y=subs(Dif_fi_y,'y','t')
Expr=['Dy=',char(Dif_fi_y)];
fi=subs(dsolve(Expr),'t','y')
Answer=sym(U)+sym(fi);
disp(Answer);
[x,y]=meshgrid(-5:.2:5,-5:.2:5);
for C8=1:1
    val=C8;
    z=inline(Answer);
    surfc(x,y,z(x,y,val));
    plot(x_new,y_new);
end;



%f=tan(y/2/x)-x;
%ydiff=-(diff(f,x))/(diff(f,y))