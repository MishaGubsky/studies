# !/usr/bin/python
# -*- coding: utf-8 -*-
import numbers

__author__ = 'asaskevich'


class LinearFunction(object):
    """
    Класс линейной функции
    """

    def __init__(self, k=0, b=0):
        """
        kx + b
        :param k: коэффициент
        :param b: смещение
        """
        self.k = k
        self.b = b

    def __call__(self, x):
        # вызов через скобки ()
        if not isinstance(x, (numbers.Number, LinearFunction)):
            # не число и не линейная функция
            raise TypeError("x must be number or another linear function")
        if isinstance(x, LinearFunction):
            # ищем композицию
            return self * x
        else:
            # ищем значение в точке
            return self.k * x + self.b

    def __getitem__(self, item):
        # просчет через скобки [] -> f[x] = kx + b
        return self(item)

    def __eq__(self, other):
        if not isinstance(other, LinearFunction):
            raise TypeError("x must be another linear function")
        return self.k == other.k and self.b == other.b

    def __add__(self, other):
        # сумма
        if not isinstance(other, (numbers.Number, LinearFunction)):
            raise TypeError("x must be number or another linear function")
        if isinstance(other, LinearFunction):
            # сумма двух линейных функций
            return LinearFunction(self.k + other.k, self.b + other.b)
        else:
            # сумма смещений
            return LinearFunction(self.k, self.b + other)

    def __sub__(self, other):
        # разность
        if not isinstance(other, (numbers.Number, LinearFunction)):
            raise TypeError("x must be number or another linear function")
        if isinstance(other, LinearFunction):
            # разность линейных функций
            return LinearFunction(self.k - other.k, self.b - other.b)
        else:
            # разность смещений
            return LinearFunction(self.k, self.b - other)

    def __mul__(self, other):
        # произведение или композиция
        if not isinstance(other, (numbers.Number, LinearFunction)):
            raise TypeError("x must be number or another linear function")
        if isinstance(other, LinearFunction):
            # композиция
            return LinearFunction(self.k * other.k, self.b + other.b)
        else:
            # произведение
            return LinearFunction(self.k * other, self.b)

    def __neg__(self):
        # отрицание
        return LinearFunction(-self.k, self.b)

    def __str__(self):
        # строковое представление в виде k.kk x + b.bb
        return '{} x + {}'.format(round(self.k, 2), round(self.b, 2))
