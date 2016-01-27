clc
clear
hold on;
syms x n bk p;
bk=4*((-1)^(n+1))/n;
Fi=simplify(asin(((4*(-1)^(n+1))/n)/abs(4*((-1)^(n+1))/n)))
line([0,0],[0,asin(-1)],'Color','r','Marker','o','LineWidth',2);
for x=1:1:20;
    p=subs(asin((-1)^(n+1)),x)
    line([x,x],[0,p],'Color','r','Marker','o','LineWidth',2);
    
end;