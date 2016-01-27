hold on
% ������������ ��������� �������
xr=normrnd(0,1,1,2048);
%��������� ������������������ ����
bx=fir1(512,0.0125); %������ ���
[h,w]=freqz(bx,1,512,16000);

plot(w,20*log10(abs(h))); grid
xf=filter(bx,1,xr);%��������� �������� ������� �������� 400 Hz
plot(xf); title('Sourse signak FS=16000 Hz');
x=xf(1:16:2048);
%��������� ������������� � 16 ��� �� 1000Hz
plot(x); title('Sourse signak FS=1000 Hz');
%������������ � ������� �-�������, ������������� � ����������
%�������������� ��� � ����������
f1=fir1(32,0.0125);
%��������� ���������� ������� - ���������� �������������� ���
[h,w]=freqz(f1,1,512,16000);
plot(w,20*log10(abs(h))); title('Based interpolation FIR');

bf=bspline(f1)%������ ��������� �������

[Apass,Astop,wmax,An]=viewsh(400,16,bf,1000);

%�������� ��������� ������� ������������

yb=bintfir(x,bf);%������������ �������
eb=xf(1:2000)-yb(48:2000+47);%������ �����������

%������������ � ������� ����������� �������� �������
csapi(bf);
[Apass,Astop,wmax,An]=viewspi(400,16,1000);
%�������� ��������� ������� ������������
yb=bintfir(x,bf,0);%������������ ������� ��� ����������
eb=xf(1:2000)-yb(1:2000);%������ �����������
%������������ � ������� ��������� ����� �-�������, �������������
%� ���������� �������������� ���
h=toHermit(bf);%�������������� ��������� ������� � ��������� �����
[Apass,Astop,wmax,An]=viewspi(400,16,h,1000);
%�������� ��������� ������� ������������
yb=bintfir(x,h,0);%������������ ������� ��� ����������
eb=xf(1:2000)-yb(1:2000);%������ �����������
%����������� �������� �����������
[hf,w]=freqz(bf,1,512,16000);%������ ��� ������� �-�������
[hf,w]=freqz(bh,1,512,16000);%���������� ������� ������
[hf,w]=freqz(h,1,512,16000);%�������� ����� �-�������
qz=0.0000001;
plot(w,20*log10(abs(hf)/abs(hf(1))+qz),w,20*log10(abs(hh)/abs(hh(1))+qz),w,20*log10(abs(hq)/abs(hq(1))+qz));

plot(1:2000,eb,1:2000,eh,1:2000,efh);
%����������� ������������ ������������
plot(1:64,200*bf(1:64),1:64,bh(1:64),1:64,h(1:64));
%����������� �������





