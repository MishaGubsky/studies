clc
clear
hold on;
syms x n ak p bk ck;
ck=1/sqrt(2*pi)*int((1+x)*exp(-1i*x*n),x,-1,0);
ck=ck+1/sqrt(2*pi)*int((1-x)*exp(-1i*x*n),x,0,1)
ak=real(ck)
bk=imag(ck)

Fi=acos(bk/abs(ck))
for x=0:1:20;
    p=subs(Fi,n,x)
    line([x,x],[0,p],'Color','r','Marker','o','LineWidth',2);
end;