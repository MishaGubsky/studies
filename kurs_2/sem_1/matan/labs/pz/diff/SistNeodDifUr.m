syms t tau F1 F
n=2;
A=[-1,-2;1,0];
X0=[1;1];
t0=0;
f=[0;t];
[LVector, Lambda]=eig(A);
E=magic(n);
for i=1:1:n
    for j=1:1:n
        if(i==j)
            E(i,j)=1;
        else
            E(i,j)=0;
        end;
    end;
end;


temp=sym(E);
k=1;
for i=1:1:n
    if((i>1)&&(Lambda(i,i)==Lambda(i-k,i-k)))
        temp(i,i)=t^k*exp(Lambda(i,i)*t);
        k=k+1;
    else
        k=1; 
        temp(i,i)=exp(Lambda(i,i)*t);
    end;
end;
Ft=simplify(LVector*temp);
disp('W(t)=');
disp(Ft);
F=simplify(Ft*inv(subs(Ft,t,tau)));
disp('F(t,tau)='); disp(F);
X=subs(F,tau,0)*X0+int(F*subs(f,t,tau),tau,t0,t);

t=t0:0.1:t0+2;
y=subs(X);
for i=1:1:n
    subplot(1,n,i);
    plot(t,y(i,:));
end;