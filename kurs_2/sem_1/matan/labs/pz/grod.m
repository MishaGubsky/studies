hold on
syms x n ak ;
ak=2/sqrt(2*pi)*sin(x)/x;
x=0:0.001:20;
p=abs(subs(ak,x));
plot(x,p)


for x=0:1:20;
    R=abs(subs(ak,x));
    line([x,x],[0,R],'Color','r','Marker','o','LineWidth',2);
end
