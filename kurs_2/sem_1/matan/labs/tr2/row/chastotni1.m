hold on
syms ck n real bk x
bk=4*((-1)^(n+1))/n;
line([0,0],[0,1],'Color','r','Marker','o','LineWidth',2);
for x=1:1:20;
    R=abs(subs(bk,n,x))
    line([x,x],[0,R],'Color','r','Marker','o','LineWidth',2);
end;
%x=0:0.1:20;
%R=abs(subs(bk,n,x));
%plot(x,R);
