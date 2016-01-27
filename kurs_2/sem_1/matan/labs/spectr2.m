syms ck n real bk fi
bk=(4*(-1)^(n+1)-2)/n;
fi=asin(bk/abs(bk));
ck=bk;
line([0,20],[pi/2,pi/2]);
Fi=asin(bk/abs(bk));
line([0,20],[pi/2,pi/2]);
for x=0:1:20;
R2=subs(Fi,x);
line([x,x],[0,R2],'Color','r','Marker','o','LineWidth',2);
R=subs(Bk,x);
line([x,x],[0,R],'Marker','x','LineWidth',2);
end;