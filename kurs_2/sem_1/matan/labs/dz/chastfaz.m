clc
clear
hold on;
syms x n bk p;
bk=((-1)^(n+1))/n;
Fi=acos(bk/abs(bk));
for x=0:1:20;
    p=subs(Fi,x);
    line([x,x],[0,p],'Color','r','Marker','o','LineWidth',2);
    
end;
x=0:0.001:20;
p=subs(Fi,x);
plot(x,vpa(subs(p)));