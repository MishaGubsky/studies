hold on
syms ck n real ak x
ak=2*(1-(-1)^n)/n^2;

for x=0:1:20;
    R=abs(subs(ak,n,x))
    line([x,x],[0,R],'Color','r','Marker','o','LineWidth',2);
end;


