hold on
syms cn n real bn(n) fi
bn(n)=2*(1-(-1)^n)/n^2;
fi=bn(n);
n=1:10;
%fi=pi/4-(((-1)^n)*pi)/4;
stem(bn(n));
bn(n)=acos(fi/abs(fi));
stem(bn(n));