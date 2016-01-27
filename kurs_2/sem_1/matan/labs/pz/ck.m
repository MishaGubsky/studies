hold on
syms x n ak ;
x=1:0.001:20;
ck=1/sqrt(2*pi)*int((1+x)*exp(-1i*x*n),x,-1,0);
ck=ck+1/sqrt(2*pi)*int((1-x)*exp(-1i*x*n),x,0,1);
ak=imag(ck);
p=acos(ak/abs(ak))
%plot(x,p)
for x=0:1:20;
    R=abs(subs(p,x));
    line([x,x],[0,R],'Color','r','Marker','o','LineWidth',2);
end;