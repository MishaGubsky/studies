syms t tau F1 F

n=2;
A=[0,1;-1,-4];
t0=0;

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
        temp(i,i)=t^k*exp(Lambda(i,i)*t)/sqrt(1/2);
        k=k+1;
    else
        k=1; 
        temp(i,i)=exp(Lambda(i,i)*t)/sqrt(1/2);
    end;
end;
Ft=simplify(LVector*temp);
disp('W(t)=');
disp(Ft);


