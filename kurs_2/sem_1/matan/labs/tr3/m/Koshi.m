syms y12(t) y11(t) y21(t) y22(t) W(t) W1 W2 tau Y X
at=0:0.01:50;
A=[0 1;-4 -4];
W(t)=[y11(t) y12(t); y21(t) y22(t)];
Result=dsolve(diff(W,t)==A*W(t),W(0)==[1 0;0 1]);
W(t)= simplify([Result.y11, Result.y12; Result.y21,Result.y22]);
Answer=W(t)*W(0)^(-1)*[0;0]+W(t)*int(W(tau)^(-1)*[0;tau*cos(tau)],tau,0,t)
fprintf('Answer=');
pretty(simplify(Answer));
subplot(3,1,1);
plot(at,subs(Answer(1),t,at))
subplot(3,1,2);
plot(subs(Answer(1),t,at),subs(Answer(2),t,at))
subplot(3,1,3)
plot3(subs(Answer(1),t,at),subs(Answer(2),t,at),at);