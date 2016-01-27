hold on
syms x n ak ;
ak=2/sqrt(2*pi)*sin(x)/x;
x=1:0.001:15;
p=acos(subs(ak/abs(ak),x));
plot(x,p)

%line([x,x],[0,p],'Color','r','Marker','o','LineWidth',2);

for x=0:1:20;
    R=abs(subs(ak,x));
    line([x,x],[0,R],'Color','r','Marker','o','LineWidth',2);
end;