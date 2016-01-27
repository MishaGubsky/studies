hold on
syms x fi n ak Fx fx a0;
bk=4*((-1)^(n+1))/n;
ak=0;
fi=simplify(asin((-1)^(n+1)/abs((-1)^(n+1))))

%ck=int((2*x+1)*exp(-1i*n*x),x,-pi,pi)%/(2*pi);

absck=abs(4*(-1)^(n+1)/n); 
ck=simplify(absck*(cos(fi)+1i*sin(fi)))

%ck=4*1i*(-1)^(n+1)/n; 
ak=real(ck)
bk=imag(ck)

Fx=1+symsum(ak*cos(n*x)+bk*sin(n*x),n,1,100)
x=-pi:0.01:pi;
p=plot(x,vpa(subs(Fx)))
set(p, 'Color', 'red', 'LineWidth', 1);