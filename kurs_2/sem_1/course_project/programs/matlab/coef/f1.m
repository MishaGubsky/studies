syms t
x=[0 1 2 3 5];
y=[0 2 3 5 3];
p=[0 0.5 0.5 0.5 0];
h=[1 1 1 1];
t=[t t-1 t-2 t-3];
n=[2.56; -2.56; -3.98; -5.077; 5.077];
d=[0; 3.7; 0.32; 11.251; 0];
z=[0; -27.775; -6.38; 41.67];

for i=1:1:4
%d=1/h(i)*(n(i+1)-n(i))-1/h(i-1)*(n(i)-n(i-1))
%S=z(i)*(1-t(i))+z(i+1)*t(i)-h(i)^2/6*t(i)*(1-t(i))*((2-t(i))*n(i)+(1+t(i))*n(i+1));
%pretty(simplify(vpa(S)));
%a=(h(i-1)+h(i))/3+p(i-1)/(h(i-1))^2+(1/h(i-1)+1/h(i))^2*p(i)+p(i+1)/(h(i)^2)
%b=h(i)/6-((1/h(i-1)+1/h(i))*p(i)  +  ((1/h(i+1)+1/h(i))*p(i+1)))/h(i)
%c=1/(h(i)*h(i+1))*p(i+1)
%g=(y(i+1)-y(i))/h(i)-(y(i)-y(i-1))/h(i-1);
end;
z=y-p*d
a=[1 1 0 0 0; 1 3.2 -1.8 0.5 0; 0 -1.8 3.2 -1.8 0; 0 0 -1.8 3.2 1; 0 0 0 1 1];
g=[0;-1;1;-4;0];
n=a^(-1)*g




fr=[0 1 2 3 4];
n=length(fr);
for i=1:1:n-1
    H=fr(i+1)-fr(i);
end;
h =H




