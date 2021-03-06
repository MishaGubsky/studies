% ������������ ��������� �������
xr=normrnd(0, 1, 1, 2048);
% ��������� ������������������ ����
bx=fir1(512, 0.0125); % ������ ���
[h, w]=freqz(bx, 1, 512, 16000);
subplot(3,1,1);
plot(w, 20*log10(abs(h))); grid
xf=filter(bx, 1, xr); % ��������� ������� � ������� �������� 400��
subplot(3,1,2);
plot(xf); title('Sourse signal FS=16000 Hz')
x=xf(1:16:2048);
% ��������� ������� ������������� � 16 ��� �� 1000��
subplot(3,1,3);
plot(x); title('Sourse signal FS=1000 Hz')

% ������������ � ������� �-�������, ������������� � ����������
% �������������� ��� � ����������
figure(2);
subplot(4,1,1);

f1=fir1(32, 0.0125);
% ��������� ���������� ������� $ ���������� �������������� ���
[h, w]=freqz(f1, 1, 512, 16000);
plot(w, 20*log10(abs(h))); title('Based interpolaton FIR');

subplot(4,1,2);
bf=crbspl(f1, f1); % ������ ��������� �������
[Apass, Astop, wmax, An]=viewspi(400, 16, bf, 1000);
% �������� ��������� ������� ������������
[yb]=bintfir(x, bf); % ������������ �������
eb=xf(1:2000)-yb(48:2000+47);
% ������ ����������� (�������� ����������� ����������� ���������� pr)
%
%
% ������������ � ������� ����������� ���������� �������
subplot(4,1,3);
bh=spl1forr(16); % ������������ ����������� ���������� �������
[Apass, Astop, wmax, An]=viewsph(400, 16, 1000);
% �������� ��������� ������� ������������

yh=bintfir(x, bh, 0); % ������������ ������� ��� ����������
eh=xf(1:2000)-yh(1:2000); % ������ �����������
%
%
% ������������ � ������� ��������� ����� �-�������, �������������
% � ���������� �������������� ���
subplot(4,1,4);
h=tohermit(bf); % �������������� ��������� ������� � ��������� �����
[Apass, Astop, wmax, An]=viewspi(400, 16, h, 1000);
% �������� ��������� ������� ������������
ybh=bintfir(x, h, 0); % ������������ �������
efh=xf(1:2000)-ybh(1:2000); % ������ �����������
%
%
% ����������� �������� �����������
figure(3);
% ������ ���������-������. ������.:
[hf, w]=freqz(bf, 1, 512, 16000); % ������� �-�������
[hh, w]=freqz(bh, 1, 512, 16000); % ���������� ������� ������
[hq, w]=freqz(h, 1, 512, 16000); % �������� ����� �$�������
qz=0.0000001;

subplot(3,1,1);
plot(w,20*log10(abs(hf)/abs(hf(1))+qz), w,...
20*log10(abs(hh)/abs(hh(1))+qz), w,...
20*log10(abs(hq)/abs(hq(1))+qz));
subplot(3,1,2);
plot(1:2000,eb,1:2000,eh,1:2000,efh);

% ����������� ������������ ������������
subplot(3,1,3);
plot(1:64, 200*bf(1:64), 1:64, bh(1:64), 1:64, h(1:64));
% ����������� �������