syms y12(t) y11(t) y21(t) y22(t) W(t) tau
A=[0 1;-5 -2];
W(t)=[y11(t) y12(t); y21(t) y22(t)];
Res=dsolve(diff(W,t)==A*W(t),W(0)==[1 0;0 1]);
W(t)= simplify([Res.y11, Res.y12; Res.y21,Res.y22]);
F=[0;4*exp(-tau)+17*sin(2*tau)];
Answer=W(t)*W(0)^(-1)*[0;0]+int(W(t)*W(tau)^(-1)*F,tau,0,t);
pretty(simplify(Answer));
at=0:0.1:30;
subplot(3,1,1);
plot(at,subs(Answer(1),t,at))
subplot(3,1,2);
plot(subs(Answer(1),t,at),subs(Answer(2),t,at));
subplot(3,1,3);
plot3(subs(Answer(1),t,at),subs(Answer(2),t,at),at)