hold on
syms ck n real bk x w ak
ck=(-1i*w+2)/(w^2+4);
%int(exp(-2*x-1i*w*x),x,0,inf)/sqrt(2*pi)
%((-1)^w*2*sinh(2*pi))*(2/(4+w^2)-1i*w/(4+w^2))
%bk=4*((-1)^(n+1))/n;
ak=2/(w^2+4);
bk=imag(ck)%-w/(w^2+4);
%for x=0:1:15;
 %   R=abs(subs(sqrt(ak^2+bk^2),w,x));
  %  line([x,x],[0,R],'Color','r','Marker','o','LineWidth',2);
%end;
x=0:0.1:15;
p=abs(subs(sqrt(ak^2+bk^2),w,x));
plot(x,vpa(subs(p)));
disp(simplify(sqrt(ak^2+bk^2)))