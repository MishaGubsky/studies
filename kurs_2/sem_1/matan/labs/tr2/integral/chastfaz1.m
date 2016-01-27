clc
clear
hold on;
syms x n bk p w;
ck=int(exp(-2*x-1i*w*x),x,0,inf)/sqrt(2*pi)
ak=real(ck)%((-1)^w*2*sinh(2*pi))*2/(4+w^2)
bk=imag(ck)


Fi=atan(bk/ak);
%for x=0:1:15;
 %   p=subs(Fi,x);
  %  line([x,x],[0,p],'Color','r','Marker','o','LineWidth',2);
%end;
x=0:0.1:15;
p=subs(Fi,x);
plot(x,vpa(subs(p)));