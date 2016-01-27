syms y12(t) y11(t) y21(t) y22(t) W(t) W1 W2 tau Y X
A=[0 1;-4 -4];
W(t)=[y11(t) y12(t); y21(t) y22(t)];
Result=dsolve(diff(W,t)==A*W(t),W(0)==[1 0;0 1])
pretty([Result.y11;Result.y21]);
pretty([Result.y12;Result.y22]);
W(t)=[Result.y11 Result.y12;Result.y21 Result.y22];
Answer=W(t)* W(0)^(-1)*[1;1]+W(t)*int(W(tau)^(-1)*[0; tau*cos(tau)],tau,0,t)
disp(simplify(Answer))

at=-50:0.001:50;
%plot(subs(Answer(1),t,at),subs(Answer(2),t,at));

Y=dsolve('D2y==-4*Dy-4*y+t*cos(t)','y(0)==0','Dy(0)==1')
dY=diff(Y);
pretty(simplify(Y));
subplot(2,1,1);
plot(subs(dY,t,at),subs(Y,t,at));
subplot(2,1,2);
at=-50:0.001:50;
plot3(subs(dY,t,at),subs(Y,t,at),at);



%simplify(disp(int((inv(Result(tau))*[sin(tau);0]),tau,0,t)));
%Answer=W(t)*inv(W(0))*[1;1]+W(t)*(int(inv(W(tau))*[sin(tau);0],tau,0,t));
%Answer=(simplify(Answer))
%pretty([Answer.y11;Answer.y21])
%pretty([Answer.y12;Answer.y22])