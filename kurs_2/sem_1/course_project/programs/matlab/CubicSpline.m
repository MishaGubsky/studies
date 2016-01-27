syms X Y
hold on
X=[];
Y=[];
 x = [0.75 0.5 0.75 1.5 2.25 2.5 3 5 6.25 6.5 6.5 6.5 6.25 5 3 2.5 2.25 1.5 0.75 0.5 0.75];
 y = [1.4  1  0.6  0.4  0.7  0.9  0.85  0.75  0.8  0.85  1  1.15  1.2  1.25  1.15  1.1  1.3  1.6  1.4  1  0.6];
first=1; 
n=length(x);
N=100;
plot(x,y,'o');
for i=2:1:n-2
    xA=x(i-1);xB=x(i);xC=x(i+1);xD=x(i+2);
    yA=y(i-1);yB=y(i);yC=y(i+1);yD=y(i+2);
    a3=(-xA+3*(xB+xC)+xD)/6;b3=(-yA+3*(yB-yC)+yD)/6;
    a2=(xA-2*xB+xC)/2;b2=(yA-2*yB+yC)/2;
    a1=(xC-xA)/2;b1=(yC-yA)/2;
    a0=(xA+4*xB+xC)/6;b0=(yA+4*yB+yC)/6;
    for j=1:1:20
        t=j/N;
        X(j)=((a3*t+a2)*t+a1)*t+a0;
        Y(j)=((b3*t+b2)*t+b1)*t+b0;
        plot(X,Y);%'Color','g');
    end;
end;% 2.25 2.5 3 5 6.25 6.5 6.5 6.5 6.25 5 3 2.5 2.25 1.5 0.75 0.5 0.75

%  0.7  0.9  0.85  0.75  0.8  0.85  1  1.15  1.2  1.25  1.15  1.1  1.3  1.6  1.4  1  0.6
pp=cscvn([x;y]);
 disp(pp);
 fnplt(pp);
 pp=spaps(x,y);
 disp(pp);
 fnplt(pp);