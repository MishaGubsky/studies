% ��������� ������������ ��������� ������� �����
% ����� ������� �����
f = inline('1./(1+25*x.^2)');

% �������� ������� ��������
x = linspace(-1, 1, 10);
y = f(x);

% �������� ������-������������
xx = linspace(-1, 1, 100);
yy = spline(x, y, xx);

% �������� �������
axes('NextPlot', 'Add');
plot(x, y, 'LineWidth', 1);
% ������� �� ������� - �������������, ������ - ��������� �������.
plot(xx, yy, 'Color', 'r');